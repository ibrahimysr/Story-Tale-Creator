import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:masal/views/story/story_creator_view.dart';
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
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                          
                          // Hikaye Yaratıcısı (Tam genişlikte tek kart)
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
                    
                    // Bilgilendirme Kategorisi
                    _buildCategory(
                      context: context,
                      title: 'Bilgilendirme',
                      icon: CupertinoIcons.info_circle_fill,
                      items: [
                        CategoryItem(
                          title: 'Galaktik Kelime Hazinesi',
                          description: 'Yeni kelimelerle zihin güçlerini geliştir!',
                          icon: CupertinoIcons.sparkles,
                          color: SpaceTheme.accentBlue,
                          isComingSoon: true,
                        ),
                        CategoryItem(
                          title: 'Uzay Ansiklopedisi',
                          description: 'Evren hakkında ilginç bilgiler öğren!',
                          icon: Icons.menu_book_rounded,
                          color: SpaceTheme.accentBlue.withGreen(180),
                          isComingSoon: true,
                        ),
                        CategoryItem(
                          title: 'Yıldız Rehberi',
                          description: 'Yıldızlar ve gezegenler hakkında her şey!',
                          icon: Icons.nightlight_round,
                          color: SpaceTheme.accentBlue.withRed(100),
                          isComingSoon: true,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Yarışmalar Kategorisi
                    _buildCategory(
                      context: context,
                      title: 'Yarışmalar',
                      icon: Icons.emoji_events_rounded,
                      items: [
                        CategoryItem(
                          title: 'Yıldızlararası Görevler',
                          description: 'Eğlenceli görevlerle galakside ilerle!',
                          icon: Icons.rocket_launch_rounded,
                          color: SpaceTheme.accentEmerald,
                          isComingSoon: true,
                        ),
                        CategoryItem(
                          title: 'Haftalık Turnuva',
                          description: 'Bu haftanın en iyi hikayecisi sen ol!',
                          icon: Icons.leaderboard_rounded,
                          color: SpaceTheme.accentEmerald.withBlue(100),
                          isComingSoon: true,
                        ),
                        CategoryItem(
                          title: 'Bilgi Yarışması',
                          description: 'Uzay bilginle herkesi geride bırak!',
                          icon: Icons.lightbulb,
                          color: SpaceTheme.accentEmerald.withRed(150),
                          isComingSoon: true,
                        ),
                      ],
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

  Widget _buildCategory({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<CategoryItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategori başlığı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Yatay kaydırılabilir kutular
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildCategoryCard(
                  title: items[index].title,
                  description: items[index].description,
                  icon: items[index].icon,
                  color: items[index].color,
                  isComingSoon: items[index].isComingSoon,
                  onTap: items[index].onTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isComingSoon = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 180,
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
                    width: 80,
                    height: 80,
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: SpaceTheme.comingSoonBadgeDecoration,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Yakında',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: SpaceTheme.iconContainerDecoration,
                        child: Icon(
                          icon,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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

class CategoryItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isComingSoon;
  final VoidCallback? onTap;

  CategoryItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isComingSoon = false,
    this.onTap,
  });
}