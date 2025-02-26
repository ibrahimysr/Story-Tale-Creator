import 'package:flutter/material.dart';

class SpaceTheme {
  // Ana Renkler
  static const Color primaryDark = Color(0xFF1a237e); // Koyu lacivert
  static const Color primaryLight = Color(0xFF311b92); // Koyu mor
  static const Color accentPurple = Color(0xFF7c4dff);
  static const Color accentBlue = Color(0xFF00b0ff);
  static const Color accentPink = Color(0xFFff4081);
  static const Color accentTurquoise = Color(0xFF64ffda);

  // Gradient Arkaplanlar
  static LinearGradient get mainGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryDark, primaryLight],
      );

  static LinearGradient getGlowGradient(Color color) => LinearGradient(
        colors: [color, color.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Gölge Efektleri
  static List<BoxShadow> getGlowingShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 15,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: -5,
        ),
      ];

  // Text Stilleri
  static TextStyle get titleStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.amber[100],
        shadows: [
          Shadow(
            color: Colors.purple[300]!,
            blurRadius: 5,
          ),
        ],
      );

  static TextStyle get subtitleStyle => TextStyle(
        fontSize: 16,
        color: Colors.blue[100],
      );

  static TextStyle get cardTitleStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      );

  static TextStyle get cardDescriptionStyle => TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.9),
      );

  // Kart Dekorasyonu
  static BoxDecoration getCardDecoration(Color color) => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: getGlowGradient(color),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      );

  // Avatar Dekorasyonu
  static BoxDecoration get avatarDecoration => BoxDecoration(
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
      );

  // "Yakında" Badge Dekorasyonu
  static BoxDecoration get comingSoonBadgeDecoration => BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      );

  // İkon Container Dekorasyonu
  static BoxDecoration get iconContainerDecoration => BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      );
} 