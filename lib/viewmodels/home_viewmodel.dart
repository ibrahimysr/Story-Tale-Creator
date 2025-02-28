import 'package:flutter/material.dart';
import '../model/home/home_story_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _isLoadingStories = false;
  String? _storyLoadError;
  List<HomeStoryModel> _recentStories = [];

  HomeViewModel({HomeRepository? repository})
      : _repository = repository ?? HomeRepository() {
    loadRecentStories();
  }

  bool get isLoadingStories => _isLoadingStories;
  String? get storyLoadError => _storyLoadError;
  List<HomeStoryModel> get recentStories => _recentStories;
  bool get hasStories => _recentStories.isNotEmpty;

  // Son hikayeleri yükleme
  Future<void> loadRecentStories() async {
    try {
      _isLoadingStories = true;
      _storyLoadError = null;
      notifyListeners();

      _recentStories = await _repository.getRecentStories();

      // Her hikaye için resmi yükle
      for (var story in _recentStories) {
        if (story.hasImage && story.imageFilePath != null) {
          story.imageData = await _repository.loadImage(story.imageFilePath!);
        }
      }

      _isLoadingStories = false;
      notifyListeners();
    } catch (e) {
      _isLoadingStories = false;
      _storyLoadError = e.toString();
      notifyListeners();
    }
  }

  // Hata mesajını temizleme
  void clearError() {
    _storyLoadError = null;
    notifyListeners();
  }
} 