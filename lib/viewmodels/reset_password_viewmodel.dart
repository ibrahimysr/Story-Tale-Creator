import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/service/auth/auth_service.dart';

class PasswordResetViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String? _email;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _shouldNavigateToLogin = false;
  BuildContext? context;

  String? get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get shouldNavigateToLogin => _shouldNavigateToLogin;

  void updateEmail(String email) {
    _email = email.trim();
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    if (_email == null || _email!.isEmpty) {
      _errorMessage = context.localizations.enterEmail;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    _shouldNavigateToLogin = false;
    notifyListeners();

    try {
      await _authService.resetPassword(context , _email!);
      _successMessage = context.localizations.sentToResetPassword;
      _errorMessage = null;
      _shouldNavigateToLogin = true; 
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _successMessage = null;
      _shouldNavigateToLogin = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetNavigation() {
    _shouldNavigateToLogin = false;
    notifyListeners();
  }
}