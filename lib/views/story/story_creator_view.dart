import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
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
   
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.localizations.errorOccurred),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<StoryViewModel>().errorMessage = null;
              },
              child: Text(context.localizations.okButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: SpaceTheme.primaryDark,
      appBar: AppBar(
        leadingWidth: 70,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.localizations.galacticStoryCreator,
          style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
        ),
        leading: Consumer<StoryViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.currentStep > 1
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 24),
                    onPressed: () => viewModel.goToPreviousStep(),
                  )
                : const SizedBox.shrink();
          },
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
                  if (viewModel.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showErrorDialog(viewModel.errorMessage!);
                    });
                  }

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
                            context.localizations.loadingCategories,
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
                                if (viewModel.isLoading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: SpaceTheme.accentPurple,
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
