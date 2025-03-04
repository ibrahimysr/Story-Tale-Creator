import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_library_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/widgets/story/story_library/story_library_item.dart';

class StoriesList extends StatelessWidget {
  final StoryLibraryViewModel viewModel;

  const StoriesList({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingNormal,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!viewModel.isLoadingMore &&
              scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8 &&
              viewModel.canLoadMore) {
            viewModel.loadMoreStories();
          }
          return true;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: viewModel.stories.length + (viewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == viewModel.stories.length) {
              return Padding(
                padding: context.paddingNormalVertical,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: SpaceTheme.accentPurple,
                    ),
                  ),
                ),
              );
            }

            final story = viewModel.stories[index];
            return Padding(
              padding: EdgeInsets.only(bottom: context.lowValue),
              child: StoryLibraryItem(
                story: story,
                onTap: () => _viewStoryDetail(context, story),
                onDelete: () => _confirmDelete(context, viewModel, story),
                onLike: () => viewModel.toggleLike(story.id),
              ),
            );
          },
        ),
      ),
    );
  }

  void _viewStoryDetail(BuildContext context, story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDisplayView(
          story: story.story,
          title: story.title,
          image: story.imageData,
          showSaveButton: false,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, StoryLibraryViewModel viewModel, story) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SpaceTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: SpaceTheme.accentPurple.withValues(alpha:0.5),
              width: 2,
            ),
          ),
          title: const Text(
            'Hikayeyi Sil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bu hikayeyi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha:0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Sil',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await viewModel.deleteStory(story);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Hikaye başarıyla silindi',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      backgroundColor: SpaceTheme.accentPurple.withValues(alpha:0.8),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Hikaye silinirken bir hata oluştu: ${e.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      backgroundColor: Colors.red.withValues(alpha:0.8),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}