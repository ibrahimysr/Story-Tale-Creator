import 'package:flutter/material.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';

Future<bool?> showCancelDialog(BuildContext context, StoryViewModel viewModel) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: SpaceTheme.primaryDark,
      title: Text(
        'İptal Etmek İstiyor musunuz?',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      content: Text(
        'Hikaye oluşturma işlemi devam ediyor. İptal etmek istediğinize emin misiniz?',
        style: TextStyle(color: Colors.white.withValues(alpha:  0.8)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Hayır',
            style: TextStyle(color: SpaceTheme.accentGold),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            'Evet',
            style: TextStyle(color: SpaceTheme.accentPurple),
          ),
        ),
      ],
    ),
  );
}