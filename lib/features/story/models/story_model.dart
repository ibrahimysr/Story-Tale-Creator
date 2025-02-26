import 'dart:typed_data';

class StoryModel {
  final String title;
  final String content;
  final Uint8List? image;

  StoryModel({
    required this.title,
    required this.content,
    this.image,
  });

  factory StoryModel.fromText(String text) {
    final lines = text.split('\n');
    String title = "Hikayem";
    String content = text;

    if (lines.isNotEmpty) {
      title = lines[0].replaceAll('#', '').trim();
      if (lines.length > 1) {
        content = lines.sublist(1).join('\n').trim();
      }
    }

    return StoryModel(title: title, content: content);
  }
} 