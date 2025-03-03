import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/service/auth/auth_service.dart';
import '../model/auth/user_model.dart';

class UserRepository {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser(
      String username, String email, String password, String avatar) async {
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
        avatar: avatar,
      );

      final userData = {
        'id': user.uid,
        'username': username,
        'email': email,
        'avatar': avatar,
      };
      
      await _firestore.collection('users').doc(user.uid).set(userData);
      
      return userModel;
    } catch (e) {
      throw Exception('Kullanıcı kaydı sırasında hata: $e');
    }
  }

  Future<UserModel> loginUser(String email, String password) async {
    try {
      User? user = await _authService.signInWithEmailAndPassword(
          email, password);
      
      if (user == null) {
        throw Exception('Giriş başarısız oldu.');
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        throw Exception('Kullanıcı bilgileri bulunamadı.');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      return UserModel(
        id: user.uid,
        username: userData['username'],
        email: userData['email'],
        avatar: userData['avatar'],
      );
    } catch (e) {
      throw Exception('Giriş sırasında hata: $e');
    }
  }
}