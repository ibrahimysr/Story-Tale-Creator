import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';

class PreviewHeader extends StatelessWidget {
  const PreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.auto_awesome,
          size: 80,
          color: SpaceTheme.accentGold,
          shadows: [
            Shadow(color: SpaceTheme.accentPurple, blurRadius: 15),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          context.localizations.exploreSpaceAdventure,
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          context.localizations.readyToCreate,
          style: TextStyle(
            color: Colors.white.withValues(alpha:  0.8),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}