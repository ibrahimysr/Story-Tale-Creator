import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/story_viewmodel.dart';
import '../../widgets/common/selector_card.dart';
import '../../widgets/common/animated_scale_button.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import 'story_display_view.dart';

class StoryCreatorView extends StatefulWidget {
  const StoryCreatorView({super.key});

  @override
  State<StoryCreatorView> createState() => _StoryCreatorViewState();
}

class _StoryCreatorViewState extends State<StoryCreatorView> {
@override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) { 
        context.read<StoryViewModel>().resetSelections();
      }
    });
  }

  Widget _buildProgressBar(int currentStep) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index < currentStep 
                      ? SpaceTheme.accentPurple 
                      : SpaceTheme.accentPurple.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Adım $currentStep/5',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            title,
            style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(StoryViewModel viewModel, int currentStep) {
    bool canProceed = false;
    switch (currentStep) {
      case 1:
        canProceed = viewModel.selectedPlace != null;
        break;
      case 2:
        canProceed = viewModel.selectedCharacter != null;
        break;
      case 3:
        canProceed = viewModel.selectedTime != null;
        break;
      case 4:
        canProceed = viewModel.selectedEmotion != null;
        break;
      case 5:
        canProceed = viewModel.selectedEvent != null;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: AnimatedScaleButton(
        onPressed: !canProceed || (currentStep == 5 && viewModel.isLoading)
            ? null
            : () {
                if (currentStep == 5) {
                  viewModel.generateStory().then((_) {
                    if (viewModel.generatedStory != null && context.mounted) {
                      if (mounted) {  // mounted kontrolü eklendi
                      Navigator.push(
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
                    }
                  });
                } else {
                  viewModel.goToNextStep();
                }
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentStep == 5 && viewModel.isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(
                  currentStep == 5 ? Icons.rocket_launch : Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              const SizedBox(width: 8),
              Text(
                currentStep == 5 
                  ? (viewModel.isLoading ? 'Oluşturuluyor...' : 'Maceraya Başla')
                  : 'İlerle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, StoryViewModel viewModel) {
    int currentStep = viewModel.currentStep;
    
    switch (currentStep) {
      case 1:
        return Column(
          children: [
            _buildStepTitle(
              'Galaktik Mekan',
              'Hikayenin geçeceği yeri seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.rocket_launch,
              color: SpaceTheme.accentBlue,
              options: viewModel.places,
              selectedValue: viewModel.selectedPlace,
              onChanged: (value) => viewModel.updateSelection(place: value),
            ),
            _buildNextButton(viewModel, currentStep),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildStepTitle(
              'Uzay Kahramanı',
              'Ana karakterini seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.person_outline,
              color: SpaceTheme.accentPurple,
              options: viewModel.characters,
              selectedValue: viewModel.selectedCharacter,
              onChanged: (value) => viewModel.updateSelection(character: value),
            ),
            _buildNextButton(viewModel, currentStep),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildStepTitle(
              'Zaman Boyutu',
              'Hikayenin zamanını seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.access_time,
              color: SpaceTheme.accentEmerald,
              options: viewModel.times,
              selectedValue: viewModel.selectedTime,
              onChanged: (value) => viewModel.updateSelection(time: value),
            ),
            _buildNextButton(viewModel, currentStep),
          ],
        );
      case 4:
        return Column(
          children: [
            _buildStepTitle(
              'Kozmik Duygu',
              'Hikayedeki ana duyguyu seç',
            ),
            SelectorCard(
              title: '',
              description: '',
              icon: Icons.emoji_emotions,
              color: SpaceTheme.accentGold,
              options: viewModel.emotions,
              selectedValue: viewModel.selectedEmotion,
              onChanged: (value) => viewModel.updateSelection(emotion: value),
            ),
            _buildNextButton(viewModel, currentStep),
          ],
        );
      case 5:
        return Column(
          children: [
            _buildStepTitle(
              'Yıldızlararası Olay',
              'Hikayedeki ana olayı seç',
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
            _buildNextButton(viewModel, currentStep),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Galaktik Hikaye Yaratıcısı',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
        child: Stack(
          children: [
            const Positioned.fill(
              child: StarryBackground(),
            ),
            SafeArea(
              child: Consumer<StoryViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      _buildProgressBar(viewModel.currentStep),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildCurrentStep(context, viewModel),
                                if (viewModel.errorMessage != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 16.0),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha:0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red.withValues(alpha:0.3),
                                      ),
                                    ),
                                    child: Text(
                                      viewModel.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 