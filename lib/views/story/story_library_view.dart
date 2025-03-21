import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/story_library_viewmodel.dart';
import 'package:masal/viewmodels/story_display_viewmodel.dart'; 
import 'package:masal/widgets/story/story_library/empty_view.dart';
import 'package:masal/widgets/story/story_library/error_view.dart';
import 'package:masal/widgets/story/story_library/login_prompt.dart';
import 'package:masal/widgets/story/story_library/stories_list.dart';
import 'package:provider/provider.dart';

class StoryLibraryView extends StatelessWidget {
  const StoryLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isAuthenticated = currentUser != null;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryLibraryViewModel()),
        ChangeNotifierProvider(create: (_) => StoryDisplayViewModel()),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: SpaceTheme.primaryDark,
        appBar: _buildAppBar(context, isAuthenticated),
        body: Container(
          decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
          child: Stack(
            children: [
              const Positioned.fill(child: StarryBackground()),
              SafeArea(
                child: !isAuthenticated
                    ? const LoginPrompt()
                    : Consumer2<StoryLibraryViewModel, StoryDisplayViewModel>(
                        builder: (context, libraryViewModel, displayViewModel, _) {
                          if (libraryViewModel.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: SpaceTheme.accentPurple),
                            );
                          }
                          if (libraryViewModel.errorMessage != null) {
                            return ErrorView(viewModel: libraryViewModel);
                          }
                          if (!libraryViewModel.hasStories) {
                            return const EmptyView();
                          }
                          return StoriesList(
                            libraryViewModel: libraryViewModel,
                            displayViewModel: displayViewModel, 
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

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isAuthenticated) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Hikaye Kütüphanem',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      actions: [
        if (isAuthenticated)
          Consumer<StoryLibraryViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: SpaceTheme.iconContainerDecoration,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                onPressed: viewModel.loadStories,
              );
            },
          ),
        SizedBox(width: context.getDynamicWidth(1)),
      ],
    );
  }
}