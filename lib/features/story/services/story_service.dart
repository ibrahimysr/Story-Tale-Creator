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
        Uri.parse('${Environment.geminiApiUrl}?key=${Environment.geminiApiKey}'),
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

      if (response.statusCode == 429) {
        throw Exception('Çok fazla istek gönderildi. Lütfen biraz bekleyin.');
      }

      if (response.statusCode == 401) {
        throw Exception('API anahtarı geçersiz. Lütfen daha sonra tekrar deneyin.');
      }

      if (response.statusCode != 200) {
        throw Exception('Hikaye oluşturulamadı. Lütfen daha sonra tekrar deneyin.');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = jsonResponse['candidates'] as List<dynamic>;
      
      if (candidates.isEmpty) {
        throw Exception('Hikaye oluşturulamadı. Lütfen farklı seçimlerle tekrar deneyin.');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      
      if (parts.isEmpty) {
        throw Exception('Hikaye metni alınamadı. Lütfen tekrar deneyin.');
      }

      final storyText = parts[0]['text'] as String;
      
      if (storyText.isEmpty) {
        throw Exception('Oluşturulan hikaye boş. Lütfen tekrar deneyin.');
      }

      return StoryModel.fromText(storyText);
    } on FormatException {
      throw Exception('Hikaye formatında bir sorun oluştu. Lütfen tekrar deneyin.');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }
} 