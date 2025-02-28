import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import '../model/story/story_display_model.dart';

class StoryDisplayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveStory(StoryDisplayModel story) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

      String? imageFilePath;
      if (story.image != null) {
        imageFilePath = await _saveImageToExternalStorage(story.image!, user.uid);
      }

      final storyData = {
        ...story.toMap(),
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'imageFilePath': imageFilePath,
        'likeCount': 0,
        'likedByUsers': [],
      };

      await _firestore.collection('userStories').add(storyData);
    } catch (e) {
      throw Exception('Hikaye kaydedilirken bir hata oluştu: $e');
    }
  }

  Future<String?> _saveImageToExternalStorage(Uint8List imageData, String userId) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception('Harici depolama dizini alınamadı');

      final imagesDir = Directory('${directory.path}/story_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = DateTime.now().microsecond;
      final fileName = 'story_image_${userId}_${timestamp}_$random.jpg';
      final filePath = '${imagesDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(imageData);

      return filePath;
    } catch (e) {
      throw Exception('Resim kaydedilirken bir hata oluştu: $e');
    }
  }
} 