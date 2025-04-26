import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/model/story/story_library_model.dart';
import 'package:masal/viewmodels/story_display_viewmodel.dart';
import 'package:masal/widgets/report_button.dart'; 

class StoryLibraryItem extends StatelessWidget {
  final StoryLibraryModel story;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback onLike;
  final StoryDisplayViewModel viewModel; 

  const StoryLibraryItem({
    super.key,
    required this.story,
    required this.onTap,
    this.onDelete,
    required this.onLike,
    required this.viewModel, 
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLiked = story.isLikedByUser(currentUser?.uid ?? '');

    return Container(
      margin: EdgeInsets.all( context.lowValue),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SpaceTheme.accentPurple.withValues(alpha: 0.2),
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
            splashColor: SpaceTheme.accentPurple.withValues(alpha: 0.3),
            highlightColor: SpaceTheme.accentPurple.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: context.paddingLow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: context.getDynamicHeight(2)),
                                Text(
                                  story.formattedDate,
                                  style: TextStyle(
                                    color: Colors.amber[100],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: onLike,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLiked
                                        ? SpaceTheme.accentPurple
                                            .withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
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
                              if (onDelete != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[300],
                                    size: 22,
                                  ),
                                  onPressed: onDelete,
                                ),
                              ],
                              const SizedBox(width: 8),
                              ReportButton(
                                viewModel: viewModel,
                                storyTitle: story.title,
                                storyContent: story.previewText, 
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (story.hasImage && story.imageData != null)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: SpaceTheme.accentPurple
                                        .withValues(alpha: 0.2),
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
                                      color: SpaceTheme.accentBlue
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:  Text(
                                      context.localizations.readTheStory,
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