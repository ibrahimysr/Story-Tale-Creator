import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/widgets/common/animated_scale_button.dart';

class CreatorBackButton extends StatelessWidget {
  final StoryViewModel viewModel;

  const CreatorBackButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onPressed: viewModel.currentStep > 1 ? () => viewModel.goToPreviousStep() : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.normalValue, vertical: context.lowValue),
        decoration: BoxDecoration(
          color: viewModel.currentStep > 1
              ? SpaceTheme.primaryDark.withValues(alpha: 0.6)
              : SpaceTheme.primaryDark.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: viewModel.currentStep > 1
                ? SpaceTheme.accentPurple.withValues(alpha: 0.6)
                : SpaceTheme.accentPurple.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: viewModel.currentStep > 1
              ? [
                  BoxShadow(
                    color: SpaceTheme.accentPurple.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: viewModel.currentStep > 1
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              size: 18,
            ),
            SizedBox(width: context.getDynamicWidth(1)),
            Text(
              'Önceki Adım',
              style: TextStyle(
                color: viewModel.currentStep > 1
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}