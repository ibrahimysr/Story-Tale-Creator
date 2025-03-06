import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kayıt işlemi
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e, isRegistration: true);
    } catch (e) {
      throw Exception('Kayıt sırasında beklenmeyen bir hata oluştu: $e');
    }
  }

  // Giriş işlemi
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e, isRegistration: false);
    } catch (e) {
      throw Exception('Giriş sırasında beklenmeyen bir hata oluştu: $e');
    }
  }

  // Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e, isReset: true);
    } catch (e) {
      throw Exception('Şifre sıfırlama sırasında beklenmeyen bir hata oluştu: $e');
    }
  }

  // Genel hata işleme
  Exception _handleFirebaseAuthException(FirebaseAuthException e,
      {bool isRegistration = false, bool isReset = false}) {
    String baseMessage = e.message ?? 'Bilinmeyen bir hata oluştu';
    String localizedMessage = _getLocalizedErrorMessage(baseMessage);

    switch (e.code) {
      case 'email-already-in-use':
        return Exception(
            'Bu e-posta adresi başka bir kaşif tarafından kullanılıyor! Yeni bir e-posta dene.');
      case 'invalid-email':
        return Exception(
            'E-posta adresin geçerli değil. Lütfen yıldız haritalarını kontrol et ve tekrar dene!');
      case 'weak-password':
        return Exception(
            'Şifren yeterince güçlü değil. Uzay macerası için en az 6 karakter, rakam ve özel işaretlerle bir şifre seç!');
      case 'operation-not-allowed':
        return Exception(
            'E-posta/şifre ile kayıt şu anda galakside kapalı. Lütfen daha sonra dene.');
      case 'user-not-found':
        return Exception(
            'Bu e-posta ile bir kaşif bulunamadı. Önce uzay limanında kaydol!');
      case 'wrong-password':
        return Exception(
            'Hatalı şifre! Lütfen yıldız şifreni kontrol et ve tekrar dene.');
      case 'user-disabled':
        return Exception(
            'Bu hesap galakside devre dışı. Destek ekibine ulaş, seni yıldızlara geri götürelim!');
      case 'too-many-requests':
        return Exception(
            'Çok fazla giriş denemesi yaptın! Bir süre bekle ve sonra uzaya geri dön.');
      case 'network-request-failed':
        return Exception(
            'İnternet bağlantında bir sorun var. Lütfen uzay sinyalini kontrol et ve tekrar dene.');
      case 'invalid-credential':
        return Exception(
            'Kimlik bilgilerinde bir hata var. Lütfen galaktik bilgilerini kontrol et.');
      case 'timeout':
        return Exception(
            'İşlem yıldızlar arasında kayboldu! Lütfen tekrar dene.');
      default:
        return Exception(
            'Üzgünüz, bir galaktik hata oluştu: $localizedMessage. Lütfen daha sonra yıldızlara dön.');
    }
  }

  // Yerelleştirilmiş hata mesajları
  String _getLocalizedErrorMessage(String message) {
    if (message.contains('network error')) {
      return 'İnternet bağlantını kontrol et, uzay sinyalin zayıf olabilir!';
    }
    if (message.contains('invalid-credential')) {
      return 'Kimlik bilgilerinde bir hata var, lütfen kontrol et!';
    }
    if (message.contains('timeout')) {
      return 'İşlem yıldızlar arasında kayboldu, tekrar dene!';
    }
    if (message.contains('The supplied auth credential is incorrect, malformed or has expired')) {
      return 'Kimlik bilgilerinde sorun var, lütfen galaktik verilerini yenile!';
    }
    return message;
  }

  // Kullanıcı çıkış yapma
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Çıkış sırasında bir hata oluştu: $e');
    }
  }

  // Mevcut kullanıcıyı kontrol etme
  User? get currentUser => _auth.currentUser;
}