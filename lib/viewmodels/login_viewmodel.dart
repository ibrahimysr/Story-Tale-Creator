import 'package:flutter/material.dart';
import 'package:masal/repository/user_repository.dart';
import '../model/auth/user_model.dart';

enum LoginState { initial, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  LoginState _state = LoginState.initial;
  String _errorMessage = '';
  UserModel? _user;

  LoginState get state => _state;
  String get errorMessage => _errorMessage;
  UserModel? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      _state = LoginState.loading;
      notifyListeners();

      _user = await _userRepository.loginUser(email, password);
      
      _state = LoginState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = LoginState.error;
      notifyListeners();
    }
  }

  void resetState() {
    _state = LoginState.initial;
    _errorMessage = '';
    notifyListeners();
  }
} 