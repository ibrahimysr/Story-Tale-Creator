import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/story_discover_viewmodel.dart';
import '../../widgets/story/story_library_item.dart';
import 'story_display_view.dart';

class StoryDiscoverView extends StatelessWidget {
  const StoryDiscoverView({Key? key}) : super(key: key);

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
                            return _buildEmptyView();
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

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off,
            color: Colors.amber[100],
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz hikaye paylaşılmamış',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'İlk hikayeyi siz oluşturun!',
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
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: viewModel.stories.length,
        itemBuilder: (context, index) {
          final story = viewModel.stories[index];
          return StoryLibraryItem(
            story: story,
            onTap: () => _viewStoryDetail(context, story),
            onDelete: null, // Keşfet sayfasında silme butonu gizlenecek
            onLike: () => viewModel.toggleLike(story.id),
          );
        },
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

  Widget _buildSearchBar() {
    return Consumer<StoryDiscoverViewModel>(
      builder: (context, viewModel, _) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Hikaye ara...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (viewModel.searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    viewModel.setSearchQuery('');
                  },
                ),
            ],
          ),
        );
      },
    );
  }
} 