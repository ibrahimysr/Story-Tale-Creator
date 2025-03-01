import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryLibraryModel {
  final String id;
  final String story;
  final String title;
  final String userId;
  final DateTime createdAt;
  final bool hasImage;
  final String? imageFileName; // Yeni isim
  final int likeCount;
  final List<String> likedByUsers;
  Uint8List? imageData;

  StoryLibraryModel({
    required this.id,
    required this.story,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.hasImage,
    this.imageFileName, // Yeni isim
    this.imageData,
    this.likeCount = 0,
    this.likedByUsers = const [],
  });

  factory StoryLibraryModel.fromFirebase(String id, Map<String, dynamic> data) {
    return StoryLibraryModel(
      id: id,
      story: data['story'] as String,
      title: data['title'] as String? ?? 'Adsız Hikaye',
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      hasImage: data['hasImage'] as bool? ?? false,
      imageFileName: data['imageFileName'] as String?, // Yeni alan
      likeCount: data['likeCount'] as int? ?? 0,
      likedByUsers: List<String>.from(data['likedByUsers'] ?? []),
    );
  }

  bool isLikedByUser(String userId) {
    return likedByUsers.contains(userId);
  }

  String get previewText {
    return story.length > 100 ? '${story.substring(0, 100)}...' : story;
  }

  String get formattedDate {
    return '${createdAt.day}.${createdAt.month}.${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}