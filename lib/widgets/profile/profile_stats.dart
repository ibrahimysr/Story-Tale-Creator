import 'package:flutter/material.dart';
import '../../../core/theme/space_theme.dart';

class ProfileStats extends StatelessWidget {
  final int stories;
  final int totalLikes;

  const ProfileStats({
    super.key,
    required this.stories,
    required this.totalLikes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: SpaceTheme.accentBlue.withValues(alpha:0.1),
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
                  color: SpaceTheme.accentGold.withValues(alpha:0.3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Hikayeler',
                stories.toString(),
                SpaceTheme.accentPurple,
                Icons.auto_stories,
              ),
              _buildStatItem(
                'Beğeniler',
                totalLikes.toString(),
                Colors.red[300] ?? Colors.red,
                Icons.favorite,
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
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha:0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color.withValues(alpha:0.8),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha:0.9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha:0.7),
          ),
        ),
      ],
    );
  }
} 