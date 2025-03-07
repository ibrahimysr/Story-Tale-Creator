import 'package:flutter/material.dart';

import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/story_discover_viewmodel.dart';
import 'package:masal/widgets/story/story_discover/empty_view.dart';
import 'package:masal/widgets/story/story_discover/error_view.dart';
import 'package:masal/widgets/story/story_discover/search_bar.dart';
import 'package:masal/widgets/story/story_discover/stories_list.dart';
import 'package:provider/provider.dart';

class StoryDiscoverView extends StatelessWidget {
  const StoryDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryDiscoverViewModel(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: SpaceTheme.primaryDark,
        appBar: _buildAppBar(context),
        body: Container(
          decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
          child: Stack(
            children: [
              const Positioned.fill(child: StarryBackground()),
              SafeArea(
                child: Column(
                  children: [
                    DiscoverSearchBar(),
                    Expanded(
                      child: Consumer<StoryDiscoverViewModel>(
                        builder: (context, viewModel, _) {
                          if (viewModel.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: SpaceTheme.accentPurple),
                            );
                          }
                          if (viewModel.errorMessage != null) {
                            return ErrorView(viewModel: viewModel);
                          }
                          if (!viewModel.hasStories) {
                            return EmptyView(
                                isSearching: viewModel.isSearching);
                          }
                          return StoriesList(viewModel: viewModel);
                        },
                      ),
                    ),
                  ],
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
      centerTitle: true,
      title: Text(
        'Keşfet',
        style: SpaceTheme.titleStyle.copyWith(fontSize: 20),
      ),
      actions: [
        Consumer<StoryDiscoverViewModel>(
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
