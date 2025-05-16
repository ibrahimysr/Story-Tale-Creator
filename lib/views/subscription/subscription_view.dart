// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:masal/core/extension/context_extension.dart';
// import 'package:masal/core/theme/space_theme.dart';
// import 'package:masal/core/theme/widgets/starry_background.dart';
// import 'package:collection/collection.dart';

// const String _premiumUnlock = 'com.temizlikcin.masal.premium_unlock'; 

// class PremiumPurchaseView extends StatefulWidget {
//   const PremiumPurchaseView({super.key});

//   @override
//   State<PremiumPurchaseView> createState() => _PremiumPurchaseViewState();
// }

// class _PremiumPurchaseViewState extends State<PremiumPurchaseView> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//   List<ProductDetails> _products = [];
//   bool _purchasePending = false;
//   bool _loading = true;
//   bool _isPurchased = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializePurchaseStream();
//     _initStoreAndPurchaseStatus();
//   }

//   void _initializePurchaseStream() {
//     final purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       _listenToPurchaseUpdated,
//       onDone: () => _subscription?.cancel(),
//       onError: (error) {
//         _showSnackBar('Satın alma akışında bir hata oluştu.', Colors.red);
//       },
//     );
//   }

//   Future<void> _initStoreAndPurchaseStatus() async {
//     setState(() => _loading = true);
//     try {
//       await _checkPurchaseStatus();

//       final bool isAvailable = await _inAppPurchase.isAvailable();
//       if (!isAvailable) {
//         setState(() {
//           _errorMessage = 'Mağaza bağlantısı kurulamadı. Lütfen internetinizi kontrol edin.';
//           _loading = false;
//         });
//         return;
//       }

//       final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({_premiumUnlock});
//       if (response.error != null || response.productDetails.isEmpty) {
//         setState(() {
//           _errorMessage = 'Ürün bilgileri alınamadı. Lütfen daha sonra tekrar deneyin.';
//           _products = response.productDetails;
//           _loading = false;
//         });
//         return;
//       }

//       setState(() {
//         _products = response.productDetails;
//         _errorMessage = null;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Bağlantı hatası oluştu. Lütfen internetinizi kontrol edin.';
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _checkPurchaseStatus() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         setState(() => _isPurchased = false);
//         return;
//       }
//       final DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
//       setState(() {
//         _isPurchased = userDoc.exists && userDoc['subscribed'] == true;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Satın alma durumu kontrol edilemedi.';
//         _isPurchased = false; 
//       });
//     }
//   }

//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         setState(() => _purchasePending = true);
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           _handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           await _deliverProduct(purchaseDetails);
//         } else if (purchaseDetails.status == PurchaseStatus.canceled) {
//           setState(() => _purchasePending = false);
//           _showSnackBar('Satın alma işlemi iptal edildi.', Colors.orange);
//         }

//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     }
//   }

//   void _handleError(IAPError error) {
//     setState(() => _purchasePending = false);
//     _showSnackBar('Satın alma sırasında bir hata oluştu: ${error.message}', Colors.red);
//   }

//   Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         setState(() => _purchasePending = false);
//         _showSnackBar('Satın alma için oturum açmanız gerekiyor.', Colors.red);
//         return;
//       }

//       final String userId = currentUser.uid;
//       await _firestore.collection('users').doc(userId).set({
//         'subscribed': true,
//         'purchaseDate': FieldValue.serverTimestamp(),
//         'purchaseId': purchaseDetails.purchaseID,
//       }, SetOptions(merge: true));

//       await _firestore.collection('users').doc(userId).collection('purchases').add({
//         'purchaseDate': FieldValue.serverTimestamp(),
//         'purchaseID': purchaseDetails.purchaseID,
//         'productID': purchaseDetails.productID,
//         'platform': Platform.isIOS ? 'ios' : 'android',
//       });

//       setState(() {
//         _purchasePending = false;
//         _isPurchased = true;
//       });
//       _showSnackBar('Premium erişim başarıyla satın alındı!', SpaceTheme.accentPurple);
//     } catch (e) {
//       setState(() => _purchasePending = false);
//       _showSnackBar('Satın alma başarılı, ancak hesap güncellenirken hata oluştu.', Colors.orange);
//     }
//   }

//   Future<void> _buyProduct(ProductDetails productDetails) async {
//     final User? currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       _showSnackBar('Satın alma için lütfen oturum açın.', Colors.red);
//       return;
//     }

//     try {
//       final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     } catch (e) {
//       _showSnackBar('Satın alma başlatılamadı. Lütfen tekrar deneyin.', Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color backgroundColor) {
//     if (!mounted) return; 
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: backgroundColor),
//     );
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: SpaceTheme.primaryDark,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text('Premium Erişim', style: SpaceTheme.titleStyle.copyWith(fontSize: 24)),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           const StarryBackground(),
//           SafeArea(
//             child: _loading
//                 ? Center(child: CircularProgressIndicator(color: SpaceTheme.accentPurple))
//                 : SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Padding(
//                       padding: context.paddingNormal,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(height: context.getDynamicHeight(2)),
//                           _buildHeader(context),
//                           SizedBox(height: context.getDynamicHeight(3)),
//                           _buildBenefits(context),
//                           SizedBox(height: context.getDynamicHeight(1)),
//                           _buildPricing(context),
//                           SizedBox(height: context.getDynamicHeight(3)),
//                           _buildPurchaseButton(context),
//                           if (_errorMessage != null)
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 _errorMessage!,
//                                 style: const TextStyle(color: Colors.red),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Column(
//       children: [
//         Icon(
//           Icons.star,
//           size: 80,
//           color: SpaceTheme.accentGold,
//           shadows: [Shadow(color: SpaceTheme.accentPurple, blurRadius: 15)],
//         ),
//         SizedBox(height: context.getDynamicHeight(2)),
//         Text(
//           'Galaksiye Özel Erişim!',
//           style: SpaceTheme.titleStyle.copyWith(fontSize: 28, color: Colors.white),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: context.getDynamicHeight(1)),
//         Text(
//           'Uzaycık Masalları ile sınırsız masal yaratma keyfini bir defalık satın alarak yaşa!',
//           style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildBenefits(BuildContext context) {
//     final benefits = [
//       {'text': 'Sınırsız Masal Oluşturma', 'icon': Icons.auto_awesome},
//       {'text': 'Özel İçeriklere Erişim', 'icon': Icons.lock_open},
//     ];

//     return Column(
//       children: benefits.map((benefit) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(benefit['icon'] as IconData, color: SpaceTheme.accentGold, size: 30),
//               SizedBox(width: context.getDynamicWidth(3)),
//               Text(
//                 benefit['text'] as String,
//                 style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildPricing(BuildContext context) {
//     final product = _products.firstWhereOrNull((p) => p.id == _premiumUnlock);
//     return Text(
//       product != null ? '${product.price} / Tek Seferlik' : 'Fiyat bilgisi yüklenemedi',
//       style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//       textAlign: TextAlign.center,
//     );
//   }

//   Widget _buildPurchaseButton(BuildContext context) {
//     if (_isPurchased) {
//       return const Text(
//         'Premium Erişiminiz Aktif!',
//         style: TextStyle(color: Colors.green, fontSize: 18),
//       );
//     }

//     final product = _products.firstWhereOrNull((p) => p.id == _premiumUnlock);
//     final bool canPurchase = product != null && !_purchasePending;

//     return ElevatedButton(
//       onPressed: canPurchase
//           ? () async => await _buyProduct(product)
//           : _errorMessage != null
//               ? () async => await _initStoreAndPurchaseStatus()
//               : null,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: SpaceTheme.accentPurple,
//         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         elevation: 5,
//         shadowColor: SpaceTheme.accentPurple.withValues(alpha: 0.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.star, color: SpaceTheme.accentGold, size: 24),
//           SizedBox(width: context.getDynamicWidth(2)),
//           Text(
//             canPurchase ? 'Satın Al!' : 'Yeniden Dene',
//             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:collection/collection.dart';

const String _premiumUnlockAndroid = 'com.temizlikcin.masal.premium_unlock';
const String _premiumUnlockIOS = 'com.temizlikcin.masal.premium_unlock';

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
  bool _purchasePending = false;
  bool _loading = true;
  bool _isPurchased = false;
  bool _isSandboxEnvironment = false; 
  String? _errorMessage;

  String get _premiumProductId => Platform.isIOS ? _premiumUnlockIOS : _premiumUnlockAndroid;

  @override
  void initState() {
    super.initState();
    _initializePurchaseStream();
    _initStoreAndPurchaseStatus();
  }

  void _initializePurchaseStream() {
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        final message = Platform.isIOS 
            ? 'StoreKit satın alma akışında hata: $error' 
            : 'Satın alma akışında bir hata oluştu.';
        _showSnackBar(message, Colors.red);
      },
    );
  }

  Future<void> _initStoreAndPurchaseStatus() async {
    setState(() => _loading = true);
    try {
      await _checkPurchaseStatus();
      
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        setState(() {
          _errorMessage = Platform.isIOS 
              ? 'App Store bağlantısı kurulamadı. Lütfen internetinizi kontrol edin veya Apple ID ile giriş yaptığınızdan emin olun.' 
              : 'Google Play Store bağlantısı kurulamadı. Lütfen internetinizi kontrol edin.';
          _loading = false;
        });
        return;
      }

      if (Platform.isIOS) {
        await _checkSandboxStatus();
      }

      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({_premiumProductId});
      if (response.error != null || response.productDetails.isEmpty) {
        setState(() {
          _errorMessage = Platform.isIOS 
              ? 'App Store\'dan ürün bilgileri alınamadı. Lütfen daha sonra tekrar deneyin.' 
              : 'Ürün bilgileri alınamadı. Lütfen daha sonra tekrar deneyin.';
          _products = response.productDetails;
          _loading = false;
        });
        return;
      }

      setState(() {
        _products = response.productDetails;
        _errorMessage = null;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bağlantı hatası oluştu. Lütfen internetinizi kontrol edin.';
        _loading = false;
      });
      print('IAP init error: $e'); 
    }
  }

  Future<void> _checkSandboxStatus() async {
    _isSandboxEnvironment = false;
    print('iOS Sandbox Environment: $_isSandboxEnvironment');
  }

  Future<void> _checkPurchaseStatus() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        setState(() => _isPurchased = false);
        return;
      }

      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      
      if (Platform.isIOS) {
        print('User document exists: ${userDoc.exists}');
        if (userDoc.exists) {
          print('User subscription status: ${userDoc['subscribed']}');
        }
      }
      
      setState(() {
        _isPurchased = userDoc.exists && userDoc['subscribed'] == true;
      });
    } catch (e) {
      print('Error checking purchase status: $e'); 
      setState(() {
        _errorMessage = 'Satın alma durumu kontrol edilemedi.';
        _isPurchased = false;
      });
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (Platform.isIOS) {
        print('Purchase update: ${purchaseDetails.status}');
        print('Product ID: ${purchaseDetails.productID}');
        if (purchaseDetails.error != null) {
          print('Error: ${purchaseDetails.error!.message}, code: ${purchaseDetails.error!.code}');
        }
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _deliverProduct(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() => _purchasePending = false);
          _showSnackBar('Satın alma işlemi iptal edildi.', Colors.orange);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _handleError(IAPError error) {
    setState(() => _purchasePending = false);
    
    if (Platform.isIOS) {
      switch(error.code) {
        case 'purchase_cancelled':
          _showSnackBar('Satın alma iptal edildi.', Colors.orange);
          return;
        case 'product_not_available':
          _showSnackBar('Ürün şu anda App Store\'da mevcut değil.', Colors.red);
          return;
        case 'payment_invalid':
          _showSnackBar('Ödeme geçersiz. Lütfen ödeme yönteminizi kontrol edin.', Colors.red);
          return;
        default:
          _showSnackBar('App Store hatası: ${error.message}', Colors.red);
          return;
      }
    }
    
    _showSnackBar('Satın alma sırasında bir hata oluştu: ${error.message}', Colors.red);
  }

  Future<bool> _verifyiOSPurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (!Platform.isIOS) return true;
      
      final String? localVerificationData = purchaseDetails.verificationData.localVerificationData;
      final String? serverVerificationData = purchaseDetails.verificationData.serverVerificationData;
      
      print('iOS Local Verification Data: ${localVerificationData?.substring(0, 50)}...');
      print('iOS Server Verification Data: ${serverVerificationData?.substring(0, 50)}...');
      
      
      
      return true;
    } catch (e) {
      print('iOS verification error: $e');
      return false;
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    bool verificationSuccess = true;
    
    try {
      if (Platform.isIOS) {
        verificationSuccess = await _verifyiOSPurchase(purchaseDetails);
        if (!verificationSuccess) {
          _showSnackBar('Satın alma doğrulanamadı. Lütfen destek ile iletişime geçin.', Colors.red);
          return;
        }
      }
      
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        setState(() => _purchasePending = false);
        _showSnackBar('Satın alma için oturum açmanız gerekiyor.', Colors.red);
        return;
      }

      final String userId = currentUser.uid;
      
      await _firestore.collection('users').doc(userId).set({
        'subscribed': true,
        'purchaseDate': FieldValue.serverTimestamp(),
        'purchaseId': purchaseDetails.purchaseID,
        'platform': Platform.isIOS ? 'ios' : 'android',
      }, SetOptions(merge: true));

      await _firestore.collection('users').doc(userId).collection('purchases').add({
        'purchaseDate': FieldValue.serverTimestamp(),
        'purchaseID': purchaseDetails.purchaseID,
        'productID': purchaseDetails.productID,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'transactionDate': purchaseDetails.transactionDate,
        if (Platform.isIOS) 'verificationData': {
          'source': purchaseDetails.verificationData.source,
          'localVerificationDataExists': purchaseDetails.verificationData.localVerificationData ,
          'serverVerificationDataExists': purchaseDetails.verificationData.serverVerificationData 
        },
      });

      setState(() {
        _purchasePending = false;
        _isPurchased = true;
      });
      _showSnackBar('Premium erişim başarıyla satın alındı!', SpaceTheme.accentPurple);
    } catch (e) {
      print('Error during product delivery: $e'); 
      setState(() => _purchasePending = false);
      _showSnackBar('Satın alma başarılı, ancak hesap güncellenirken hata oluştu.', Colors.orange);
    } finally {
      if (purchaseDetails.pendingCompletePurchase) {
        try {
          await _inAppPurchase.completePurchase(purchaseDetails);
          print('Purchase completed successfully');
        } catch (e) {
          print('Error completing purchase: $e');
        }
      }
    }
  }

  Future<void> _buyProduct(ProductDetails productDetails) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showSnackBar('Satın alma için lütfen oturum açın.', Colors.red);
      return;
    }

    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      
      if (Platform.isIOS) {
        print('Starting iOS purchase for product: ${productDetails.id}');
        print('Price: ${productDetails.price}');
      }
      
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('Error initiating purchase: $e'); 
      _showSnackBar('Satın alma başlatılamadı. Lütfen tekrar deneyin.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
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
        title: Text('Premium Erişim', style: SpaceTheme.titleStyle.copyWith(fontSize: 24)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const StarryBackground(),
          SafeArea(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: SpaceTheme.accentPurple))
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
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (Platform.isIOS)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                _isSandboxEnvironment ? 'iOS Sandbox Test Mode' : 'iOS Production Mode',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
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
          shadows: [Shadow(color: SpaceTheme.accentPurple, blurRadius: 15)],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          'Galaksiye Özel Erişim!',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 28, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          'Uzaycık Masalları ile sınırsız masal yaratma keyfini bir defalık satın alarak yaşa!',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
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
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(benefit['icon'] as IconData, color: SpaceTheme.accentGold, size: 30),
              SizedBox(width: context.getDynamicWidth(3)),
              Text(
                benefit['text'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricing(BuildContext context) {
    final product = _products.firstWhereOrNull((p) => p.id == _premiumProductId);
    return Text(
      product != null ? '${product.price} / Tek Seferlik' : 'Fiyat bilgisi yüklenemedi',
      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    if (_isPurchased) {
      return const Text(
        'Premium Erişiminiz Aktif!',
        style: TextStyle(color: Colors.green, fontSize: 18),
      );
    }

    final product = _products.firstWhereOrNull((p) => p.id == _premiumProductId);
    final bool canPurchase = product != null && !_purchasePending;

    return ElevatedButton(
      onPressed: canPurchase
          ? () async => await _buyProduct(product)
          : _errorMessage != null
              ? () async => await _initStoreAndPurchaseStatus()
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: SpaceTheme.accentPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
        shadowColor: SpaceTheme.accentPurple.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: SpaceTheme.accentGold, size: 24),
          SizedBox(width: context.getDynamicWidth(2)),
          Text(
            canPurchase ? 'Satın Al!' : 'Yeniden Dene',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}