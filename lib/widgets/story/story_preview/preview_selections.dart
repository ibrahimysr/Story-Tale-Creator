import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
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
              context.localizations.galacticPlace, viewModel.selectedPlace ??   context.localizations.notSelected),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              context.localizations.spaceHero, viewModel.selectedCharacter ??  context.localizations.notSelected),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
             context.localizations.timeDimension, viewModel.selectedTime ??  context.localizations.notSelected),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
              context.localizations.cosmicFeeling, viewModel.selectedEmotion ??  context.localizations.notSelected),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection(
               context.localizations.interstellarEvent, viewModel.selectedEvent ??  context.localizations.notSelected),
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
