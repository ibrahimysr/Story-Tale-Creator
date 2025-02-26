import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:masal/features/story/views/story_creator_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  // Çocukça ve eğlenceli ikonlar
  final List<IconData> bottomIcons = [
    Icons.home_filled, // Ana sayfa
    CupertinoIcons.star_fill, // Keşfet (yıldız yaptım, daha sevimli)
    CupertinoIcons.heart_fill, // Favoriler (kalp daha eğlenceli)
    Icons.person_rounded, // Profil
  ];

  // Her ikon için renkler (çocukların seveceği parlak tonlar)
  final List<Color> iconColors = [
    Colors.purple,
    Colors.yellow,
    Colors.red,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    pages = [
      const StoryCreatorView(),
      navBarPage(CupertinoIcons.star_fill, "Keşfet"),
      navBarPage(CupertinoIcons.heart_fill, "Favoriler"),
      navBarPage(Icons.person_rounded, "Profilim"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Bu satırı ekle
      backgroundColor: Colors.purple[50], // Hafif mor arka plan
      body: pages[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        
        
        itemCount: bottomIcons.length,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                width: isActive ? 45 : 40,
                height: isActive ? 45 : 40,
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
                            blurRadius: 10,
                            spreadRadius: 2,
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
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    ["Ana Sayfa", "Keşfet", "Favoriler", "Profilim"][index],
                    style: TextStyle(
                      fontSize: 12,
                      color: iconColors[index],
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
        backgroundColor: Colors.white,// Renksiz (beyaz) arka plan
        splashColor: Colors.white.withOpacity(0.3), // Mor splash efekti için
        splashRadius: 30,
        elevation: 0, // Gölgeyi kaldırdım, daha sade duruyor
        height: 100,
      ),
    );
  }

  Widget navBarPage(IconData iconName, String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.blue[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconName,
              size: 100,
              color: Colors.purple[700],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
                fontFamily: 'Comic Sans MS',
              ),
            ),
          ],
        ),
      ),
    );
  }
}