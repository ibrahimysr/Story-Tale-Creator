import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/story_viewmodel.dart';
import '../models/story_options_model.dart';
import '../../../widgets/common/selector_card.dart';
import '../../../widgets/common/animated_scale_button.dart';
import 'story_display_view.dart';

class StoryCreatorView extends StatelessWidget {
  const StoryCreatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hikaye Oluşturucu'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.blue[100]!],
          ),
        ),
        child: Consumer<StoryViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Hikayeni Oluştur',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SelectorCard(
                      title: 'Mekan seç',
                      description: 'Hikayenin geçeceği yeri seç',
                      icon: Icons.location_on,
                      color: Colors.green[400]!,
                      options: StoryOptionsModel.places,
                      selectedValue: viewModel.selectedPlace,
                      onChanged: (value) => viewModel.updateSelection(place: value),
                    ),
                    SelectorCard(
                      title: 'Karakter seç',
                      description: 'Ana karakteri seç',
                      icon: Icons.person,
                      color: Colors.blue[400]!,
                      options: StoryOptionsModel.characters,
                      selectedValue: viewModel.selectedCharacter,
                      onChanged: (value) => viewModel.updateSelection(character: value),
                    ),
                    SelectorCard(
                      title: 'Zaman seç',
                      description: 'Hikayenin zamanını seç',
                      icon: Icons.access_time,
                      color: Colors.orange[400]!,
                      options: StoryOptionsModel.times,
                      selectedValue: viewModel.selectedTime,
                      onChanged: (value) => viewModel.updateSelection(time: value),
                    ),
                    SelectorCard(
                      title: 'Duygu seç',
                      description: 'Hikayedeki ana duyguyu seç',
                      icon: Icons.emoji_emotions,
                      color: Colors.pink[400]!,
                      options: StoryOptionsModel.emotions,
                      selectedValue: viewModel.selectedEmotion,
                      onChanged: (value) => viewModel.updateSelection(emotion: value),
                    ),
                    SelectorCard(
                      title: 'Olay seç',
                      description: 'Hikayedeki ana olayı seç',
                      icon: Icons.event,
                      color: Colors.purple[400]!,
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
                                      story: viewModel.generatedStory!,
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
                                const Text(
                                  'Hikaye Oluşturuluyor...',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_stories,
                                    color: Colors.white, size: 30),
                                const SizedBox(width: 10),
                                const Text(
                                  'Hikayemi Oluştur',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
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
      ),
    );
  }
} 