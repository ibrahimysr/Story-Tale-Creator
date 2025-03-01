import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../model/story/story_library_model.dart';

class StoryLibraryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, bool> _likeInProgress = {};

  Future<List<StoryLibraryModel>> getAllStories({
    int limit = 10,
    String? startAfter,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

      Query query = _firestore
          .collection('userStories')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        final startAfterDoc =
            await _firestore.collection('userStories').doc(startAfter).get();
        if (startAfterDoc.exists) {
          query = query.startAfterDocument(startAfterDoc);
        }
      }

      final QuerySnapshot snapshot = await query.get();

      for (var doc in snapshot.docs) {
        if (!(doc.data() as Map<String, dynamic>).containsKey('isPublic')) {
          await doc.reference.update({'isPublic': true});
        }
      }

      return snapshot.docs.map((doc) {
        return StoryLibraryModel.fromFirebase(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      throw Exception('Hikayeler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<StoryLibraryModel?> getStory(String storyId) async {
    try {
      final doc = await _firestore.collection('userStories').doc(storyId).get();

      if (!doc.exists) return null;

      if (!(doc.data() as Map<String, dynamic>).containsKey('isPublic')) {
        await doc.reference.update({'isPublic': true});
      }

      return StoryLibraryModel.fromFirebase(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Hikaye yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> toggleLike(String storyId) async {
    if (_likeInProgress[storyId] == true) {
      return;
    }

    try {
      _likeInProgress[storyId] = true;

      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

      final storyRef = _firestore.collection('userStories').doc(storyId);
      final storyDoc = await storyRef.get();

      if (!storyDoc.exists) {
        throw Exception('Hikaye bulunamadı');
      }

      final likedByUsers =
          List<String>.from(storyDoc.data()?['likedByUsers'] ?? []);
      final isLiked = likedByUsers.contains(user.uid);

      if (isLiked) {
        await storyRef.update({
          'likeCount': FieldValue.increment(-1),
          'likedByUsers': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        await storyRef.update({
          'likeCount': FieldValue.increment(1),
          'likedByUsers': FieldValue.arrayUnion([user.uid]),
        });
      }
    } catch (e) {
      throw Exception('Beğeni işlemi sırasında bir hata oluştu: $e');
    } finally {
      _likeInProgress[storyId] = false;
    }
  }

  Future<void> deleteStory(StoryLibraryModel story) async {
    try {
      await _firestore.collection('userStories').doc(story.id).delete();
      // Artık yerel dosya silmeye gerek yok, çünkü API kullanıyoruz
    } catch (e) {
      throw Exception('Hikaye silinirken bir hata oluştu: $e');
    }
  }

  Future<Uint8List?> loadImage(String imageFileName) async {
    try {
      final response = await http.get(
        Uri.parse('https://sandbox.temizlikcin.com.tr/api/get-image/$imageFileName'),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // API’den gelen resmi Uint8List olarak döndürüyoruz
      } else {
        log('Resim yükleme hatası: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Resim yükleme hatası: $e');
      return null;
    }
  }

  Future<String> createStory(String title, String story, File? imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı oturum açmamış');

      Map<String, dynamic> storyData = {
        'title': title,
        'story': story,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'likeCount': 0,
        'isPublic': true,
        'likes': [],
      };

      final docRef = await _firestore.collection('userStories').add(storyData);
      return docRef.id;
    } catch (e) {
      throw Exception('Hikaye oluşturulurken bir hata oluştu: $e');
    }
  }
}