import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../model/home/home_story_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<HomeStoryModel>> getRecentStories({
    int limit = 5,
    String? startAfter,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      Query query = _firestore
          .collection('userStories')
          .where('userId', isEqualTo: user.uid)
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

      return snapshot.docs.map((doc) {
        return HomeStoryModel.fromFirebase(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      if (e is FirebaseException && e.code == 'failed-precondition') {
        throw Exception(
          'Sistem hazırlanıyor, lütfen biraz bekleyin ve sayfayı yenileyin. '
          'Bu işlem sadece ilk seferde gereklidir.'
        );
      }

      if (e.toString().contains('indexes?create_composite=')) {
        throw Exception(
          'Sistem ilk kurulum aşamasında. '
          'Lütfen birkaç dakika bekleyip tekrar deneyin.'
        );
      }

      throw Exception('Hikayeler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  Future<Uint8List?> loadImage(String imageFileName) async {
    try {
      final response = await http.get(
        Uri.parse('https://sandbox.temizlikcin.com.tr/api/get-image/$imageFileName'),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}