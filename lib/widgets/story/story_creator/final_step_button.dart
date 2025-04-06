import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/widgets/common/animated_scale_button.dart';

class FinalStepButton extends StatelessWidget {
  final StoryViewModel viewModel;

  const FinalStepButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onPressed: viewModel.selectedEvent != null && !viewModel.isLoading
          ? () {
              viewModel.generateStory(context).then((_) {
                if (viewModel.generatedStory != null && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryDisplayView(
                        story: viewModel.generatedStory!.content,
                        title: viewModel.generatedStory!.title,
                        image: viewModel.generatedStory!.image,
                      ),
                    ),
                  );
                }
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: viewModel.selectedEvent != null && !viewModel.isLoading
              ? SpaceTheme.accentPurple
              : SpaceTheme.accentPurple.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(30),
          boxShadow: viewModel.selectedEvent != null && !viewModel.isLoading
              ? [
                  BoxShadow(
                    color: SpaceTheme.accentPurple.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (viewModel.isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 24,
              ),
            const SizedBox(width: 8),
            Text(
              viewModel.isLoading ? context.localizations.creating: context.localizations.startAdventure,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}