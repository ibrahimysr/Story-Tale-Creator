import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../model/story/story_display_model.dart';
import '../../viewmodels/story_display_viewmodel.dart';
import '../../widgets/story/story_display_content.dart';

class StoryDisplayView extends StatelessWidget {
  final String story;
  final String title;
  final Uint8List? image;
  final bool showSaveButton;

  const StoryDisplayView({
    super.key,
    required this.story,
    required this.title,
    this.image,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryDisplayViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: SpaceTheme.primaryDark,
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: SpaceTheme.mainGradient,
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: StarryBackground(),
              ),
              SafeArea(
                child: Consumer<StoryDisplayViewModel>(
                  builder: (context, viewModel, _) {
                    return StoryDisplayContent(
                      story: story,
                      title: title,
                      image: image,
                      onSave: () => _saveStory(context, viewModel),
                      isLoading: viewModel.isLoading,
                      showSaveButton: showSaveButton,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Uzayın Derinliklerinden',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      actions: [
        if (showSaveButton)
          Consumer<StoryDisplayViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: SpaceTheme.iconContainerDecoration,
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                ),
                onPressed: viewModel.isLoading
                    ? null
                    : () => _saveStory(context, viewModel),
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _saveStory(
      BuildContext context, StoryDisplayViewModel viewModel) async {
    try {
      final storyModel = StoryDisplayModel(
        story: story,
        title: title,
        image: image,
      );

      await viewModel.saveStory(storyModel);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Hikaye kütüphanenize kaydedildi! ✨',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: SpaceTheme.accentPurple.withOpacity(0.8),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Bir hata oluştu: ${e.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }
}