import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masal/env.dart';
import '../models/story_model.dart';
import '../../../core/constants/app_constants.dart';

class StoryService {
  Future<StoryModel> generateStory({
    required String place,
    required String character,
    required String time,
    required String emotion,
    required String event,
  }) async {
    final prompt = """
    Çocuklar için kısa bir hikaye oluştur.
    Hikaye şu özellikleri içermeli:
    - Mekan: $place
    - Karakter: $character
    - Zaman: $time
    - Ana duygu: $emotion
    - Olay: $event
    
    Hikaye 6-7 paragraf uzunluğunda olmalı ve 7-10 yaş arası çocuklar için uygun olmalı.
    Hikayenin başlığı da olsun. Hikaye Türkçe olmalı.
    """;

    try {
      final response = await http.post(
        Uri.parse('${Environment.geminiApiUrl}?key=${AppConstants.geminiApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Hikaye oluşturulamadı: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body);
      final storyText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return StoryModel.fromText(storyText);
    } catch (e) {
      throw Exception('Hikaye oluşturulurken bir hata oluştu: $e');
    }
  }
} 