import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/viewmodels/story_viewmodel.dart';
import 'package:masal/views/story/story_display_view.dart';
import 'package:masal/views/subscription/subscription_view.dart';
import 'package:masal/widgets/home/login_required_dialog.dart';

class CreateButton extends StatelessWidget {
  final StoryViewModel storyViewModel;
  final HomeViewModel homeViewModel;

  const CreateButton(
      {super.key, required this.storyViewModel, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return storyViewModel.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: SpaceTheme.accentPurple,
            ),
          )
        : ElevatedButton(
            onPressed: () async {
              final canAccess = await homeViewModel.canAccessStoryCreator();
              if (!context.mounted) return;

              if (canAccess) {
                await storyViewModel.generateStory(context).then((_) {
                  if (storyViewModel.generatedStory != null &&
                      context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryDisplayView(
                          story: storyViewModel.generatedStory!.content,
                          title: storyViewModel.generatedStory!.title,
                          image: storyViewModel.generatedStory!.image,
                        ),
                      ),
                    );
                  }
                });
              } else {
                if (FirebaseAuth.instance.currentUser != null) {
                  _showSubscriptionRequiredDialog(context);
                } else {
                  _showLoginRequiredDialog(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
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
                  context.localizations.createStoryButton,
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

  void _showSubscriptionRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: context.paddingLowVertical * 1.5,
          decoration: BoxDecoration(
            gradient: SpaceTheme.mainGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: SpaceTheme.accentPurple.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.localizations.dailyLimitReached,
                style: SpaceTheme.titleStyle.copyWith(
                  fontSize: 22,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.getDynamicHeight(2)),
              Padding(
                padding: context.paddingLowHorizontal * 1.3,
                child: Text(
                    context.localizations.dailyLimitMessage,style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.getDynamicHeight(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          SpaceTheme.primaryDark.withValues(alpha: 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.lowValue * 2,
                        vertical: context.lowValue,
                      ),
                    ),
                    child: Text(
                      context.localizations.okButton,
                      style: TextStyle(
                        color: SpaceTheme.accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PremiumPurchaseView()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpaceTheme.accentPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.lowValue * 2,
                        vertical: context.lowValue,
                      ),
                    ),
                    child:  Text(
                      context.localizations.subscribeButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LoginRequiredDialog(),
    );
  }
}
