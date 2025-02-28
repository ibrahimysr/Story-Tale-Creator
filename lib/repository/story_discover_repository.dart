import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/story/story_library_model.dart';

class StoryDiscoverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, bool> _likeInProgress = {};

  Future<List<StoryLibraryModel>> getAllStories({
    int limit = 15,
    String? startAfter,
    String? searchQuery,
  }) async {
    try {
      Query query = _firestore
          .collection('userStories')
          .where('isPublic', isEqualTo: true)
          .orderBy('likeCount', descending: true)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        final startAfterDoc = await _firestore
            .collection('userStories')
            .doc(startAfter)
            .get();
        if (startAfterDoc.exists) {
          query = query.startAfterDocument(startAfterDoc);
        }
      }

      final QuerySnapshot snapshot = await query.get();
      
      // Eğer hiç hikaye yoksa, tüm hikayeleri getir ve public yap
      if (snapshot.docs.isEmpty) {
        final allStoriesQuery = await _firestore
            .collection('userStories')
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

        // Tüm hikayeleri public yap
        for (var doc in allStoriesQuery.docs) {
          if (!(doc.data()).containsKey('isPublic')) {
            await doc.reference.update({'isPublic': true});
          }
        }

        // Sorguyu tekrar çalıştır
        return getAllStories(
          limit: limit,
          startAfter: startAfter,
          searchQuery: searchQuery,
        );
      }

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
      if (e is FirebaseException) {
        if (e.code == 'failed-precondition') {
          throw Exception(
            'Sistem hazırlanıyor, lütfen biraz bekleyin ve sayfayı yenileyin. '
            'Bu işlem sadece ilk seferde gereklidir.'
          );
        }
        
        if (e.message?.contains('indexes?create_composite=') ?? false) {
          throw Exception(
            'Sistem ilk kurulum aşamasında. '
            'Lütfen birkaç dakika bekleyip tekrar deneyin.'
          );
        }
      }
      
      throw Exception('Hikayeler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  Future<StoryLibraryModel?> getStory(String storyId) async {
    try {
      final doc = await _firestore
          .collection('userStories')
          .doc(storyId)
          .get();

      if (!doc.exists) return null;

      return StoryLibraryModel.fromFirebase(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Hikaye yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> toggleLike(String storyId) async {
    // Eğer beğeni işlemi devam ediyorsa, yeni işlemi engelle
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

      final likedByUsers = List<String>.from(storyDoc.data()?['likedByUsers'] ?? []);
      final isLiked = likedByUsers.contains(user.uid);

      if (isLiked) {
        // Beğeniyi kaldır
        await storyRef.update({
          'likeCount': FieldValue.increment(-1),
          'likedByUsers': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        // Beğeni ekle
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

  Future<Uint8List?> loadImage(String imageFilePath) async {
    try {
      final file = File(imageFilePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      log('Resim yükleme hatası: $e');
      return null;
    }
  }
} 