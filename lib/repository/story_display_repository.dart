import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masal/views/auth/login_view.dart';
import '../model/story/story_display_model.dart';
import '../core/theme/space_theme.dart';

class StoryDisplayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getStoryPrefix(String story, {int maxLength = 100}) {
    return story.length <= maxLength
        ? story
        : story.substring(0, maxLength).trim();
  }

  Future<bool> saveStory(StoryDisplayModel story,String languageCode, {BuildContext? context}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (context != null) {
          _showLoginDialog(context);
        }
        return false;
      }

      final storyPrefix = _getStoryPrefix(story.story);

      final existingStoryQuery = await _firestore
          .collection('userStories')
          .where('userId', isEqualTo: user.uid)
          .where('title', isEqualTo: story.title)
          .where('storyPrefix', isEqualTo: storyPrefix)
          .limit(1)
          .get();

      if (existingStoryQuery.docs.isNotEmpty) {
        if (context != null) {
          _showAlreadyExistsDialog(context);
        }
        return false; 
      }

      String? imageFileName;
      if (story.image != null) {
        imageFileName = await _uploadImageToServer(story.image!, user.uid);
      }

      final storyData = {
        ...story.toMap(),
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'imageFileName': imageFileName,
        'likeCount': 0,
        'likedByUsers': [],
        'storyPrefix': storyPrefix, 
        "Language": languageCode
      };

      await _firestore.collection('userStories').add(storyData);
      return true;
    } catch (e) {
      throw Exception('Hikaye kaydedilirken bir hata oluştu: $e');
    }
  }

  Future<bool> reportStory({
    required String storyTitle,
    required String storyContent,
    required String reason,
    BuildContext? context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (context != null) {
          _showLoginDialog(context);
        }
        return false;
      }

      final reportData = {
        'storyTitle': storyTitle,
        'storyContent': storyContent,
        'reason': reason,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('reports').add(reportData);
      return true;
    } catch (e) {
      throw Exception('Rapor kaydedilirken bir hata oluştu: $e');
    }
  }

  void _showAlreadyExistsDialog(BuildContext context) {
    final accentColor = SpaceTheme.accentPurple;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade800,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hikaye Zaten Var',
                  style: SpaceTheme.titleStyle.copyWith(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bu hikaye zaten kütüphanenizde mevcut.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Tamam',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    Theme.of(context);
    final accentColor = SpaceTheme.accentPurple; 
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade800,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Giriş Gerekli',
                  style: SpaceTheme.titleStyle.copyWith(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hikayeyi kaydetmek için lütfen giriş yapınız.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.7),
                      ),
                      child: const Text(
                        'İptal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _uploadImageToServer(
      Uint8List imageData, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = DateTime.now().microsecond;
      final fileName = 'story_image_${userId}_${timestamp}_$random.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://sandbox.temizlikcin.com.tr/api/upload-image'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageData,
          filename: fileName,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        if (jsonData['status'] == true) {
          return jsonData['data'];
        } else {
          throw Exception('API yükleme başarısız: ${jsonData['message']}');
        }
      } else {
        throw Exception(
            'Resim yüklenemedi, durum kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Resim yüklenirken bir hata oluştu: $e');
    }
  }

  Future<bool> isUserSubscribed() async {
  try {
    final user = _auth.currentUser;
    if (user == null) return false;

    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final data = userDoc.data();
    if (data != null && data['subscribed'] == true) {
      return true;
    }
    return false;
  } catch (e) {
    throw Exception('Abonelik durumu kontrol edilirken hata: $e');
  }
}
}