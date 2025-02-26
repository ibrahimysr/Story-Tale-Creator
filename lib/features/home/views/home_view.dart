import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:masal/features/story/views/story_creator_view.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(
                child: StarryBackground(),
              ),
              Column(
                children: [
                  // Üst başlık kısmı
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Sihirli kristal top avatar
                        Container(
                          height: 50,
                          width: 50,
                          decoration: SpaceTheme.avatarDecoration,
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoş Geldin Kaşif!',
                              style: SpaceTheme.titleStyle,
                            ),
                            Text(
                              'Hangi maceraya atılmak istersin?',
                              style: SpaceTheme.subtitleStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ana içerik - Aktivite kartları
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Hikaye Oluşturma Kartı
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
                          const SizedBox(height: 16),

                          // Kelime Kartları
                          _buildActivityCard(
                            title: 'Galaktik Kelime Hazinesi',
                            description: 'Yeni kelimelerle zihin güçlerini geliştir!',
                            icon: CupertinoIcons.sparkles,
                            color: SpaceTheme.accentBlue,
                            isComingSoon: true,
                          ),
                          const SizedBox(height: 16),

                          // Mini Testler
                          _buildActivityCard(
                            title: 'Yıldızlararası Görevler',
                            description: 'Eğlenceli görevlerle galakside ilerle!',
                            icon: Icons.rocket_launch_rounded,
                            color: SpaceTheme.accentPink,
                            isComingSoon: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    return Container(
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