import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/core/extension/locazition_extension.dart';
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
       final localizations = context.localizations;

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

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case 'user-not-found':
          _error = localizations.userNotFound;
          break;
        case 'wrong-password':
          _error = localizations.wrongPassword;
          break;
        case 'invalid-email':
          _error = localizations.invalidEmail;
          break;
        case 'user-disabled':
          _error =localizations.userDisabled;
          break;
        case 'too-many-requests':
          _error =
              localizations.tooManyRequests;
          break;
        default:
          _error = localizations.operationNotAllowed;
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = context.localizations.genericError(e.toString());
      notifyListeners();
    }
  }
}
