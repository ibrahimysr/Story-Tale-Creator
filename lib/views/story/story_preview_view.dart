import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/widgets/story/story_preview/cancel_dialog.dart';
import 'package:masal/widgets/story/story_preview/create_button.dart';
import 'package:masal/widgets/story/story_preview/preview_header.dart';
import 'package:masal/widgets/story/story_preview/preview_selections.dart';
import 'package:provider/provider.dart';

class StoryPreviewView extends StatelessWidget {
  const StoryPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<StoryViewModel>(),
      child: Consumer<StoryViewModel>(
        builder: (context, viewModel, child) {
          final homeViewModel = context.read<HomeViewModel>();
          
          return PopScope(
            canPop: !viewModel.isLoading,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (viewModel.isLoading) {
                final shouldCancel = await showCancelDialog(context, viewModel);
                if (shouldCancel == true && context.mounted) {
                  viewModel.cancelStoryGeneration();
                  Navigator.pop(context);
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
                      showCancelDialog(context, viewModel).then((shouldCancel) {
                        if (shouldCancel == true && context.mounted) {
                          viewModel.cancelStoryGeneration();
                          Navigator.pop(context);
                        }
                      });
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
                            const PreviewHeader(),
                            SizedBox(height: context.getDynamicHeight(3)),
                            PreviewSelections(viewModel: viewModel),
                            SizedBox(height: context.getDynamicHeight(3)),
                            CreateButton(
                              storyViewModel: viewModel,
                              homeViewModel: homeViewModel, 
                            ),
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
}