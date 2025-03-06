import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:provider/provider.dart';

class StoryPreviewView extends StatelessWidget {
  const StoryPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<StoryViewModel>(),
      child: Consumer<StoryViewModel>(
        builder: (context, viewModel, child) {
          return PopScope(
            canPop: !viewModel.isLoading,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return; 
              if (viewModel.isLoading) {
                final shouldCancel = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    backgroundColor: SpaceTheme.primaryDark,
                    title: Text(
                      'İptal Etmek İstiyor musunuz?',
                      style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
                    ),
                    content: Text(
                      'Hikaye oluşturma işlemi devam ediyor. İptal etmek istediğinize emin misiniz?',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Hayır',
                          style: TextStyle(color: SpaceTheme.accentGold),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Evet',
                          style: TextStyle(color: SpaceTheme.accentPurple),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldCancel == true) {
                  viewModel.cancelStoryGeneration();
                  if (context.mounted) {
                    Navigator.pop(context); 
                  }
                }
              }
            },
            child: Scaffold(
              extendBody: true,
              backgroundColor: SpaceTheme.primaryDark,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Hikayeni Önizle',
                  style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (!viewModel.isLoading) {
                      Navigator.pop(context);
                    } else {
                      _showCancelDialog(context, viewModel);
                    }
                  },
                ),
              ),
              body: Container(
                decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
                child: Stack(
                  children: [
                    const Positioned.fill(child: StarryBackground()),
                    SafeArea(
                      child: Padding(
                        padding: context.paddingNormal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: context.getDynamicHeight(3)),
                            _buildPreviewHeader(context),
                            SizedBox(height: context.getDynamicHeight(3)),
                            _buildSelections(viewModel, context),
                            SizedBox(height: context.getDynamicHeight(3)),
                            _buildCreateButton(viewModel, context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Future<void> _showCancelDialog(BuildContext context, StoryViewModel viewModel) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: SpaceTheme.primaryDark,
        title: Text(
          'İptal Etmek İstiyor musunuz?',
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
        content: Text(
          'Hikaye oluşturma işlemi devam ediyor. İptal etmek istediğinize emin misiniz?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Hayır',
              style: TextStyle(color: SpaceTheme.accentGold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Evet',
              style: TextStyle(color: SpaceTheme.accentPurple),
            ),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      viewModel.cancelStoryGeneration();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildPreviewHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.auto_awesome,
          size: 80,
          color: SpaceTheme.accentGold,
          shadows: [
            Shadow(color: SpaceTheme.accentPurple, blurRadius: 15),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          'Uzay Maceranı Keşfet!',
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          'Seçtiklerinle galaktik bir hikaye oluşturmaya hazır mısın?',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelections(StoryViewModel viewModel, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SpaceTheme.primaryDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SpaceTheme.accentPurple.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelection('Galaktik Mekan', viewModel.selectedPlace ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection('Uzay Kahramanı', viewModel.selectedCharacter ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection('Zaman Boyutu', viewModel.selectedTime ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection('Kozmik Duygu', viewModel.selectedEmotion ?? 'Seçilmedi'),
          SizedBox(height: context.getDynamicHeight(1)),
          _buildSelection('Yıldızlararası Olay', viewModel.selectedEvent ?? 'Seçilmedi'),
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

  Widget _buildCreateButton(StoryViewModel viewModel, BuildContext context) {
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
              shadowColor: SpaceTheme.accentPurple.withValues(alpha: 0.5),
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
                Text(
                  'Hikayemi Oluştur!',
                  style: const TextStyle(
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