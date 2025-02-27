import 'package:flutter/material.dart';
import '../../../core/theme/space_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          decoration: SpaceTheme.avatarDecoration,
          padding: const EdgeInsets.all(20),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
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