import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';

class PreviewSelections extends StatelessWidget {
  final StoryViewModel viewModel;

  const PreviewSelections({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SpaceTheme.primaryDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: SpaceTheme.accentPurple.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelection(
              'Galaktik Mekan', viewModel.selectedPlace ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              'Uzay Kahramanı', viewModel.selectedCharacter ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              'Zaman Boyutu', viewModel.selectedTime ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              'Kozmik Duygu', viewModel.selectedEmotion ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              'Yıldızlararası Olay', viewModel.selectedEvent ?? 'Seçilmedi'),
        ],
      ),
    );
  }

  Widget _buildSelection(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: SpaceTheme.accentGold,
              fontSize: 18,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
