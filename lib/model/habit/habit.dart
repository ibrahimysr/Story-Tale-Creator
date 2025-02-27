import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int xpReward;
  final int targetPerDay;
  int currentProgress;
  
  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.xpReward,
    required this.targetPerDay,
    required this.currentProgress,
  });
} 