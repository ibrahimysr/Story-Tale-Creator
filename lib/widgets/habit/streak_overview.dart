import 'package:flutter/material.dart';
import '../../core/theme/space_theme.dart';

class StreakOverview extends StatelessWidget {
  final int longestStreak;
  final int totalHabits;
  final String todayProgress;

  const StreakOverview({
    super.key,
    required this.longestStreak,
    required this.totalHabits,
    required this.todayProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SpaceTheme.accentGold.withOpacity(0.3),
            SpaceTheme.accentPurple.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStreakStat('En Uzun Seri', '$longestStreak Gün', Icons.local_fire_department),
          _buildStreakStat('Toplam Alışkanlık', '$totalHabits', Icons.auto_awesome),
          _buildStreakStat('Bugünkü İlerleme', todayProgress, Icons.track_changes),
        ],
      ),
    );
  }

  Widget _buildStreakStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SpaceTheme.accentGold.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: SpaceTheme.accentGold,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 