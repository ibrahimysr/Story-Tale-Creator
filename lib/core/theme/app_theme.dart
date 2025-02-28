import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: 'Comic Sans MS',
      scaffoldBackgroundColor: Colors.purple[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple[700],
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white.withValues(alpha:0.9),
      ),
    );
  }
} 