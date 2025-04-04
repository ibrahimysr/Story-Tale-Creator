import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:masal/environment_config.dart';
import '../../model/story/story_model.dart';

class StoryService {
  Future<StoryModel> generateStory({
    required String place,
    required String character,
    required String time,
    required String emotion,
    required String event,
    required String languageCode,
  }) async {
    String prompt;

    if (languageCode == 'tr') {
      prompt = """
Çocuklar için eğlenceli, hayal gücünü harekete geçiren ve kısa bir hikaye yaz.
Hikaye şu özelliklere sahip olmalı:
- Mekan: $place (mekanı hikayede canlı ve detaylı bir şekilde tarif et)
- Karakter: $character (karakterin kişiliğini ve özelliklerini vurgula)
- Zaman: $time (zamanı hikayeye doğal bir şekilde yedir)
- Ana duygu: $emotion (bu duygu hikayenin tonunu belirlesin)
- Olay: $event (olayı heyecanlı ve merak uyandırıcı yap)

Hikaye 8-9 paragraf uzunluğunda olmalı ve 5-10 yaş arası çocuklar için uygun olmalı.
Hikaye akıcı, sade ve eğlenceli bir dille yazılmalı; karmaşık kelimelerden kaçınılmalı.
Hikayenin başında # işareti ile başlayan, kısa ve çarpıcı bir başlık olmalı (en fazla 5 kelime).
Örnek başlık: # Gizemli Ormanın Kahramanı
Hikaye Türkçe olmalı ve çocukların ilgisini çekecek şekilde bir başlangıç, gelişme ve tatmin edici bir son içermeli.
""";
    } else {
      prompt = """
Write a fun, imaginative, and short story for children.
The story should have the following features:
- Location: $place (describe the location vividly and in detail in the story)
- Character: $character (emphasize the character's personality and traits)
- Time: $time (naturally weave the time into the story)
- Main emotion: $emotion (this emotion should set the tone of the story)
- Event: $event (make the event exciting and intriguing)

The story should be 8-9 paragraphs long and suitable for children aged 5-10.
The story should be written in a fluent, simple, and fun language; avoid complex words.
At the beginning of the story, there should be a short and striking title starting with # (maximum 5 words).
Example title: # Hero of the Mysterious Forest
The story must be in English and should contain an engaging beginning, development, and a satisfying conclusion suitable for children.
""";
    }

    try {
      final response = await http.post(
        Uri.parse(
            '${Environment.geminiApiUrl}?key=${Environment.geminiApiKey}'),
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
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        log("API Error Response Body: ${response.body}");
        throw Exception(
            'API anahtarı geçersiz veya yetkisiz. Lütfen destek ekibiyle iletişime geçin.');
      } else if (response.statusCode != 200) {
        log("API Error Response Body (${response.statusCode}): ${response.body}");
        throw Exception(
            'Hikaye oluşturulamadı (Hata Kodu: ${response.statusCode}). Lütfen daha sonra tekrar deneyin veya destek ekibine başvurun.');
      }

      final jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      log("STORY SERVICE: API Raw Response: $jsonResponse");

      if (jsonResponse['promptFeedback']?['blockReason'] != null) {
        final reason = jsonResponse['promptFeedback']['blockReason'];
        log("STORY SERVICE: Prompt blocked due to safety settings. Reason: $reason");
        throw Exception(
            'Seçimleriniz veya isteminiz güvenlik filtrelerine takıldı. Lütfen farklı seçimler deneyin. Sebep: $reason');
      }

      final candidates = jsonResponse['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) {
        log("STORY SERVICE: No candidates found in response.");
        if (jsonResponse['promptFeedback']?['blockReason'] != null) {
          throw Exception(
              'İstem güvenlik filtrelerine takıldı. Lütfen farklı seçimler deneyin.');
        }
        throw Exception(
            'Hikaye oluşturulamadı (API yanıtı boş). Lütfen farklı seçimlerle deneyin veya destek ekibine başvurun.');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;

      if (parts == null || parts.isEmpty) {
        log("STORY SERVICE: No parts found in candidate content.");
        throw Exception(
            'Hikaye metni alınamadı (API yanıt formatı?). Lütfen tekrar deneyin.');
      }

      final storyText = parts[0]['text'] as String?;

      if (storyText == null || storyText.isEmpty) {
        log("STORY SERVICE: Empty story text received.");
        throw Exception('Oluşturulan hikaye boş. Lütfen tekrar deneyin.');
      }

      log("STORY SERVICE: Received Story Text:\n$storyText");
      return StoryModel.fromText(storyText);
    } on FormatException catch (e) {
      log("STORY SERVICE: JSON FormatException: $e");
      throw Exception(
          'Hikaye formatında bir sorun oluştu (API yanıtı?). Lütfen tekrar deneyin.');
    } catch (e) {
      log("STORY SERVICE: Error during story generation: $e");
      if (e is Exception) {
        rethrow;
      }
      throw Exception(
          'Beklenmeyen bir hata oluştu: $e. Lütfen destek ekibiyle iletişime geçin.');
    }
  }
}
