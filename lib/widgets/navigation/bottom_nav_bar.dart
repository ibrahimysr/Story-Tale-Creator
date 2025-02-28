import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:masal/views/profile/profile_views.dart';
import 'package:masal/views/home/home_view.dart';
import 'package:masal/views/story/story_discover_view.dart';
import 'package:masal/views/story/story_library_view.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  // Uzay teması için ikonlar
  final List<IconData> bottomIcons = [
    Icons.rocket_launch, // Ana sayfa
    Icons.auto_awesome, // Keşfet
    Icons.favorite, // Favoriler
    Icons.person_outline, // Profil
  ];

  // Uzay teması için renkler
  final List<Color> iconColors = [
    const Color(0xFF7c4dff), // Mor
    const Color(0xFF00b0ff), // Mavi
    const Color(0xFFff4081), // Pembe
    const Color(0xFF64ffda), // Turkuaz
  ];

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeView(),
      StoryDiscoverView(),
      StoryLibraryView(),
       ProfileView()
    ];
  }

  Widget navBarPage(IconData icon, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.white.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: SpaceTheme.primaryDark,
      body: Stack(
        children: [
          const Positioned.fill(
            child: StarryBackground(),
          ),
          pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              SpaceTheme.primaryDark.withOpacity(0.5),
              SpaceTheme.primaryDark,
            ],
          ),
        ),
        child: AnimatedBottomNavigationBar.builder(
          itemCount: bottomIcons.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  width: isActive ? 50 : 40,
                  height: isActive ? 50 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        iconColors[index],
                        iconColors[index].withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: iconColors[index].withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: -5,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    bottomIcons[index],
                    size: isActive ? 30 : 25,
                    color: Colors.white,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      ["Görev Merkezi", "Uzayı Keşfet", "Koleksiyonum", "Kaşif"][index],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
          activeIndex: _currentIndex,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.1),
          splashRadius: 30,
          elevation: 0,
          height: 100,
        ),
      ),
    );
  }
}