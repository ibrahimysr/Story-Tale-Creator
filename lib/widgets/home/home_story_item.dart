import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import '../../core/theme/space_theme.dart';
import '../../model/home/home_story_model.dart';

class HomeStoryItem extends StatelessWidget {
  final HomeStoryModel story;
  final VoidCallback onTap;

  const HomeStoryItem({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getDynamicWidth(40),
      margin:  EdgeInsets.only(right: context.lowValue*1.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SpaceTheme.accentPurple.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: SpaceTheme.accentPurple.withValues(alpha: 0.3),
            highlightColor: SpaceTheme.accentPurple.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.getDynamicHeight(13),
                  width: double.infinity,
                  child: story.hasImage && story.imageData != null
                      ? Image.memory(
                          story.imageData!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: SpaceTheme.accentBlue.withValues(alpha: 0.2),
                          child: const Center(
                            child: Icon(
                              Icons.book,
                              color: Colors.white70,
                              size: 40,
                            ),
                          ),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            story.previewText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                         SizedBox(height: context.getDynamicHeight(0.5)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: SpaceTheme.accentBlue.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Okumaya Devam Et',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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