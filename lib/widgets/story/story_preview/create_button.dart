import 'package:flutter/material.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';

class CreateButton extends StatelessWidget {
  final StoryViewModel viewModel;

  const CreateButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return viewModel.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: SpaceTheme.accentPurple,
            ),
          )
        : ElevatedButton(
            onPressed: () async {
              await viewModel.generateStory().then((_) {
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 5,
              shadowColor: SpaceTheme.accentPurple.withValues(alpha:  0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.rocket_launch,
                  color: SpaceTheme.accentGold,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Hikayemi Oluştur!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }
}