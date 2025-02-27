import 'package:flutter/material.dart';
import '../../../core/theme/space_theme.dart';

class ProfileStats extends StatelessWidget {
  final int stories;
  final String missions;
  final int level;

  const ProfileStats({
    Key? key,
    required this.stories,
    required this.missions,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SpaceTheme.accentBlue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Uzay Yolculuğu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: SpaceTheme.accentGold,
              shadows: [
                Shadow(
                  color: SpaceTheme.accentGold.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Hikayeler',
                stories.toString(),
                SpaceTheme.accentPurple,
                Icons.auto_stories,
              ),
              _buildStatItem(
                'Görevler',
                missions,
                SpaceTheme.accentBlue,
                Icons.rocket_launch,
              ),
              _buildStatItem(
                'Seviye',
                level.toString(),
                SpaceTheme.accentEmerald,
                Icons.workspace_premium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color.withOpacity(0.8),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
} 