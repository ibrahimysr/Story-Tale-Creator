import 'dart:typed_data';

class StoryDisplayModel {
  final String story;
  final String title;
  final Uint8List? image;
  final String? imageFilePath;

  StoryDisplayModel({
    required this.story,
    required this.title,
    this.image,
    this.imageFilePath,
  });

  factory StoryDisplayModel.fromFirebase(Map<String, dynamic> data) {
    return StoryDisplayModel(
      story: data['story'] as String,
      title: data['title'] as String? ?? 'Adsız Hikaye',
      imageFilePath: data['imageFilePath'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'story': story,
      'title': title,
      'hasImage': image != null || imageFilePath != null,
      'imageFilePath': imageFilePath,
    };
  }
} 