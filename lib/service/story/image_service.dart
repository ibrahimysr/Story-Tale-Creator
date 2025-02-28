import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:masal/env.dart';

class ImageService {
  Future<Uint8List> generateImage({
    required String place,
    required String character,
    required String event,
    required String title,
  }) async {
    try {
      final prompt = "A colorful cartoon-style illustration for a children's book. Setting: $place, Character: $character, Event: $event, Story title: $title";
      
    

      var request = http.MultipartRequest('POST', Uri.parse(Environment.vyroApiUrl));
      request.headers['Authorization'] = 'Bearer ${Environment.vyroApiKey}';
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
      log('Resim oluşturma hatası: $e');
      throw Exception('Görsel oluşturulurken bir hata oluştu: $e');
    }
  }
} 