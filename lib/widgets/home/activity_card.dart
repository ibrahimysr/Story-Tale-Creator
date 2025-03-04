import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isComingSoon;
  final VoidCallback? onTap;
  
  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isComingSoon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getDynamicHeight(26),
      width: double.infinity,
      child: Card(
        elevation: 8,
        shadowColor: color.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: isComingSoon ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: SpaceTheme.getCardDecoration(color),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: context.getDynamicWidth(15),
                    height: context.getDynamicHeight(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isComingSoon)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: SpaceTheme.comingSoonBadgeDecoration,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: context.getDynamicWidth(1)),
                          Text(
                            'Yakında',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: context.paddingNormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: context.paddingLow,
                        decoration: SpaceTheme.iconContainerDecoration,
                        child: Icon(
                          icon,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: context.getDynamicHeight(1)),
                      Text(
                        title,
                        style: SpaceTheme.cardTitleStyle,
                      ),
                      SizedBox(height: context.getDynamicHeight(0.5)),
                      Text(
                        description,
                        style: SpaceTheme.cardDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}