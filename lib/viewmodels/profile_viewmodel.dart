import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturumu bulunamadı');
      }

      // Önce auth bilgilerini alalım
      String displayName = user.displayName ?? '';
      String email = user.email ?? '';

      // Firestore'dan kullanıcı bilgilerini alalım
      final doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        // Eğer kullanıcı Firestore'da yoksa, yeni profil oluşturalım
        final newProfile = {
          'uid': user.uid,
          'name': displayName,
          'username': email.split('@')[0], // Email'den basit bir username oluştur
          'stories': 0,
          'missions': '0/10',
          'level': 1,
        };
        
        await _firestore.collection('users').doc(user.uid).set(newProfile);
        _userProfile = UserProfile.fromMap(newProfile);
      } else {
        // Varolan profili yükleyelim
        _userProfile = UserProfile.fromMap({
          'uid': user.uid,
          ...doc.data() ?? {},
        });
      }
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
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturumu bulunamadı');
      }

      final updates = <String, dynamic>{};
      
      if (name != null) {
        updates['name'] = name;
        // Auth displayName'i de güncelle
        await user.updateDisplayName(name);
      }

      if (username != null) {
        // Kullanıcı adının kullanılabilir olduğunu kontrol et
        final isAvailable = await checkUsernameAvailable(username);
        if (!isAvailable && username != _userProfile?.username) {
          throw Exception('Bu kullanıcı adı zaten kullanımda');
        }
        updates['username'] = username;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
        await loadUserProfile(); // Profili yeniden yükle
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 