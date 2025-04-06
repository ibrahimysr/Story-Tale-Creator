import 'package:flutter/material.dart';
import 'package:masal/viewmodels/story_discover_viewmodel.dart';
import 'package:masal/viewmodels/story_display_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/widgets/story/story_library/story_library_item.dart';
import 'package:masal/core/theme/space_theme.dart';

class StoriesList extends StatelessWidget {
  final StoryDiscoverViewModel discoverViewModel;
  final StoryDisplayViewModel displayViewModel; 

  const StoriesList({
    super.key,
    required this.discoverViewModel,
    required this.displayViewModel, 
  });

  @override
  Widget build(BuildContext context) {
     if (discoverViewModel.context == null) {
          discoverViewModel.updateContext(context);  
        }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!discoverViewModel.isLoadingMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent * 0.8 &&
              discoverViewModel.canLoadMore) {
            discoverViewModel.loadMoreStories();
          }
          return true;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: discoverViewModel.stories.length +
              (discoverViewModel.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == discoverViewModel.stories.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
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

            final story = discoverViewModel.stories[index];
            return Padding(
              padding: const EdgeInsets.all( 2.0),
              child: StoryLibraryItem(
                story: story,
                onTap: () => _viewStoryDetail(context, story),
                onDelete: null,
                onLike: () => discoverViewModel.toggleLike(story.id),
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
}