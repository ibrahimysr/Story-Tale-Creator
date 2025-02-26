import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:masal/env.dart';
import '../models/story_options_model.dart';
import '../../../core/constants/app_constants.dart';

class ImageService {
  Future<Uint8List> generateImage({
    required String place,
    required String character,
    required String event,
    required String title,
  }) async {
    try {
      final String placeEn = StoryOptionsModel.placeTranslations[place] ?? 'Magical place';
      final String characterEn = StoryOptionsModel.characterTranslations[character] ?? 'Brave hero';
      final String eventEn = StoryOptionsModel.eventTranslations[event] ?? 'Exciting adventure';

      final prompt = "A colorful cartoon-style illustration for a children's book. Setting: $placeEn, Character: $characterEn, Event: $eventEn, Story title: $title";

      var request = http.MultipartRequest('POST', Uri.parse(Environment.vyroApiUrl));
      request.headers['Authorization'] = 'Bearer ${AppConstants.vyroApiKey}';
      request.fields['prompt'] = prompt;
      request.fields['style'] = 'imagine-turbo';
      request.fields['aspect_ratio'] = '1:1';

      var response = await request.send();
      var responseData = await response.stream.toBytes();

      if (response.statusCode != 200) {
        throw Exception('Görsel oluşturulamadı: ${response.statusCode}');
      }

      return responseData;
    } catch (e) {
      throw Exception('Görsel oluşturulurken bir hata oluştu: $e');
    }
  }
} 