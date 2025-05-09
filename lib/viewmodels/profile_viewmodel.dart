import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import '../model/user/user_profile_model.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileRepository _repository;
  
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  int _totalStories = 0;
  int _totalLikes = 0;

  ProfileViewModel({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    loadUserProfile();
    loadUserStats();
  }

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalStories => _totalStories;
  int get totalLikes => _totalLikes;

  Future<void> loadUserProfile() async {
   try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      _error = "auth_required"; 
      _isLoading = false;
      notifyListeners();
      return;
    }


      String displayName = user.displayName ?? '';
      String email = user.email ?? '';

      final doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        final newProfile = {
          'uid': user.uid,
          'name': displayName,
          'username': email.split('@')[0], 
          'stories': 0,
          'level': 1,
          'avatar': 'boy (1).png',
        };
        
        await _firestore.collection('users').doc(user.uid).set(newProfile);
        _userProfile = UserProfile.fromMap(newProfile);
      } else {
        _userProfile = UserProfile.fromMap({
          'uid': user.uid,
          ...doc.data() ?? {},
        });
      }

      await loadUserStats();

   } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      return query.docs.isEmpty;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? username,
    String? avatar,
    BuildContext? context,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception(context?.localizations.auth_required);
      }

      final updates = <String, dynamic>{};
      
      if (name != null) {
        updates['name'] = name;
        await user.updateDisplayName(name);
      }

      if (username != null) {
        final isAvailable = await checkUsernameAvailable(username);
        if (!isAvailable && username != _userProfile?.username) {
          throw Exception(context?.localizations.username_taken);
        }
        updates['username'] = username;
      }

      if (avatar != null) {
        updates['avatar'] = avatar;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
        await loadUserProfile(); 
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<void> loadUserStats() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      _totalStories = 0;
      _totalLikes = 0;
      _isLoading = false;
      notifyListeners();
      return;
    }

    final stats = await _repository.getUserStats();
    _totalStories = stats['totalStories'];
    _totalLikes = stats['totalLikes'];

    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    _error = e.toString();
    notifyListeners();
  }}

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 