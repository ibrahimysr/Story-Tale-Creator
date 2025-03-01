import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../model/story/story_display_model.dart';

class StoryDisplayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveStory(StoryDisplayModel story) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

      String? imageFileName;
      if (story.image != null) {
        imageFileName = await _uploadImageToServer(story.image!, user.uid);
      }

      final storyData = {
        ...story.toMap(),
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'imageFileName': imageFileName, // Sadece dosya adını kaydediyoruz
        'likeCount': 0,
        'likedByUsers': [],
      };

      await _firestore.collection('userStories').add(storyData);
    } catch (e) {
      throw Exception('Hikaye kaydedilirken bir hata oluştu: $e');
    }
  }

  Future<String?> _uploadImageToServer(Uint8List imageData, String userId) async {
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
          'image', // Field adı doğru mu, dökümantasyondan kontrol et
          imageData,
          filename: fileName,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        if (jsonData['status'] == true) {
          return jsonData['data']; // Sadece dosya adını döndürüyoruz
        } else {
          throw Exception('API yükleme başarısız: ${jsonData['message']}');
        }
      } else {
        throw Exception('Resim yüklenemedi, durum kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Resim yüklenirken bir hata oluştu: $e');
    }
  }
}