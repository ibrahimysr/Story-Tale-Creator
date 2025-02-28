import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/story/story_library_model.dart';

class StoryDiscoverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<StoryLibraryModel>> getAllStories({String? searchQuery}) async {
    try {
      Query query = _firestore.collection('userStories');

      // Beğeni sayısına göre sıralama
      query = query.orderBy('likeCount', descending: true);

      final QuerySnapshot snapshot = await query.get();

      var stories = snapshot.docs.map((doc) {
        return StoryLibraryModel.fromFirebase(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      // Eğer arama sorgusu varsa, başlık ve hikaye içeriğinde arama yap
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchLower = searchQuery.toLowerCase();
        stories = stories.where((story) {
          return story.title.toLowerCase().contains(searchLower) ||
                 story.story.toLowerCase().contains(searchLower);
        }).toList();
      }

      return stories;
    } catch (e) {
      throw Exception('Hikayeler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> toggleLike(String storyId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Kullanıcı giriş yapmamış!');

      final storyRef = _firestore.collection('userStories').doc(storyId);
      final storyDoc = await storyRef.get();

      if (!storyDoc.exists) {
        throw Exception('Hikaye bulunamadı');
      }

      final likedByUsers = List<String>.from(storyDoc.data()?['likedByUsers'] ?? []);
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
    }
  }

  Future<Uint8List?> loadImage(String imageFilePath) async {
    try {
      final file = File(imageFilePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return null;
    }
  }
} 