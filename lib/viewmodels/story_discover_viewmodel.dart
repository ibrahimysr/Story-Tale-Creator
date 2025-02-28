import 'package:flutter/material.dart';
import '../model/story/story_library_model.dart';
import '../repository/story_discover_repository.dart';

class StoryDiscoverViewModel extends ChangeNotifier {
  final StoryDiscoverRepository _repository;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<StoryLibraryModel> _stories = [];
  bool _mounted = true;
  
  // Sayfalama için değişkenler
  static const int pageSize = 15;
  bool _hasMoreStories = true;
  
  // Önbellek için değişkenler
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration cacheValidDuration = Duration(minutes: 5);

  // Arama için değişkenler
  String _searchQuery = '';
  bool _isSearching = false;

  StoryDiscoverViewModel({StoryDiscoverRepository? repository})
      : _repository = repository ?? StoryDiscoverRepository() {
    loadStories();
  }

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<StoryLibraryModel> get stories => _stories;
  bool get hasStories => _stories.isNotEmpty;
  bool get canLoadMore => _hasMoreStories && !_isLoadingMore && !_isSearching;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  // Önbellek kontrolü
  bool _isCacheValid() {
    if (_cacheTimestamps.isEmpty || _searchQuery.isNotEmpty) return false;
    
    final now = DateTime.now();
    return _cacheTimestamps.values.every(
      (timestamp) => now.difference(timestamp) < cacheValidDuration
    );
  }

  // Önbelleği güncelle
  void _updateCache() {
    if (_searchQuery.isNotEmpty) return;
    
    final now = DateTime.now();
    for (var story in _stories) {
      _cacheTimestamps[story.id] = now;
    }
  }

  Future<void> loadStories() async {
    if (!_mounted) return;
    
    // Önbellek kontrolü
    if (_isCacheValid()) {
      return;
    }
    
    try {
      _isLoading = true;
      _errorMessage = null;
      _hasMoreStories = true;
      notifyListeners();

      final stories = await _repository.getAllStories(
        limit: pageSize,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      );
      
      if (!_mounted) return;
      
      _stories = stories;
      _updateCache();
      _isLoading = false;
      notifyListeners();

      // Resimleri asenkron olarak yükle
      _loadStoryImages();
    } catch (e) {
      if (!_mounted) return;
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMoreStories() async {
    if (!_mounted || _isLoadingMore || !_hasMoreStories || _isSearching) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final lastStory = _stories.last;
      final moreStories = await _repository.getAllStories(
        limit: pageSize,
        startAfter: lastStory.id,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (!_mounted) return;

      if (moreStories.isEmpty) {
        _hasMoreStories = false;
      } else {
        _stories.addAll(moreStories);
        _updateCache();
        
        // Yeni hikayelerin resimlerini asenkron olarak yükle
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

  // Resimleri asenkron olarak yükle
  Future<void> _loadStoryImages({int startIndex = 0}) async {
    for (var i = startIndex; i < _stories.length; i++) {
      if (!_mounted) return;
      
      final story = _stories[i];
      if (story.hasImage && story.imageFilePath != null && story.imageData == null) {
        story.imageData = await _repository.loadImage(story.imageFilePath!);
        if (_mounted) notifyListeners();
      }
    }
  }

  Future<void> search(String query) async {
    if (!_mounted) return;
    
    _searchQuery = query.trim();
    _isSearching = _searchQuery.isNotEmpty;
    _hasMoreStories = true;
    _stories = [];
    
    await loadStories();
  }

  Future<void> toggleLike(String storyId) async {
    try {
      await _repository.toggleLike(storyId);
      
      // Sadece ilgili hikayeyi güncelle
      final storyIndex = _stories.indexWhere((s) => s.id == storyId);
      if (storyIndex != -1) {
        final currentStory = _stories[storyIndex];
        final updatedStory = await _repository.getStory(storyId);
        if (updatedStory != null) {
          // Resim verisini koru
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

  void clearError() {
    if (!_mounted) return;
    _errorMessage = null;
    notifyListeners();
  }
} 