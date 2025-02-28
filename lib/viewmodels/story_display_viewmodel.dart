import 'package:flutter/material.dart';
import '../model/story/story_display_model.dart';
import '../repository/story_display_repository.dart';

class StoryDisplayViewModel extends ChangeNotifier {
  final StoryDisplayRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;

  StoryDisplayViewModel({StoryDisplayRepository? repository})
      : _repository = repository ?? StoryDisplayRepository();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Hikayeyi kaydetme
  Future<void> saveStory(StoryDisplayModel story) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.saveStory(story);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Hata mesajını temizleme
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 