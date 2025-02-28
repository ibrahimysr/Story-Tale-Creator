import 'package:flutter/material.dart';
import '../model/home/home_story_model.dart';
import '../repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _isLoadingStories = false;
  String? _storyLoadError;
  List<HomeStoryModel> _recentStories = [];
  bool _mounted = true;
  
  // Sayfalama için değişkenler
  static const int pageSize = 5;
  bool _hasMoreStories = true;
  bool _isLoadingMore = false;
  
  // Önbellek için değişkenler
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration cacheValidDuration = Duration(minutes: 5);

  HomeViewModel({HomeRepository? repository})
      : _repository = repository ?? HomeRepository() {
    loadRecentStories();
  }

  bool get isLoadingStories => _isLoadingStories;
  bool get isLoadingMore => _isLoadingMore;
  String? get storyLoadError => _storyLoadError;
  List<HomeStoryModel> get recentStories => _recentStories;
  bool get hasStories => _recentStories.isNotEmpty;
  bool get canLoadMore => _hasMoreStories && !_isLoadingMore;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  // Önbellek kontrolü
  bool _isCacheValid() {
    if (_cacheTimestamps.isEmpty) return false;
    
    final now = DateTime.now();
    return _cacheTimestamps.values.every(
      (timestamp) => now.difference(timestamp) < cacheValidDuration
    );
  }

  // Önbelleği güncelle
  void _updateCache() {
    final now = DateTime.now();
    for (var story in _recentStories) {
      _cacheTimestamps[story.id] = now;
    }
  }

  Future<void> loadRecentStories() async {
    if (!_mounted) return;
    
    // Önbellek kontrolü
    if (_isCacheValid()) {
      return;
    }
    
    try {
      _isLoadingStories = true;
      _storyLoadError = null;
      _hasMoreStories = true;
      notifyListeners();

      final stories = await _repository.getRecentStories(limit: pageSize);
      
      if (!_mounted) return;
      
      _recentStories = stories;
      _updateCache();
      _isLoadingStories = false;
      notifyListeners();

      // Resimleri asenkron olarak yükle
      _loadStoryImages();
    } catch (e) {
      if (!_mounted) return;
      _isLoadingStories = false;
      _storyLoadError = e.toString();
      notifyListeners();
    }
  }

  // Daha fazla hikaye yükle
  Future<void> loadMoreStories() async {
    if (!_mounted || _isLoadingMore || !_hasMoreStories) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final lastStory = _recentStories.last;
      final moreStories = await _repository.getRecentStories(
        limit: pageSize,
        startAfter: lastStory.id,
      );

      if (!_mounted) return;

      if (moreStories.isEmpty) {
        _hasMoreStories = false;
      } else {
        _recentStories.addAll(moreStories);
        _updateCache();
        
        // Yeni hikayelerin resimlerini asenkron olarak yükle
        _loadStoryImages(startIndex: _recentStories.length - moreStories.length);
      }

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      if (!_mounted) return;
      _isLoadingMore = false;
      _storyLoadError = e.toString();
      notifyListeners();
    }
  }

  // Resimleri asenkron olarak yükle
  Future<void> _loadStoryImages({int startIndex = 0}) async {
    for (var i = startIndex; i < _recentStories.length; i++) {
      if (!_mounted) return;
      
      final story = _recentStories[i];
      if (story.hasImage && story.imageFilePath != null && story.imageData == null) {
        story.imageData = await _repository.loadImage(story.imageFilePath!);
        if (_mounted) notifyListeners();
      }
    }
  }

  void clearError() {
    if (!_mounted) return;
    _storyLoadError = null;
    notifyListeners();
  }
} 