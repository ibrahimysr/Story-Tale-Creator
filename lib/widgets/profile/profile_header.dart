import 'package:flutter/material.dart';
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
        const SizedBox(height: 20),
        Container(
          decoration: SpaceTheme.avatarDecoration,
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/avatar/$avatar'),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: SpaceTheme.titleStyle,
        ),
        const SizedBox(height: 5),
        Text(
          '@$username',
          style: SpaceTheme.subtitleStyle,
        ),
      ],
    );
  }
} 