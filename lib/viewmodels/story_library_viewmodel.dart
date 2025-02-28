import 'package:flutter/material.dart';
import '../model/story/story_library_model.dart';
import '../repository/story_library_repository.dart';

class StoryLibraryViewModel extends ChangeNotifier {
  final StoryLibraryRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  List<StoryLibraryModel> _stories = [];

  StoryLibraryViewModel({StoryLibraryRepository? repository})
      : _repository = repository ?? StoryLibraryRepository() {
    loadStories();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<StoryLibraryModel> get stories => _stories;
  bool get hasStories => _stories.isNotEmpty;

  Future<void> toggleLike(String storyId) async {
    try {
      await _repository.toggleLike(storyId);
      await loadStories(); // Hikayeleri yeniden yükle
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Hikayeleri yükleme
  Future<void> loadStories() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _stories = await _repository.getAllStories();

      // Her hikaye için resmi yükle
      for (var story in _stories) {
        if (story.hasImage && story.imageFilePath != null) {
          story.imageData = await _repository.loadImage(story.imageFilePath!);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Hikaye silme
  Future<void> deleteStory(StoryLibraryModel story) async {
    try {
      await _repository.deleteStory(story);
      _stories.remove(story);
      notifyListeners();
    } catch (e) {
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