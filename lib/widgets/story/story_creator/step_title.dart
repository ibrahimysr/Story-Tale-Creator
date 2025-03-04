import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const StepTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingNormalVertical,
      child: Column(
        children: [
          Text(
            title,
            style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.getDynamicHeight(1)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}