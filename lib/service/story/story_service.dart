import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masal/EnvironmentConfig.dart';
import '../../model/story/story_model.dart';

class StoryService {
  Future<StoryModel> generateStory({
    required String place,
    required String character,
    required String time,
    required String emotion,
    required String event,
  }) async {
   final prompt = """
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
Hikaye ingilizce olmalı ve çocukların ilgisini çekecek şekilde bir başlangıç, gelişme ve tatmin edici bir son içermeli.
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
      } else if (response.statusCode == 401) {
        throw Exception('API anahtarı geçersiz. Lütfen destek ekibiyle iletişime geçin.');
      } else if (response.statusCode != 200) {
        throw Exception('Hikaye oluşturulamadı (Hata Kodu: ${response.statusCode}). Lütfen daha sonra tekrar deneyin.');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = jsonResponse['candidates'] as List<dynamic>;

      if (candidates.isEmpty) {
        throw Exception('Hikaye oluşturulamadı. Lütfen farklı seçimlerle deneyin.');
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
      throw Exception('Beklenmeyen bir hata oluştu. Lütfen destek ekibiyle iletişime geçin.');
    }
  }
}