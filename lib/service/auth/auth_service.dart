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

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthLoginException(e);
    } catch (e) {
      throw Exception('Giriş sırasında beklenmeyen bir hata oluştu: $e');
    }
  }

  String _getLocalizedErrorMessage(String message) {
    if (message.contains('network error')) {
      return 'İnternet bağlantınızı kontrol edin ve tekrar deneyin';
    }
    if (message.contains('invalid-credential')) {
      return 'Geçersiz kimlik bilgileri';
    }
    if (message.contains('timeout')) {
      return 'İşlem zaman aşımına uğradı. Lütfen tekrar deneyin';
    }
    if (message.contains('The supplied auth credential is incorrect, malformed or has expired')) {
      return 'Girdiğiniz kimlik bilgileri hatalı, bozuk veya süresi dolmuş. Lütfen tekrar giriş yapmayı deneyin';
    }
    return message;
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('Bu e-posta adresi zaten başka bir kaşif tarafından kullanılıyor. Farklı bir e-posta adresi deneyin.');
      case 'invalid-email':
        return Exception('E-posta adresiniz geçerli bir formatta değil. Lütfen kontrol edip tekrar deneyin.');
      case 'weak-password':
        return Exception('Seçtiğiniz şifre yeterince güçlü değil. En az 6 karakter uzunluğunda, rakam ve özel karakter içeren bir şifre seçin.');
      case 'operation-not-allowed':
        return Exception('E-posta/şifre ile kayıt şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.');
      case 'network-request-failed':
        return Exception('İnternet bağlantınızı kontrol edin ve tekrar deneyin.');
      case 'invalid-credential':
        return Exception('Geçersiz kimlik bilgileri. Lütfen bilgilerinizi kontrol edip tekrar deneyin.');
      case 'timeout':
        return Exception('İşlem zaman aşımına uğradı. Lütfen tekrar deneyin.');
      default:
        return Exception('Üzgünüz, bir hata oluştu: ${_getLocalizedErrorMessage(e.message ?? '')}. Lütfen daha sonra tekrar deneyin.');
    }
  }

  Exception _handleFirebaseAuthLoginException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Bu e-posta adresiyle kayıtlı bir kaşif bulunamadı. Lütfen önce kayıt olun.');
      case 'wrong-password':
        return Exception('Hatalı şifre girdiniz. Lütfen şifrenizi kontrol edip tekrar deneyin.');
      case 'user-disabled':
        return Exception('Bu hesap devre dışı bırakılmış. Lütfen destek ekibiyle iletişime geçin.');
      case 'too-many-requests':
        return Exception('Çok fazla başarısız giriş denemesi yaptınız. Lütfen bir süre bekleyip tekrar deneyin.');
      case 'invalid-email':
        return Exception('E-posta adresiniz geçerli bir formatta değil. Lütfen kontrol edip tekrar deneyin.');
      case 'network-request-failed':
        return Exception('İnternet bağlantınızı kontrol edin ve tekrar deneyin.');
      case 'invalid-credential':
        return Exception('Girdiğiniz kimlik bilgileri hatalı, bozuk veya süresi dolmuş. Lütfen tekrar giriş yapmayı deneyin.');
      case 'timeout':
        return Exception('İşlem zaman aşımına uğradı. Lütfen tekrar deneyin.');
      default:
        return Exception('Üzgünüz, giriş yapılırken bir hata oluştu: ${_getLocalizedErrorMessage(e.message ?? '')}. Lütfen daha sonra tekrar deneyin.');
    }
  }
}
