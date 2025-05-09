import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/views/story/story_creator_view.dart';
import 'package:masal/views/story/story_library_view.dart';
import 'package:masal/widgets/home/activity_card.dart';
import 'package:masal/widgets/home/recent_stories_list.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
            child: SafeArea(
              child: Stack(
                children: [
                  const Positioned.fill(child: StarryBackground()),
                  RefreshIndicator(
                    onRefresh: () => viewModel.loadRecentStories(),
                    color: SpaceTheme.accentPurple,
                    backgroundColor:
                        SpaceTheme.primaryDark.withValues(alpha: 0.8),
                    child: SingleChildScrollView(
                      padding: context.paddingLowVertical * 1.4,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: context.paddingLowHorizontal * 1.3,
                              child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      height: context.getDynamicHeight(15),
                                      width: context.getDynamicWidth(20),
                                      decoration: SpaceTheme.avatarDecoration,
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  Text(
                                    context.localizations.welcomeExplorer,
                                    style: SpaceTheme.titleStyle,
                                  ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  ActivityCard(
                                    title: context.localizations.magicStoryCreator,
                                    description:
                                      context.localizations.createYourUniverse,
                                    icon: Icons.auto_awesome_motion,
                                    color: SpaceTheme.accentPurple,
                                    onTap: () async {
                                     Navigator.push(context, MaterialPageRoute( builder: (context) => StoryCreatorView()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.getDynamicHeight(3)),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: context.lowValue * 1.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                       Text(
                                        context.localizations.myRecentStories,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: context.lowValue * 1.5),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const StoryLibraryView(),
                                              ),
                                            ).then((_) =>
                                                viewModel.loadRecentStories());
                                          },
                                          child: Text(
                                           context.localizations.seeAll,
                                            style: TextStyle(
                                              color: SpaceTheme.accentBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.getDynamicHeight(1)),
                                  SizedBox(
                                    height: context.getDynamicHeight(26),
                                    child: const RecentStoriesList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 
}
