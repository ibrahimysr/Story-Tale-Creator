import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/widgets/story/story_creator/back_button.dart';
import 'package:masal/widgets/story/story_creator/progress_bar.dart';
import 'package:masal/widgets/story/story_creator/step_content.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        centerTitle: true,
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
            const Positioned.fill(child: StarryBackground()),
            SafeArea(
              child: Consumer<StoryViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoadingCategories) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: SpaceTheme.accentPurple,
                          ),
                          SizedBox(height: context.getDynamicHeight(2)),
                          Text(
                            'Kategoriler yükleniyor...',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      ProgressBar(currentStep: viewModel.currentStep),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                StepContent(viewModel: viewModel),
                                SizedBox(height: context.getDynamicHeight(2)),
                                if (viewModel.currentStep > 1)
                                  Center(child: CreatorBackButton(viewModel: viewModel)),
                                SizedBox(height: context.getDynamicHeight(2)),
                                if (viewModel.errorMessage != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 16.0),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.red.withValues(alpha: 0.3),
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