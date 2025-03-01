import 'package:flutter/material.dart';
import 'package:masal/views/auth/login_view.dart';
import 'package:provider/provider.dart';
import 'package:masal/views/story/story_creator_view.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/views/story/story_library_view.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/home/home_story_item.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Cihaz ID'si için
import 'package:shared_preferences/shared_preferences.dart'; // Locale kayıt için
import 'package:firebase_auth/firebase_auth.dart'; // Firebase auth kontrolü için

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
                    backgroundColor: SpaceTheme.primaryDark.withValues(alpha:0.8),
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
                                  
                                  _buildActivityCard(
                                    title: 'Sihirli Hikaye Yaratıcısı',
                                    description: 'Hayal gücünün sınırlarını zorla ve kendi evrenini yarat!',
                                    icon: Icons.auto_awesome_motion,
                                    color: SpaceTheme.accentPurple,
                                    onTap: () async {
                                      await _handleStoryCreatorTap(context);
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

  Future<void> _handleStoryCreatorTap(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      _navigateToStoryCreator(context);
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final hasUsedFreeAccess = prefs.getBool('has_used_free_access') ?? false;
    
    if (hasUsedFreeAccess) {
      _showLoginRequiredDialog(context);
    } else {
      
    final deviceId = await _getDeviceId(context);
      
      await prefs.setBool('has_used_free_access', true);
      await prefs.setString('device_id', deviceId);
      
      _navigateToStoryCreator(context);
    }
  }
  
 Future<String> _getDeviceId(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  
  if (Theme.of(context).platform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'unknown';
  }
  
  return 'unknown';
}

  // Hikaye oluşturucuya yönlendirme
  void _navigateToStoryCreator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryCreatorView(),
      ),
    );
  }
  
  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SpaceTheme.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Giriş Yapmanız Gerekiyor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Hikaye oluşturma özelliğini kullanmak için lütfen giriş yapın veya kayıt olun.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'İptal',
                style: TextStyle(color: SpaceTheme.accentBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
               
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SpaceTheme.accentPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentStoriesList() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        // İlk yükleme sırasında tam ekran loading göster
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
        shadowColor: color.withValues(alpha:0.4),
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
                          Colors.white.withValues(alpha:0.2),
                          Colors.white.withValues(alpha:0),
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
                              color: Colors.white.withValues(alpha:0.9),
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