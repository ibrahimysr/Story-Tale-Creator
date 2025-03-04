import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import '../../../core/theme/space_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String avatar;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(height: context.getDynamicHeight(2)),
        Container(
          decoration: SpaceTheme.avatarDecoration,
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/avatar/$avatar'),
          ),
        ),
         SizedBox(height: context.getDynamicHeight(2)),
        Text(
          name,
          style: SpaceTheme.titleStyle,
        ),
         SizedBox(height: context.getDynamicHeight(0.5)),
        Text(
          '@$username',
          style: SpaceTheme.subtitleStyle,
        ),
      ],
    );
  }
} 