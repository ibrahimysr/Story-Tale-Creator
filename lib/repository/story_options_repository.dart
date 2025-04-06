import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryOptions {
  final List<String> en;
  final List<String> tr;
  final List<String> es;

  CategoryOptions({
    required this.en, 
    required this.tr, 
    required this.es});

  List<String> getOptions(String languageCode) {
    switch (languageCode) {
      case 'tr':
        return tr;
      case 'es':
        return es.isNotEmpty ? es : en; 
      default:
        return en;
    }
  }

  String? findEnglishEquivalent(String value) {
    // Check in Turkish list
    int index = tr.indexOf(value);
    if (index != -1 && index < en.length) {
      return en[index];
    }
    
    // Check in Spanish list
    index = es.indexOf(value);
    if (index != -1 && index < en.length) {
      return en[index];
    }
    
    // Check if it's already in English
    index = en.indexOf(value);
    if (index != -1) {
      return en[index];
    }
    
    return null;
  }
}

class StoryOptionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CategoryOptions> _getCategoryOptions(String categoryId) async {
    try {
      final doc =
          await _firestore.collection('categoriess').doc(categoryId).get();
      final data = doc.data();
      if (data == null) {
        return CategoryOptions(en: [], tr: [], es: []);
      }

      final enOptions = List<String>.from(data['en'] ?? []);
      final trOptions = List<String>.from(data['tr'] ?? []);
      final esOptions = List<String>.from(data['es'] ?? []);

      if (kDebugMode) {
        if (enOptions.length != trOptions.length) {
          print('Warning: English and Turkish options count mismatch for $categoryId');
        }
        if (enOptions.length != esOptions.length && esOptions.isNotEmpty) {
          print('Warning: English and Spanish options count mismatch for $categoryId');
        }
      }

      return CategoryOptions(
        en: enOptions, 
        tr: trOptions, 
        es: esOptions
      );
    } catch (e) {
      throw Exception('Error loading options for "$categoryId": $e');
    }
  }

  Future<CategoryOptions> getPlaces() async {
    return await _getCategoryOptions('places');
  }

  Future<CategoryOptions> getCharacters() async {
    return await _getCategoryOptions('characters');
  }

  Future<CategoryOptions> getTimes() async {
    return await _getCategoryOptions('times');
  }

  Future<CategoryOptions> getEmotions() async {
    return await _getCategoryOptions('emotions');
  }

  Future<CategoryOptions> getEvents() async {
    return await _getCategoryOptions('events');
  }
}