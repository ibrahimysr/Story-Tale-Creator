import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_library_viewmodel.dart';
import 'package:masal/viewmodels/story_display_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/widgets/story/story_library/story_library_item.dart';

class StoriesList extends StatelessWidget {
  final StoryLibraryViewModel libraryViewModel;
  final StoryDisplayViewModel displayViewModel;

  const StoriesList({
    super.key,
    required this.libraryViewModel,
    required this.displayViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingNormal,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!libraryViewModel.isLoadingMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent * 0.8 &&
              libraryViewModel.canLoadMore) {
            libraryViewModel.loadMoreStories();
          }
          return true;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: libraryViewModel.stories.length +
              (libraryViewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == libraryViewModel.stories.length) {
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

            final story = libraryViewModel.stories[index];
            return Padding(
              padding: EdgeInsets.all(context.lowValue),
              child: StoryLibraryItem(
                story: story,
                onTap: () => _viewStoryDetail(context, story),
                onDelete: () =>
                    _confirmDelete(context, libraryViewModel, story),
                onLike: () => libraryViewModel.toggleLike(story.id),
                viewModel: displayViewModel,
              ),
            );
          },
        ),
      ),
    );
  }

  void _viewStoryDetail(BuildContext context, story) {
    Navigator.pushReplacement(
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

  Future<void> _confirmDelete(
      BuildContext context, StoryLibraryViewModel viewModel, story) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SpaceTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: SpaceTheme.accentPurple.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          title: Text(
            context.localizations.deleteStoryTitle,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            context.localizations.deleteStoryMessage,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  context.localizations.cancel,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  context.localizations.delete,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await viewModel.deleteStory(story);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.localizations.storyDeletedSuccess,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      backgroundColor:
                          SpaceTheme.accentPurple.withValues(alpha: 0.8),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.localizations.storyDeletedError(e.toString()),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      backgroundColor: Colors.red.withValues(alpha: 0.8),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
