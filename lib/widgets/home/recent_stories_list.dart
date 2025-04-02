import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/widgets/home/home_story_item.dart';
import 'package:provider/provider.dart';
import 'package:masal/core/theme/space_theme.dart';

class RecentStoriesList extends StatelessWidget {
  const RecentStoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoadingStories && !viewModel.hasStories) {
          return Center(
            child: CircularProgressIndicator(
              color: SpaceTheme.accentPurple,
            ),
          );
        }

        if (viewModel.storyLoadError != null && !viewModel.hasStories) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.amber[100], size: 32),
                const SizedBox(height: 8),
                Text(
                  viewModel.storyLoadError!,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: viewModel.loadRecentStories,
                  child: Text(
                   context.localizations.tryAgain,
                    style: TextStyle(color: SpaceTheme.accentBlue),
                  ),
                ),
              ],
            ),
          );
        }

        if (!viewModel.hasStories) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book, color: Colors.amber[100], size: 32),
                const SizedBox(height: 8),
                 Text(
                 context.localizations.createNewStory,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!viewModel.isLoadingMore && 
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                viewModel.canLoadMore) {
              viewModel.loadMoreStories();
            }
            return true;
          },
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: viewModel.recentStories.length + (viewModel.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == viewModel.recentStories.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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

              final story = viewModel.recentStories[index];
              return HomeStoryItem(
                story: story,
                onTap: () => _viewStoryDetail(context, story),
              );
            },
          ),
        );
      },
    );
  }

  void _viewStoryDetail(BuildContext context, story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDisplayView(
          story: story.story,
          title: story.title ?? "Hikayem",
          image: story.imageData,
          showSaveButton: false,
        ),
      ),
    );
  }
}