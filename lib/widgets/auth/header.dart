  import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';

Widget buildHeader(BuildContext context,IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                SpaceTheme.accentGold.withValues(alpha: 0.8),
                SpaceTheme.accentPurple.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentGold),
          ),
          child:  Icon(
          icon,
            size: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(height: context.getDynamicHeight(4)),
        Text(
    title,
          style: SpaceTheme.titleStyle,
        ),
      ],
    );
  }