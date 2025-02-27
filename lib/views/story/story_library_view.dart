import 'package:flutter/material.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'story_display_view.dart';

class StoryLibraryView extends StatefulWidget {
  const StoryLibraryView({Key? key}) : super(key: key);

  @override
  State<StoryLibraryView> createState() => _StoryLibraryViewState();
}

class _StoryLibraryViewState extends State<StoryLibraryView> {
  bool _isLoading = true;
  List<DocumentSnapshot> _stories = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  // Kullanıcının hikayelerini yükleme fonksiyonu
  Future<void> _loadStories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Hikayeleri görüntülemek için giriş yapmalısınız!';
        });
        return;
      }

      // Sorguyu basitleştirdik
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userStories')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Belgeleri tarihe göre sıralama işlemini uygulama tarafında yapıyoruz
      final sortedDocs = snapshot.docs.toList()
        ..sort((a, b) {
          final aDate = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
          final bDate = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
          if (aDate == null || bDate == null) return 0;
          return bDate.compareTo(aDate); // Yeniden eskiye sıralama
        });

      setState(() {
        _stories = sortedDocs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Hikayeler yüklenirken bir hata oluştu: ${e.toString()}';
      });
    }
  }

  // Bir hikayeyi silme fonksiyonu
  Future<void> _deleteStory(DocumentSnapshot story) async {
    try {
      // Firestore'dan hikayeyi sil
      await FirebaseFirestore.instance
          .collection('userStories')
          .doc(story.id)
          .delete();

      // Eğer yerel bir resim varsa onu da sil
      final data = story.data() as Map<String, dynamic>;
      if (data['hasImage'] == true && data['imageFileName'] != null) {
        try {
          final directory = await getApplicationDocumentsDirectory().catchError((error) {
            print('Dizin alma hatası: $error');
            return Directory('storage/emulated/0/Download');
          });
          
          final filePath = '${directory.path}/${data['imageFileName']}';
          final file = File(filePath);
          
          if (await file.exists()) {
            await file.delete();
            print('Resim dosyası silindi: ${data['imageFileName']}');
          }
        } catch (e) {
          print('Resim silme hatası: $e');
        }
      }

      // Listeyi güncelle
      setState(() {
        _stories.remove(story);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Hikaye başarıyla silindi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: SpaceTheme.accentPurple.withOpacity(0.8),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Hikaye silinirken bir hata oluştu: ${e.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }

  // Silme onay dialogu
  Future<void> _confirmDelete(DocumentSnapshot story) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SpaceTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: SpaceTheme.accentPurple.withOpacity(0.5),
              width: 2,
            ),
          ),
          title: const Text(
            'Hikayeyi Sil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bu hikayeyi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'İptal',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Sil',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStory(story);
              },
            ),
          ],
        );
      },
    );
  }

  // Hikaye detayını gösterme fonksiyonu
  void _viewStoryDetail(DocumentSnapshot story) async {
    final data = story.data() as Map<String, dynamic>;
    final storyText = data['story'] as String;
    
    // Eğer resim varsa, resmi yükle
    Uint8List? imageBytes;
    if (data['hasImage'] == true && data['imageFileName'] != null) {
      try {
        print('Resim yükleme başlıyor...');
        print('Resim dosya adı: ${data['imageFileName']}');
        
        final directory = await getApplicationDocumentsDirectory().catchError((error) {
          print('Dizin alma hatası: $error');
          return Directory('storage/emulated/0/Download');
        });
        
        final filePath = '${directory.path}/${data['imageFileName']}';
        print('Resim yolu: $filePath');
        
        final file = File(filePath);
        if (await file.exists()) {
          print('Resim dosyası bulundu');
          imageBytes = await file.readAsBytes();
          print('Resim başarıyla yüklendi: ${imageBytes.length} bytes');
        } else {
          print('Resim dosyası bulunamadı: $filePath');
        }
      } catch (e) {
        print('Resim yükleme hatası: $e');
      }
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDisplayView(
          story: storyText,
          image: imageBytes,
        ),
      ),
    );
  }

  // Tarih formatlama fonksiyonu
  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<Uint8List?> _loadThumbnail(String imageFileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory().catchError((error) {
        print('Dizin alma hatası: $error');
        return Directory('storage/emulated/0/Download');
      });
      
      final filePath = '${directory.path}/$imageFileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      print('Önizleme yükleme hatası: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Hikaye Kütüphanem',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: SpaceTheme.iconContainerDecoration,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
            onPressed: _loadStories,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: SpaceTheme.mainGradient,
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: StarryBackground(),
            ),
            SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: SpaceTheme.accentPurple,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red[300],
                                size: 60,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _loadStories,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SpaceTheme.accentBlue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Tekrar Dene',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _stories.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book,
                                    color: Colors.amber[100],
                                    size: 60,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Henüz kaydedilmiş hikayeniz yok',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Yeni bir hikaye oluşturun ve kaydedin!',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _stories.length,
                                itemBuilder: (context, index) {
                                  final story = _stories[index];
                                  final data = story.data() as Map<String, dynamic>;
                                  final hasImage = data['hasImage'] ?? false;
                                  final createdAt = data['createdAt'] as Timestamp?;
                                  final storyText = data['story'] as String;
                                  final storyPreview = storyText.length > 100
                                      ? '${storyText.substring(0, 100)}...'
                                      : storyText;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: SpaceTheme.accentPurple.withOpacity(0.2),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _viewStoryDetail(story),
                                          splashColor: SpaceTheme.accentPurple.withOpacity(0.3),
                                          highlightColor: SpaceTheme.accentPurple.withOpacity(0.1),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Üst kısım: Tarih ve Silme butonu
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          createdAt != null
                                                              ? _formatDate(createdAt)
                                                              : 'Tarih bilgisi yok',
                                                          style: TextStyle(
                                                            color: Colors.amber[100],
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors.red[300],
                                                            size: 22,
                                                          ),
                                                          onPressed: () => _confirmDelete(story),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // Alt kısım: Resim ve Yazı
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Resim
                                                        if (data['hasImage'] == true && data['imageFileName'] != null)
                                                          FutureBuilder<Uint8List?>(
                                                            future: _loadThumbnail(data['imageFileName']),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                return Container(
                                                                  width: 80,
                                                                  height: 80,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey[800],
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: const Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: SpaceTheme.accentPurple,
                                                                      strokeWidth: 2,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              
                                                              if (snapshot.hasData) {
                                                                return Container(
                                                                  width: 80,
                                                                  height: 80,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: SpaceTheme.accentPurple.withOpacity(0.2),
                                                                        blurRadius: 8,
                                                                        spreadRadius: 1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                    child: Image.memory(
                                                                      snapshot.data!,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              
                                                              return Container(
                                                                width: 80,
                                                                height: 80,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[800],
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: const Center(
                                                                  child: Icon(
                                                                    Icons.image_not_supported,
                                                                    color: Colors.white54,
                                                                    size: 24,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        if (data['hasImage'] == true && data['imageFileName'] != null)
                                                          const SizedBox(width: 16),
                                                        // Yazı ve Hikayeyi Oku butonu
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                storyPreview,
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 16,
                                                                  height: 1.4,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 12),
                                                              Align(
                                                                alignment: Alignment.centerRight,
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 16,
                                                                    vertical: 8,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: SpaceTheme.accentBlue.withOpacity(0.3),
                                                                    borderRadius: BorderRadius.circular(15),
                                                                  ),
                                                                  child: const Text(
                                                                    'Hikayeyi Oku',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}