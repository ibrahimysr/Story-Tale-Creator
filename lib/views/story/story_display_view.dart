import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart' show PathProviderException;

class StoryDisplayView extends StatelessWidget {
  final String story;
  final Uint8List? image;

  const StoryDisplayView({
    super.key,
    required this.story,
    this.image,
  });

  // Resmi yerel depolamaya kaydetme fonksiyonu
  Future<String?> _saveImageToLocalStorage(Uint8List imageData, String userId) async {
    try {
      print('Resim kaydetme işlemi başladı');
      // Uygulama dokümanları dizinini al
      final directory = await getApplicationDocumentsDirectory().catchError((error) {
        print('Dizin alma hatası: $error');
        return Directory('storage/emulated/0/Download');  // Android için fallback
      });
      
      print('Dizin yolu: ${directory.path}');
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = Random().nextInt(10000);
      
      // Benzersiz bir dosya adı oluştur
      final fileName = 'story_image_${userId}_${timestamp}_$random.jpg';
      final filePath = '${directory.path}/$fileName';
      
      print('Oluşturulan dosya yolu: $filePath');
      
      // Dizinin varlığını kontrol et ve oluştur
      if (!await directory.exists()) {
        print('Dizin oluşturuluyor...');
        await directory.create(recursive: true);
      }
      
      // Resmi kaydet
      final file = File(filePath);
      await file.writeAsBytes(imageData);
      print('Resim başarıyla kaydedildi: $fileName');
      
      return fileName;
    } catch (e) {
      print('Resim kaydetme hatası detayı: $e');
      return null;
    }
  }

  // Hikayeyi Firebase'e kaydetme fonksiyonu
  Future<void> _saveStoryToFirebase(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                'Hikayeyi kaydetmek için giriş yapmalısınız!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            backgroundColor: Colors.red.withOpacity(0.8),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
        return;
      }

      print('Resim kaydetme başlıyor...');
      print('Gelen image değeri: ${image != null ? 'var' : 'yok'}');
      
      String? imageFileName;
      if (image != null) {
        print('Resim kaydetme deneniyor...');
        imageFileName = await _saveImageToLocalStorage(image!, user.uid);
        print('Kaydedilen resim dosya adı: $imageFileName');
      }

      print('Firebase\'e kaydedilecek veriler:');
      final storyData = {
        'userId': user.uid,
        'story': story,
        'createdAt': FieldValue.serverTimestamp(),
        'hasImage': imageFileName != null,
        'imageFileName': imageFileName,
      };
      print(storyData);

      await FirebaseFirestore.instance.collection('userStories').add(storyData);

      // Başarılı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Hikaye kütüphanenize kaydedildi! ✨',
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
      // Hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Bir hata oluştu: ${e.toString()}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Uzayın Derinliklerinden',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: SpaceTheme.iconContainerDecoration,
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            ),
            onPressed: () => _saveStoryToFirebase(context),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (image != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: SpaceTheme.accentPurple.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.memory(
                              image!,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SpaceTheme.accentPurple.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: SpaceTheme.accentPurple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Colors.amber[100],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hikayeniz Hazır!',
                                    style: TextStyle(
                                      color: Colors.amber[100],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              story,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.6,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SpaceTheme.accentBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          shadowColor: SpaceTheme.accentBlue.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Yeni Bir Maceraya Başla',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}