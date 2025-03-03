import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart'; 

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _error;
  String _email = '';
  String _password = '';

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setEmail(String value) {
    _email = value;
    _error = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (_email.isEmpty || _password.isEmpty) {
      _error = 'Lütfen e-posta ve şifrenizi girin';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      _isLoading = false;
      notifyListeners();
      
    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _error = 'Bu e-posta ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          _error = 'Girdiğiniz şifre hatalı. Lütfen tekrar deneyin';
          break;
        case 'invalid-email':
          _error = 'Geçersiz e-posta adresi formatı';
          break;
        case 'user-disabled':
          _error = 'Bu hesap devre dışı bırakılmış';
          break;
        case 'too-many-requests':
          _error = 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
          break;
        default:
          _error = 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin';
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin';
      notifyListeners();
    }
  }
}