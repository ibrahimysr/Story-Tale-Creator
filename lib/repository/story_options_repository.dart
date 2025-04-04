import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryOptions {
  final List<String> en;
  final List<String> tr;

  CategoryOptions({required this.en, required this.tr});

  List<String> getOptions(String languageCode) {
    return languageCode == 'tr' ? tr : en;
  }

  String? findEnglishEquivalent(String value) {
    int index = tr.indexOf(value);
    if (index != -1 && index < en.length) {
      return en[index];
    }
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
        return CategoryOptions(en: [], tr: []);
      }

      final enOptions = List<String>.from(data['en'] ?? []);
      final trOptions = List<String>.from(data['tr'] ?? []);

      if (enOptions.length != trOptions.length && kDebugMode) {}

      return CategoryOptions(en: enOptions, tr: trOptions);
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
