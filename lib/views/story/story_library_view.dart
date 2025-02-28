import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/story_library_viewmodel.dart';
import '../../widgets/story/story_library_item.dart';
import 'story_display_view.dart';

class StoryLibraryView extends StatelessWidget {
  const StoryLibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryLibraryViewModel(),
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
                child: Consumer<StoryLibraryViewModel>(
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Hikaye Kütüphanem',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      actions: [
        Consumer<StoryLibraryViewModel>(
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

  Widget _buildErrorView(BuildContext context, StoryLibraryViewModel viewModel) {
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
            Icons.book,
            color: Colors.amber[100],
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz kaydedilmiş hikayeniz yok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yeni bir hikaye oluşturun ve kaydedin!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(BuildContext context, StoryLibraryViewModel viewModel) {
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
            onDelete: () => _confirmDelete(context, viewModel, story),
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
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    StoryLibraryViewModel viewModel,
    story,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SpaceTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: SpaceTheme.accentPurple.withOpacity(0.5),
              width: 2,
            ),
          ),
          title: const Text(
            'Hikayeyi Sil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bu hikayeyi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'İptal',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Sil',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await viewModel.deleteStory(story);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Hikaye başarıyla silindi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      backgroundColor: SpaceTheme.accentPurple.withOpacity(0.8),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Hikaye silinirken bir hata oluştu: ${e.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.red.withOpacity(0.8),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
