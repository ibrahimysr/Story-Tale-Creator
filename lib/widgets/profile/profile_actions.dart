import 'package:flutter/material.dart';
import '../../../core/theme/space_theme.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  const ProfileActions({
    super.key,
    required this.onEditProfile,
    required this.onSettings,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          'Profili Düzenle',
          Icons.edit,
          SpaceTheme.accentBlue,
          onEditProfile,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          'Ayarlar',
          Icons.settings,
          SpaceTheme.accentPurple,
          onSettings,
        ),
        const SizedBox(height: 10),
        _buildActionButton(
          'Yardım ve Destek',
          Icons.help_outline,
          SpaceTheme.accentEmerald,
          onHelp,
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onTap,
        style: SpaceTheme.getMagicalButtonStyle(color),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
} 