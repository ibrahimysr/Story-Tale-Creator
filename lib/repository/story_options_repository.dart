import 'package:cloud_firestore/cloud_firestore.dart';

class StoryOptionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 

  Future<List<String>> getPlaces() async {
    try {
      final doc = await _firestore.collection('categories').doc('places').get();
      return List<String>.from(doc.data()?['options'] ?? []);
    } catch (e) {
      throw Exception('Mekanlar yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<String>> getCharacters() async {
    try {
      final doc = await _firestore.collection('categories').doc('characters').get();
      return List<String>.from(doc.data()?['options'] ?? []);
    } catch (e) {
      throw Exception('Karakterler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<String>> getTimes() async {
    try {
      final doc = await _firestore.collection('categories').doc('times').get();
      return List<String>.from(doc.data()?['options'] ?? []);
    } catch (e) {
      throw Exception('Zamanlar yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<String>> getEmotions() async {
    try {
      final doc = await _firestore.collection('categories').doc('emotions').get();
      return List<String>.from(doc.data()?['options'] ?? []);
    } catch (e) {
      throw Exception('Duygular yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<String>> getEvents() async {
    try {
      final doc = await _firestore.collection('categories').doc('events').get();
      return List<String>.from(doc.data()?['options'] ?? []);
    } catch (e) {
      throw Exception('Olaylar yüklenirken bir hata oluştu: $e');
    }
  }

  Future<Map<String, String>> getPlaceTranslations() async {
    try {
      final doc = await _firestore.collection('categories').doc('places').get();
      final translations = doc.data()?['translations'] as Map<String, dynamic>?;
      return Map<String, String>.from(translations ?? {});
    } catch (e) {
      throw Exception('Mekan çevirileri yüklenirken bir hata oluştu: $e');
    }
  }

  Future<Map<String, String>> getCharacterTranslations() async {
    try {
      final doc = await _firestore.collection('categories').doc('characters').get();
      final translations = doc.data()?['translations'] as Map<String, dynamic>?;
      return Map<String, String>.from(translations ?? {});
    } catch (e) {
      throw Exception('Karakter çevirileri yüklenirken bir hata oluştu: $e');
    }
  }

  Future<Map<String, String>> getEventTranslations() async {
    try {
      final doc = await _firestore.collection('categories').doc('events').get();
      final translations = doc.data()?['translations'] as Map<String, dynamic>?;
      return Map<String, String>.from(translations ?? {});
    } catch (e) {
      throw Exception('Olay çevirileri yüklenirken bir hata oluştu: $e');
    }
  }
} 