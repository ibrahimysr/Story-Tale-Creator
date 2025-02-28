import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeStoryModel {
  final String id;
  final String story;
  final String? title;
  final String userId;
  final DateTime createdAt;
  final bool hasImage;
  final String? imageFilePath;
  Uint8List? imageData;

  HomeStoryModel({
    required this.id,
    required this.story,
    this.title,
    required this.userId,
    required this.createdAt,
    required this.hasImage,
    this.imageFilePath,
    this.imageData,
  });

  // Firebase'den gelen veriyi modele dönüştürmek için factory constructor
  factory HomeStoryModel.fromFirebase(String id, Map<String, dynamic> data) {
    return HomeStoryModel(
      id: id,
      story: data['story'] as String,
      title: data['title'] as String?,
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      hasImage: data['hasImage'] as bool? ?? false,
      imageFilePath: data['imageFilePath'] as String?,
    );
  }

  // Önizleme metni
  String get previewText {
    return story.length > 80 ? '${story.substring(0, 80)}...' : story;
  }
} 