import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
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
          context,
          'Profili Düzenle',
          Icons.edit,
          SpaceTheme.accentBlue,
          onEditProfile,
        ),
     
         SizedBox(height: context.getDynamicHeight(2)),
        _buildActionButton(
          context,
          'Yardım ve Destek',
          Icons.help_outline,
          SpaceTheme.accentEmerald,
          onHelp,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin:  EdgeInsets.symmetric(vertical: 3),
      child: ElevatedButton(
        onPressed: onTap,
        style: SpaceTheme.getMagicalButtonStyle(color),
        child: Padding(
          padding: context.paddingLow*1.5,
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
               SizedBox(width: context.getDynamicWidth(3)),
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