// lib/repositories/user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/service/auth/auth_service.dart';
import '../model/auth/user_model.dart';

class UserRepository {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser(
      String username, String email, String password) async {
    try {
      User? user = await _authService.registerWithEmailAndPassword(
          email, password);
      
      if (user == null) {
        throw Exception('Kullanıcı kaydı başarısız oldu.');
      }

      UserModel userModel = UserModel(
        id: user.uid,
        username: username,
        email: email,
      );

      final userData = {
        'id': user.uid,
        'username': username,
        'email': email,
      
      };
      
      await _firestore.collection('users').doc(user.uid).set(userData);
      
      return userModel;
    } catch (e) {
      throw Exception('Kullanıcı kaydı sırasında hata: $e');
    }
  }
}