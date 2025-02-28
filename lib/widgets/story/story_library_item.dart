import 'package:flutter/material.dart';
import '../../core/theme/space_theme.dart';
import '../../model/story/story_library_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoryLibraryItem extends StatelessWidget {
  final StoryLibraryModel story;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback onLike;

  const StoryLibraryItem({
    Key? key,
    required this.story,
    required this.onTap,
    this.onDelete,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLiked = story.isLikedByUser(currentUser?.uid ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SpaceTheme.accentPurple.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: SpaceTheme.accentPurple.withOpacity(0.3),
            highlightColor: SpaceTheme.accentPurple.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Üst kısım: Tarih, Beğeni ve Silme butonu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story.formattedDate,
                                style: TextStyle(
                                  color: Colors.amber[100],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Beğeni butonu ve sayacı
                              InkWell(
                                onTap: onLike,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLiked
                                        ? SpaceTheme.accentPurple.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? Colors.red[300]
                                            : Colors.white70,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        story.likeCount.toString(),
                                        style: TextStyle(
                                          color: isLiked
                                              ? Colors.red[300]
                                              : Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Silme butonu
                              if (onDelete != null) ...[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[300],
                                    size: 22,
                                  ),
                                  onPressed: onDelete,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Alt kısım: Resim ve Yazı
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Resim
                          if (story.hasImage && story.imageData != null)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: SpaceTheme.accentPurple.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  story.imageData!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (story.hasImage && story.imageData != null)
                            const SizedBox(width: 16),
                          // Yazı ve Hikayeyi Oku butonu
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.previewText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: SpaceTheme.accentBlue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      'Hikayeyi Oku',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 