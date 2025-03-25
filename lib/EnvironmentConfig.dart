import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentConfig {
  static const String _GEMINI_API_KEY_PREF = 'gemini_api_key';
  static const String _VYRO_API_KEY_PREF = 'vyro_api_key';
  static const String _API_KEYS_COLLECTION = 'app_configurations';

  static Future<void> initializeEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    final firestore = FirebaseFirestore.instance;

    try {
      String? storedGeminiKey = prefs.getString(_GEMINI_API_KEY_PREF);
      String? storedVyroKey = prefs.getString(_VYRO_API_KEY_PREF);

      if (storedGeminiKey == null || storedVyroKey == null) {
        DocumentSnapshot configDoc = await firestore
            .collection(_API_KEYS_COLLECTION)
            .doc('api_keys')
            .get();

        if (configDoc.exists) {
          final data = configDoc.data() as Map<String, dynamic>;

          await prefs.setString(_GEMINI_API_KEY_PREF, data['gemini_api_key']);
          await prefs.setString(_VYRO_API_KEY_PREF, data['vyro_api_key']);

          Environment.geminiApiKey = data['gemini_api_key'];
          Environment.vyroApiKey = data['vyro_api_key'];
        } else {
          log('API keys not found in Firestore');
        }
      } else {
        Environment.geminiApiKey = storedGeminiKey;
        Environment.vyroApiKey = storedVyroKey;
      }
    } catch (e) {
      log('Error initializing environment: $e');
    }
  }
}

class Environment {
  static String geminiApiUrl =
      "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent";
  static String vyroApiUrl = 'https://api.vyro.ai/v2/image/generations';

  static String geminiApiKey = "";
  static String vyroApiKey = "";
}
