import 'package:flutter/material.dart';
import '../model/story/story_library_model.dart';
import '../repository/story_discover_repository.dart';

class StoryDiscoverViewModel extends ChangeNotifier {
  final StoryDiscoverRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  List<StoryLibraryModel> _stories = [];
  String _searchQuery = '';

  StoryDiscoverViewModel({StoryDiscoverRepository? repository})
      : _repository = repository ?? StoryDiscoverRepository() {
    loadStories();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<StoryLibraryModel> get stories => _stories;
  bool get hasStories => _stories.isNotEmpty;
  String get searchQuery => _searchQuery;

  Future<void> setSearchQuery(String query) async {
    _searchQuery = query;
    await loadStories();
  }

  Future<void> toggleLike(String storyId) async {
    try {
      await _repository.toggleLike(storyId);
      await loadStories();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadStories() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _stories = await _repository.getAllStories(
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 