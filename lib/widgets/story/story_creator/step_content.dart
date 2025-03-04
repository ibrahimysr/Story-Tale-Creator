import 'package:flutter/material.dart';

import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/widgets/common/selector_card.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/widgets/story/story_creator/final_step_button.dart';
import 'package:masal/widgets/story/story_creator/step_title.dart';

class StepContent extends StatelessWidget {
  final StoryViewModel viewModel;

  const StepContent({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    int currentStep = viewModel.currentStep;

    switch (currentStep) {
      case 1:
        return Column(
          children: [
            const StepTitle(
              title: 'Galaktik Mekan',
              subtitle: 'Hikayenin geçeceği yeri seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.rocket_launch,
              color: SpaceTheme.accentBlue,
              options: viewModel.places,
              selectedValue: viewModel.selectedPlace,
              onChanged: (value) {
                viewModel.updateSelection(place: value);
                Future.delayed(const Duration(milliseconds: 300), () {
                  viewModel.goToNextStep();
                });
              },
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            const StepTitle(
              title: 'Uzay Kahramanı',
              subtitle: 'Ana karakterini seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.person_outline,
              color: SpaceTheme.accentPurple,
              options: viewModel.characters,
              selectedValue: viewModel.selectedCharacter,
              onChanged: (value) {
                viewModel.updateSelection(character: value);
                Future.delayed(const Duration(milliseconds: 300), () {
                  viewModel.goToNextStep();
                });
              },
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            const StepTitle(
              title: 'Zaman Boyutu',
              subtitle: 'Hikayenin zamanını seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.access_time,
              color: SpaceTheme.accentEmerald,
              options: viewModel.times,
              selectedValue: viewModel.selectedTime,
              onChanged: (value) {
                viewModel.updateSelection(time: value);
                Future.delayed(const Duration(milliseconds: 300), () {
                  viewModel.goToNextStep();
                });
              },
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            const StepTitle(
              title: 'Kozmik Duygu',
              subtitle: 'Hikayedeki ana duyguyu seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.emoji_emotions,
              color: SpaceTheme.accentGold,
              options: viewModel.emotions,
              selectedValue: viewModel.selectedEmotion,
              onChanged: (value) {
                viewModel.updateSelection(emotion: value);
                Future.delayed(const Duration(milliseconds: 300), () {
                  viewModel.goToNextStep();
                });
              },
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            const StepTitle(
              title: 'Yıldızlararası Olay',
              subtitle: 'Hikayedeki ana olayı seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.auto_awesome,
              color: SpaceTheme.accentPurple,
              options: viewModel.events,
              selectedValue: viewModel.selectedEvent,
              onChanged: (value) => viewModel.updateSelection(event: value),
            ),
            const SizedBox(height: 20),
            FinalStepButton(viewModel: viewModel),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}