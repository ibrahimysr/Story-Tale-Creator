import 'dart:async'; 
import 'dart:io'; 
import 'package:flutter/material.dart'; 
import 'package:in_app_purchase/in_app_purchase.dart'; 
import 'package:in_app_purchase_android/in_app_purchase_android.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:masal/core/extension/context_extension.dart'; 
import 'package:masal/core/theme/space_theme.dart'; 
import 'package:masal/core/theme/widgets/starry_background.dart';

const String _premiumUnlock = 'com.your_company.masal.premium_unlock';

class PremiumPurchaseView extends StatefulWidget {
  const PremiumPurchaseView({super.key});

  @override
  State<PremiumPurchaseView> createState() => _PremiumPurchaseViewState();
}

class _PremiumPurchaseViewState extends State<PremiumPurchaseView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  bool _isPurchased = false; 
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Satın alma akışında hata: $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
    _initStoreAndPurchaseStatus();
  }

  Future<void> _initStoreAndPurchaseStatus() async {
    try {
      await _checkPurchaseStatus();

      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        setState(() {
          _isAvailable = isAvailable;
          _products = [];
          _purchasePending = false;
          _loading = false;
        });
        return;
      }

      final ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails({_premiumUnlock});

      if (productDetailResponse.error != null) {
        setState(() {
          _queryProductError = productDetailResponse.error!.message;
          _isAvailable = isAvailable;
          _products = productDetailResponse.productDetails;
          _purchasePending = false;
          _loading = false;
        });
        return;
      }

      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchasePending = false;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _queryProductError = 'Mağaza başlatılırken hata: $e';
        _loading = false;
      });
    }
  }

  Future<void> _checkPurchaseStatus() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        setState(() {
          _isPurchased = userDoc.exists && userDoc['subscribed'] == true;
        });
      }
    } catch (e) {
      print('Satın alma durumu kontrol edilirken hata: $e');
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _deliverProduct(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _purchasePending = false;
          });
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Satın alma sırasında hata: ${error.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

 Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
  try {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Kullanıcı oturum açmamış!');
    }
    
    String userId = currentUser.uid;
    
    await _firestore.collection('users').doc(userId).set({
      'subscribed': true, 
      'purchaseDate': FieldValue.serverTimestamp(),
      'purchaseId': purchaseDetails.purchaseID,
    }, SetOptions(merge: true));
    
    await _firestore.collection('users').doc(userId).collection('purchases').add({
      'purchaseDate': FieldValue.serverTimestamp(),
      'purchaseID': purchaseDetails.purchaseID,
      'productID': purchaseDetails.productID,
      'platform': 'android',
    });
    
    setState(() {
      _purchasePending = false;
      _isPurchased = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Premium erişim başarıyla satın alındı!'),
        backgroundColor: SpaceTheme.accentPurple,
      ),
    );
  } catch (e) {
    print('Satın alma verisi güncellenirken hata: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Satın alma başarılı, ancak hesap güncellenirken hata oluştu. Lütfen destekle iletişime geçin.'),
        backgroundColor: Colors.orange,
      ),
    );
    setState(() {
      _purchasePending = false;
    });
  }
}

  Future<void> _buyProduct(ProductDetails productDetails) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );

      if (Platform.isAndroid) {
        final androidPlatformAddition =
            _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      }

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Satın alma başlatılırken hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Premium Erişim',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          StarryBackground(),
          SafeArea(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: SpaceTheme.accentPurple,
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: context.paddingNormal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: context.getDynamicHeight(2)),
                          _buildHeader(context),
                          SizedBox(height: context.getDynamicHeight(3)),
                          _buildBenefits(context),
                          SizedBox(height: context.getDynamicHeight(1)),
                          _buildPricing(context),
                          SizedBox(height: context.getDynamicHeight(3)),
                          _buildPurchaseButton(context),
                          SizedBox(height: context.getDynamicHeight(2)),
                          if (!_isAvailable)
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Mağaza bağlantısı kurulamadı. Lütfen daha sonra tekrar deneyin.',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          if (_queryProductError != null)
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Hata: $_queryProductError',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.star,
          size: 80,
          color: SpaceTheme.accentGold,
          shadows: [
            Shadow(color: SpaceTheme.accentPurple, blurRadius: 15),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          'Galaksiye Özel Erişim!',
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          'Uzaycık Masalları ile sınırsız masal yaratma keyfini bir defalık satın alarak yaşa!',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBenefits(BuildContext context) {
    final benefits = [
      {'text': 'Sınırsız Masal Oluşturma', 'icon': Icons.auto_awesome},
      {'text': 'Özel İçeriklere Erişim', 'icon': Icons.lock_open},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                benefit['icon'] as IconData,
                color: SpaceTheme.accentGold,
                size: 30,
              ),
              SizedBox(width: context.getDynamicWidth(3)),
              Text(
                benefit['text'] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricing(BuildContext context) {
    return Text(
      '49.99 TL / Tek Seferlik',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    if (_isPurchased) {
      return Text(
        'Premium Erişiminiz Aktif!',
        style: TextStyle(color: Colors.green, fontSize: 18),
      );
    }

    return ElevatedButton(
      onPressed: _products.isNotEmpty && !_purchasePending
          ? () async {
              await _buyProduct(
                  _products.firstWhere((product) => product.id == _premiumUnlock));
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: SpaceTheme.accentPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        shadowColor: SpaceTheme.accentPurple.withValues(alpha: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: SpaceTheme.accentGold,
            size: 24,
          ),
          SizedBox(width: context.getDynamicWidth(2)),
          Text(
            'Satın Al!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}