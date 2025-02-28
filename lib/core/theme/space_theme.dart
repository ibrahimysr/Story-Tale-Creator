import 'package:flutter/material.dart';

class SpaceTheme {
  // Sihirli Renkler
  static const Color primaryDark = Color(0xFF1A0B2E); // Derin gece mavisi
  static const Color primaryLight = Color(0xFF2C1854); // Mistik mor
  static const Color accentPurple = Color(0xFF9C27B0); // Büyülü mor
  static const Color accentBlue = Color(0xFF0288D1); // Büyü mavisi
  static const Color accentGold = Color(0xFFFFD700); // Sihirli altın
  static const Color accentEmerald = Color(0xFF00BFA5); // Mistik zümrüt
  static const Color accentPink = Color(0xFFE91E63); // Büyülü pembe
  static const Color accentTurquoise = Color(0xFF00BCD4); // Mistik turkuaz

  // Büyülü Gradyanlar
  static LinearGradient get mainGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryDark,
          primaryLight,
        ],
        stops: [0.3, 1.0],
      );

  static LinearGradient getMagicalGradient(Color color) => LinearGradient(
        colors: [
          color,
          color.withValues(alpha:0.6),
          color.withValues(alpha:0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.2, 0.6, 1.0],
      );

  // Büyülü Gölgeler
  static List<BoxShadow> getMagicalGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha:0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha:0.2),
          blurRadius: 30,
          spreadRadius: -5,
        ),
        BoxShadow(
          color: color.withValues(alpha:0.1),
          blurRadius: 50,
          spreadRadius: 10,
        ),
      ];

  // Metin Stilleri
  static TextStyle get titleStyle => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: accentGold,
        shadows: [
          Shadow(
            color: accentGold.withValues(alpha:0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          Shadow(
            color: Colors.purple.withValues(alpha:0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static TextStyle get subtitleStyle => TextStyle(
        fontSize: 16,
        color: Colors.blue[100],
        shadows: [
          Shadow(
            color: Colors.blue.withValues(alpha:0.3),
            blurRadius: 5,
          ),
        ],
      );

  static TextStyle get cardTitleStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black54,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
          Shadow(
            color: Colors.purple,
            offset: Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      );

  static TextStyle get cardDescriptionStyle => TextStyle(
        fontSize: 16,
        color: Colors.white.withValues(alpha:0.9),
        shadows: [
          Shadow(
            color: Colors.purple.withValues(alpha:0.3),
            blurRadius: 5,
          ),
        ],
      );

  // Kart Dekorasyonları
  static BoxDecoration getCardDecoration(Color color) => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: getMagicalGradient(color),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.1),
          width: 0.5,
        ),
        boxShadow: getMagicalGlow(color),
      );

  // Avatar Dekorasyonu
  static BoxDecoration get avatarDecoration => BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            accentGold.withValues(alpha: 0.8),
            accentPurple.withValues(alpha:0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: getMagicalGlow(accentGold),
      );

  // "Yakında" Badge Dekorasyonu
  static BoxDecoration get comingSoonBadgeDecoration => BoxDecoration(
        color: Colors.black.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentGold.withValues(alpha:0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentGold.withValues(alpha:0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      );

  // İkon Container Dekorasyonu
  static BoxDecoration get iconContainerDecoration => BoxDecoration(
        color: Colors.black.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accentGold.withValues(alpha:0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentGold.withValues(alpha:0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      );

  // Yeni: Büyülü Buton Stili
  static ButtonStyle getMagicalButtonStyle(Color color) => ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: color.withValues(alpha:0.5),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withValues(alpha:0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withValues(alpha:0.1);
            }
            return null;
          },
        ),
      );
} 