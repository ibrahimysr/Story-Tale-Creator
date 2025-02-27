import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/story_viewmodel.dart';
import '../models/story_options_model.dart';
import '../../../widgets/common/selector_card.dart';
import '../../../widgets/common/animated_scale_button.dart';
import '../../../core/theme/space_theme.dart';
import '../../../core/theme/widgets/starry_background.dart';
import 'story_display_view.dart';

class StoryCreatorView extends StatelessWidget {
  const StoryCreatorView({Key? key}) : super(key: key);

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
            Consumer<StoryViewModel>(
              builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: SpaceTheme.getCardDecoration(
                              SpaceTheme.accentPurple,
                            ),
                            child: Text(
                              'Kendi Evrenini Yarat',
                              style: SpaceTheme.titleStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SelectorCard(
                          title: 'Galaktik Mekan',
                          description: 'Hikayenin geçeceği gezegeni seç',
                          icon: Icons.rocket_launch,
                          color: SpaceTheme.accentBlue,
                          options: StoryOptionsModel.places,
                          selectedValue: viewModel.selectedPlace,
                          onChanged: (value) => viewModel.updateSelection(place: value),
                        ),
                        SelectorCard(
                          title: 'Uzay Kahramanı',
                          description: 'Ana karakterini seç',
                          icon: Icons.person_outline,
                          color: SpaceTheme.accentPurple,
                          options: StoryOptionsModel.characters,
                          selectedValue: viewModel.selectedCharacter,
                          onChanged: (value) => viewModel.updateSelection(character: value),
                        ),
                        SelectorCard(
                          title: 'Zaman Boyutu',
                          description: 'Hikayenin zamanını seç',
                          icon: Icons.access_time,
                          color: SpaceTheme.accentEmerald,
                          options: StoryOptionsModel.times,
                          selectedValue: viewModel.selectedTime,
                          onChanged: (value) => viewModel.updateSelection(time: value),
                        ),
                        SelectorCard(
                          title: 'Kozmik Duygu',
                          description: 'Hikayedeki ana duyguyu seç',
                          icon: Icons.emoji_emotions,
                          color: SpaceTheme.accentGold,
                          options: StoryOptionsModel.emotions,
                          selectedValue: viewModel.selectedEmotion,
                          onChanged: (value) => viewModel.updateSelection(emotion: value),
                        ),
                        SelectorCard(
                          title: 'Yıldızlararası Olay',
                          description: 'Hikayedeki ana olayı seç',
                          icon: Icons.auto_awesome,
                          color: SpaceTheme.accentPurple,
                          options: StoryOptionsModel.events,
                          selectedValue: viewModel.selectedEvent,
                          onChanged: (value) => viewModel.updateSelection(event: value),
                        ),
                        const SizedBox(height: 30),
                        AnimatedScaleButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  await viewModel.generateStory();
                                  if (viewModel.generatedStory != null && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StoryDisplayView(
                                          story: viewModel.generatedStory!.content,
                                          image: viewModel.generatedStory!.image,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: viewModel.isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Galakside Yolculuk Başlıyor...',
                                      style: SpaceTheme.cardTitleStyle.copyWith(fontSize: 20),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.rocket_launch,
                                        color: Colors.white, size: 30),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Maceraya Başla',
                                      style: SpaceTheme.cardTitleStyle.copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                        ),
                        if (viewModel.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16.0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 