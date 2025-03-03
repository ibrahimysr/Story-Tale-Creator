import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/story_discover_viewmodel.dart';
import '../../widgets/story/story_library_item.dart';
import 'story_display_view.dart';

class StoryDiscoverView extends StatelessWidget {
  const StoryDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryDiscoverViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: SpaceTheme.primaryDark,
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: SpaceTheme.mainGradient,
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: StarryBackground(),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildSearchBar(),
                    Expanded(
                      child: Consumer<StoryDiscoverViewModel>(
                        builder: (context, viewModel, _) {
                          if (viewModel.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: SpaceTheme.accentPurple,
                              ),
                            );
                          }

                          if (viewModel.errorMessage != null) {
                            return _buildErrorView(context, viewModel);
                          }

                          if (!viewModel.hasStories) {
                            return _buildEmptyView(viewModel.isSearching);
                          }

                          return _buildStoriesList(context, viewModel);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<StoryDiscoverViewModel>(
      builder: (context, viewModel, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => viewModel.search(value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Hikayelerde ara...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white.withValues(alpha:0.6),
              ),
              filled: true,
              fillColor: SpaceTheme.accentPurple.withValues(alpha:0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Keşfet',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      actions: [
        Consumer<StoryDiscoverViewModel>(
          builder: (context, viewModel, _) {
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: SpaceTheme.iconContainerDecoration,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
              onPressed: viewModel.loadStories,
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, StoryDiscoverViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[300],
            size: 60,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.loadStories,
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Tekrar Dene',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.explore_off,
            color: Colors.amber[100],
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Aradığınız kriterlere uygun hikaye bulunamadı'
                : 'Henüz hikaye paylaşılmamış',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (!isSearching)
            const Text(
              'İlk hikayeyi siz paylaşın!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(BuildContext context, StoryDiscoverViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
       if (!viewModel.isLoadingMore && 
    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8 &&
      viewModel.canLoadMore) {  // This condition is key
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              padding: const EdgeInsets.only(bottom: 16.0),
              child: StoryLibraryItem(
                story: story,
                onTap: () => _viewStoryDetail(context, story),
                onDelete: null,
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
} 