import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:masal/features/story/views/story_creator_view.dart';
import 'package:masal/features/home/views/home_view.dart';

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
      navBarPage(Icons.auto_awesome, "Galaktik Keşif"),
      navBarPage(Icons.favorite, "Yıldız Koleksiyonum"),
      navBarPage(Icons.person_outline, "Uzay Kaşifi"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF1a237e),
      body: pages[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
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
                    ["Görev Merkezi", "Galaktik Keşif", "Koleksiyonum", "Kaşif"][index],
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
        backgroundColor: Colors.black.withOpacity(0.8),
        splashColor: Colors.white.withOpacity(0.1),
        splashRadius: 30,
        elevation: 0,
        height: 100,
      ),
    );
  }

  Widget navBarPage(IconData iconName, String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1a237e),
            const Color(0xFF311b92),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[400]!,
                    Colors.blue[400]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple[200]!.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                iconName,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.purple[300]!,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}