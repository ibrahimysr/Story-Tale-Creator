import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserStats() async {
try {
    final user = _auth.currentUser;
    if (user == null) {
      return {
        'totalStories': 0,
        'totalLikes': 0,
      };
    }

      final QuerySnapshot storySnapshot = await _firestore
          .collection('userStories')
          .where('userId', isEqualTo: user.uid)
          .get();

      int totalStories = storySnapshot.docs.length;
      int totalLikes = 0;

      for (var doc in storySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalLikes += data['likeCount'] as int? ?? 0;
      }

      
      return {
        'totalStories': totalStories,
        'totalLikes': totalLikes,
      };
    } catch (e) {
    throw Exception('Kullanıcı istatistikleri alınırken bir hata oluştu: $e');
  }
  }
} 