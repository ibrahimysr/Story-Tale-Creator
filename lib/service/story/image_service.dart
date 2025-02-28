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
      
      print('Resim oluşturma isteği gönderiliyor...');
      print('Prompt: $prompt');

      var request = http.MultipartRequest('POST', Uri.parse(Environment.vyroApiUrl));
      request.headers['Authorization'] = 'Bearer ${Environment.vyroApiKey}';
      request.fields['prompt'] = prompt;
      request.fields['style'] = 'imagine-turbo';
      request.fields['aspect_ratio'] = '1:1';

      print('API isteği gönderiliyor...');
      var response = await request.send();
      print('API yanıt kodu: ${response.statusCode}');
      
      var responseData = await response.stream.toBytes();
      print('Alınan veri boyutu: ${responseData.length} bytes');

      if (response.statusCode != 200) {
        print('API hatası: ${response.statusCode}');
        throw Exception('Görsel oluşturulamadı: ${response.statusCode}');
      }

      return responseData;
    } catch (e) {
      print('Resim oluşturma hatası: $e');
      throw Exception('Görsel oluşturulurken bir hata oluştu: $e');
    }
  }
} 