import 'package:flutter/material.dart';
import '../model/home/home_story_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _isLoadingStories = false;
  String? _storyLoadError;
  List<HomeStoryModel> _recentStories = [];
  bool _mounted = true;

  HomeViewModel({HomeRepository? repository})
      : _repository = repository ?? HomeRepository() {
    loadRecentStories();
  }

  bool get isLoadingStories => _isLoadingStories;
  String? get storyLoadError => _storyLoadError;
  List<HomeStoryModel> get recentStories => _recentStories;
  bool get hasStories => _recentStories.isNotEmpty;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> loadRecentStories() async {
    if (!_mounted) return;
    
    try {
      _isLoadingStories = true;
      _storyLoadError = null;
      if (_mounted) notifyListeners();

      _recentStories = await _repository.getRecentStories();

      for (var story in _recentStories) {
        if (!_mounted) return;
        if (story.hasImage && story.imageFilePath != null) {
          story.imageData = await _repository.loadImage(story.imageFilePath!);
        }
      }

      _isLoadingStories = false;
      if (_mounted) notifyListeners();
    } catch (e) {
      if (!_mounted) return;
      _isLoadingStories = false;
      _storyLoadError = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    if (!_mounted) return;
    _storyLoadError = null;
    notifyListeners();
  }
} 