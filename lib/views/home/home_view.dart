import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/views/story/story_creator_view.dart';
import 'package:masal/views/story/story_library_view.dart';
import 'package:masal/widgets/home/activity_card.dart';
import 'package:masal/widgets/home/login_required_dialog.dart';
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
                    backgroundColor: SpaceTheme.primaryDark.withValues(alpha: 0.8),
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
                                    'Hoş Geldin Kaşif!',
                                    style: SpaceTheme.titleStyle,
                                  ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  ActivityCard(
                                    title: 'Sihirli Hikaye Yaratıcısı',
                                    description:
                                        'Hayal gücünün sınırlarını zorla ve kendi evrenini yarat!',
                                    icon: Icons.auto_awesome_motion,
                                    color: SpaceTheme.accentPurple,
                                    onTap: () async {
                                      await _handleStoryCreatorTap(context, viewModel);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.getDynamicHeight(3)),
                            Padding(
                              padding: EdgeInsets.only(left: context.lowValue * 1.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Son Hikayelerim',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: context.lowValue * 1.5),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const StoryLibraryView(),
                                              ),
                                            ).then((_) => viewModel.loadRecentStories());
                                          },
                                          child: Text(
                                            'Tümünü Gör',
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

Future<void> _handleStoryCreatorTap(BuildContext context, HomeViewModel viewModel) async {
  final canAccess = await viewModel.canAccessStoryCreator();
   if (!context.mounted) return;
  if (canAccess) {
    _navigateToStoryCreator(context);
  } else {
    if (FirebaseAuth.instance.currentUser != null) {
      _showSubscriptionRequiredDialog(context);
    } else {
      _showLoginRequiredDialog(context);
    }
  }
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
              color: SpaceTheme.accentPurple.withValues(alpha:  0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Başlık
            Text(
              'Günlük Limit Aşıldı',
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
                'Günlük 2 hikaye oluşturma limitine ulaştınız. Daha fazla hikaye oluşturmak için lütfen abone olunuz.',
                style: TextStyle(
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
                    backgroundColor: SpaceTheme.primaryDark.withValues(alpha:  0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.lowValue * 2,
                      vertical: context.lowValue,
                    ),
                  ),
                  child: Text(
                    'Tamam',
                    style: TextStyle(
                      color: SpaceTheme.accentBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Abonelik sayfasına yönlendirme 
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionView()));
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
                  child: const Text(
                    'Abone Ol',
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

  void _navigateToStoryCreator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryCreatorView(),
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