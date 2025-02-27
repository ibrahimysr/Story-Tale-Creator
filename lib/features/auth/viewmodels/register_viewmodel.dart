import 'package:flutter/material.dart';
import 'package:masal/features/auth/repository/user_repository.dart';
import '../models/user_model.dart';

enum RegisterState { initial, loading, success, error }

class RegisterViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  RegisterState _state = RegisterState.initial;
  String _errorMessage = '';
  UserModel? _user;

  RegisterState get state => _state;
  String get errorMessage => _errorMessage;
  UserModel? get user => _user;

  Future<void> register(String username, String email, String password) async {
    try {
      _state = RegisterState.loading;
      notifyListeners();

      _user = await _userRepository.registerUser(username, email, password);
      
      _state = RegisterState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = RegisterState.error;
      notifyListeners();
    }
  }

  void resetState() {
    _state = RegisterState.initial;
    _errorMessage = '';
    notifyListeners();
  }
}