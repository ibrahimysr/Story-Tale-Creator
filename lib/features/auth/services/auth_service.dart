import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Kayıt olma sırasında beklenmeyen bir hata oluştu: $e');
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('Bu e-posta adresi zaten kullanımda.');
      case 'invalid-email':
        return Exception('Geçersiz e-posta formatı.');
      case 'weak-password':
        return Exception('Şifre çok zayıf. Daha güçlü bir şifre seçin.');
      case 'operation-not-allowed':
        return Exception('E-posta/şifre girişi devre dışı bırakılmış.');
      default:
        return Exception('Bir hata oluştu: ${e.message}');
    }
  }
}