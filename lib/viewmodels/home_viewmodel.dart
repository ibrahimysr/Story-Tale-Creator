import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/model/home/home_story_model.dart';
import 'package:masal/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _isLoadingStories = false;
  String? _storyLoadError;
  List<HomeStoryModel> _recentStories = [];
  bool _mounted = true;

  static const int pageSize = 5;
  bool _hasMoreStories = true;
  bool _isLoadingMore = false;

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

  bool _isCacheValid() {
    if (_cacheTimestamps.isEmpty) return false;

    final now = DateTime.now();
    return _cacheTimestamps.values.every(
      (timestamp) => now.difference(timestamp) < cacheValidDuration,
    );
  }

  void _updateCache() {
    final now = DateTime.now();
    for (var story in _recentStories) {
      _cacheTimestamps[story.id] = now;
    }
  }

  Future<void> loadRecentStories() async {
    if (!_mounted) return;

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

      _loadStoryImages();
    } catch (e) {
      if (!_mounted) return;
      _isLoadingStories = false;
      _storyLoadError = e.toString();
      notifyListeners();
    }
  }

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

  Future<void> _loadStoryImages({int startIndex = 0}) async {
    for (var i = startIndex; i < _recentStories.length; i++) {
      if (!_mounted) return;

      final story = _recentStories[i];
      if (story.hasImage && story.imageFileName != null && story.imageData == null) {
        story.imageData = await _repository.loadImage(story.imageFileName!);
        if (_mounted) notifyListeners();
      }
    }
  }

  void clearError() {
    if (!_mounted) return;
    _storyLoadError = null;
    notifyListeners();
  }

  Future<bool> canAccessStoryCreator() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Kullanıcı bilgileri bulunamadı.');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      bool isSubscribed = userData['subscribed'] ?? false;

      if (isSubscribed) {
        // Abone ise sınırsız erişim
        return true;
      } else {
        // Abone değilse günlük limit kontrolü
        const int dailyLimit = 2;
        final String todayKey = 'story_creation_count_${DateTime.now().toIso8601String().substring(0, 10)}';
        final String lastCreationDateKey = 'last_creation_date';

        final String? lastCreationDate = prefs.getString(lastCreationDateKey);
        final int currentCount = prefs.getInt(todayKey) ?? 0;
        final String today = DateTime.now().toIso8601String().substring(0, 10);

        if (lastCreationDate != today) {
          // Yeni gün başladıysa sayacı sıfırla
          await prefs.setInt(todayKey, 0);
          await prefs.setString(lastCreationDateKey, today);
        }

        if (currentCount < dailyLimit) {
          // Limit aşılmadıysa erişime izin ver ve sayacı artır
          await prefs.setInt(todayKey, currentCount + 1);
          return true;
        } else {
          // Limit aşıldıysa false döndür (abonelik dialogu tetiklenir)
          return false;
        }
      }
    } else {
      // Giriş yapmamış kullanıcılar için mevcut mantık
      final hasUsedFreeAccess = prefs.getBool('has_used_free_access') ?? false;

      if (!hasUsedFreeAccess) {
        final deviceId = await _getDeviceId();
        await prefs.setBool('has_used_free_access', true);
        await prefs.setString('device_id', deviceId);
        return true;
      }
      return false;
    }
  }

  Future<String> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      return 'unknown';
    }
    return 'unknown';
  }


  
}