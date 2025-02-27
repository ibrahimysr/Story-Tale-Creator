import 'package:flutter/material.dart';
import '../../core/theme/space_theme.dart';

class HabitHeader extends StatelessWidget {
  const HabitHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Galaktik Alışkanlıklar',
            style: SpaceTheme.titleStyle.copyWith(
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yıldızlara ulaşmak için her gün bir adım',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 