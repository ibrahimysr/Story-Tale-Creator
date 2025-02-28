import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:masal/views/story/story_creator_view.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/views/story/story_library_view.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/home/home_story_item.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
            child: SafeArea(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: StarryBackground(),
                  ),
                  RefreshIndicator(
                    onRefresh: () => viewModel.loadRecentStories(),
                    color: SpaceTheme.accentPurple,
                    backgroundColor: SpaceTheme.primaryDark.withOpacity(0.8),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom - 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  // Profil resmi
                                  Center(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: SpaceTheme.avatarDecoration,
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Kullanıcı ismi
                                  Text(
                                    'Hoş Geldin Kaşif!',
                                    style: SpaceTheme.titleStyle,
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Arama çubuğu
                                  Container(
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
                                            decoration: InputDecoration(
                                              hintText: 'Macera ara...',
                                              hintStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.6),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 30),
                                  
                                  // Hikaye Yaratıcısı kartı
                                  _buildActivityCard(
                                    title: 'Sihirli Hikaye Yaratıcısı',
                                    description: 'Hayal gücünün sınırlarını zorla ve kendi evrenini yarat!',
                                    icon: Icons.auto_awesome_motion,
                                    color: SpaceTheme.accentPurple,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const StoryCreatorView(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Son Hikayeler Bölümü
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Son Hikayelerim',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const StoryLibraryView(),
                                              ),
                                            ).then((_) => viewModel.loadRecentStories());
                                          },
                                          child: Text(
                                            'Tümünü Gör',
                                            style: TextStyle(
                                              color: SpaceTheme.accentBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Hikaye kartları listesi
                                  SizedBox(
                                    height: 210,
                                    child: _buildRecentStoriesList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentStoriesList() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoadingStories) {
          return Center(
            child: CircularProgressIndicator(
              color: SpaceTheme.accentPurple,
            ),
          );
        }

        if (viewModel.storyLoadError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.amber[100], size: 32),
                const SizedBox(height: 8),
                Text(
                  viewModel.storyLoadError!,
                  style: const TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: viewModel.loadRecentStories,
                  child: Text(
                    'Tekrar Dene',
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
                const Text(
                  'Henüz bir hikaye oluşturmadınız',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: viewModel.recentStories.length,
          itemBuilder: (context, index) {
            final story = viewModel.recentStories[index];
            return HomeStoryItem(
              story: story,
              onTap: () => _viewStoryDetail(context, story),
            );
          },
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

  Widget _buildActivityCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isComingSoon = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Card(
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: isComingSoon ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: SpaceTheme.getCardDecoration(color),
            child: Stack(
              children: [
                // Parlama efekti
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isComingSoon)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: SpaceTheme.comingSoonBadgeDecoration,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Yakında',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: SpaceTheme.iconContainerDecoration,
                        child: Icon(
                          icon,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: SpaceTheme.cardTitleStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: SpaceTheme.cardDescriptionStyle,
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