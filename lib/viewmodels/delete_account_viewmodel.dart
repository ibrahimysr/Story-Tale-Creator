import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/service/auth/auth_service.dart';

class DeleteAccountViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  User? get currentUser => _authService.currentUser;

  Future<void> deleteAccount(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _authService.deleteAccount(email, password);
      _successMessage = 'Hesabın galaksiden silindi. Yeni bir macera için görüşürüz!';
      _errorMessage = null;

     

     
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _successMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}