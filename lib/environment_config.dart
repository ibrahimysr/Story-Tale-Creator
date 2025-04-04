import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentConfig {
  static const String _geminiApiKeyPref = 'gemini_api_key';
  static const String _vyroApiKeyPref = 'vyro_api_key';
  static const String _apiKeysCollection = 'app_configurations';

  static Future<void> initializeEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    final firestore = FirebaseFirestore.instance;

    try {
      String? storedGeminiKey = prefs.getString(_geminiApiKeyPref);
      String? storedVyroKey = prefs.getString(_vyroApiKeyPref);

      if (storedGeminiKey == null || storedVyroKey == null) {
        DocumentSnapshot configDoc = await firestore
            .collection(_apiKeysCollection)
            .doc('api_keys')
            .get();

        if (configDoc.exists) {
          final data = configDoc.data() as Map<String, dynamic>;

          await prefs.setString(_geminiApiKeyPref, data['gemini_api_key']);
          await prefs.setString(_vyroApiKeyPref, data['vyro_api_key']);

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
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent";
  static String vyroApiUrl = 'https://api.vyro.ai/v2/image/generations';

  static String geminiApiKey = "";
  static String vyroApiKey = "";
}
