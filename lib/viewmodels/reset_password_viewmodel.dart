import 'package:flutter/material.dart';
import 'package:masal/service/auth/auth_service.dart';

class PasswordResetViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String? _email;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _shouldNavigateToLogin = false;

  String? get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get shouldNavigateToLogin => _shouldNavigateToLogin;

  void updateEmail(String email) {
    _email = email.trim();
    notifyListeners();
  }

  Future<void> resetPassword() async {
    if (_email == null || _email!.isEmpty) {
      _errorMessage = 'Lütfen e-posta adresinizi girin.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    _shouldNavigateToLogin = false;
    notifyListeners();

    try {
      await _authService.resetPassword(_email!);
      _successMessage = 'Şifre sıfırlama bağlantısı e-postanıza gönderildi!';
      _errorMessage = null;
      _shouldNavigateToLogin = true; // Yönlendirme için flag’i true yap
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _successMessage = null;
      _shouldNavigateToLogin = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Yönlendirme sonrası flag’i sıfırlamak için
  void resetNavigation() {
    _shouldNavigateToLogin = false;
    notifyListeners();
  }
}