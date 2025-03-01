import 'package:flutter/material.dart';
import '../model/story/story_library_model.dart';
import '../repository/story_library_repository.dart';

class StoryLibraryViewModel extends ChangeNotifier {
  final StoryLibraryRepository _repository;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<StoryLibraryModel> _stories = [];
  bool _mounted = true;

  static const int pageSize = 10;
  bool _hasMoreStories = true;

  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration cacheValidDuration = Duration(minutes: 5);

  StoryLibraryViewModel({StoryLibraryRepository? repository})
      : _repository = repository ?? StoryLibraryRepository() {
    loadStories();
  }

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<StoryLibraryModel> get stories => _stories;
  bool get hasStories => _stories.isNotEmpty;
  bool get canLoadMore => _hasMoreStories && !_isLoadingMore;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  bool _isCacheValid() {
    if (_cacheTimestamps.isEmpty) return false;

    final now = DateTime.now();
    return _cacheTimestamps.values.every(
      (timestamp) => now.difference(timestamp) < cacheValidDuration,
    );
  }

  void _updateCache() {
    final now = DateTime.now();
    for (var story in _stories) {
      _cacheTimestamps[story.id] = now;
    }
  }

  Future<void> loadStories() async {
    if (!_mounted) return;

    if (_isCacheValid()) {
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      _hasMoreStories = true;
      notifyListeners();

      final stories = await _repository.getAllStories(limit: pageSize);

      if (!_mounted) return;

      _stories = stories;
      _updateCache();
      _isLoading = false;
      notifyListeners();

      _loadStoryImages();
    } catch (e) {
      if (!_mounted) return;
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMoreStories() async {
    if (!_mounted || _isLoadingMore || !_hasMoreStories) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final lastStory = _stories.last;
      final moreStories = await _repository.getAllStories(
        limit: pageSize,
        startAfter: lastStory.id,
      );

      if (!_mounted) return;

      if (moreStories.isEmpty) {
        _hasMoreStories = false;
      } else {
        _stories.addAll(moreStories);
        _updateCache();

        _loadStoryImages(startIndex: _stories.length - moreStories.length);
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      if (!_mounted) return;
      _isLoadingMore = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadStoryImages({int startIndex = 0}) async {
    for (var i = startIndex; i < _stories.length; i++) {
      if (!_mounted) return;

      final story = _stories[i];
      if (story.hasImage && story.imageFileName != null && story.imageData == null) {
        story.imageData = await _repository.loadImage(story.imageFileName!);
        if (_mounted) notifyListeners();
      }
    }
  }

  Future<void> toggleLike(String storyId) async {
    try {
      await _repository.toggleLike(storyId);

      final storyIndex = _stories.indexWhere((s) => s.id == storyId);
      if (storyIndex != -1) {
        final currentStory = _stories[storyIndex];
        final updatedStory = await _repository.getStory(storyId);
        if (updatedStory != null) {
          updatedStory.imageData = currentStory.imageData;
          _stories[storyIndex] = updatedStory;
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

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

  void clearError() {
    if (!_mounted) return;
    _errorMessage = null;
    notifyListeners();
  }
}