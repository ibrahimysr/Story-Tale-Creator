import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/space_theme.dart';
import '../../../core/theme/widgets/starry_background.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_stats.dart';
import '../../widgets/profile/profile_actions.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
        child: Stack(
          children: [
            const StarryBackground(),
            SafeArea(
              child: Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: SpaceTheme.accentGold,
                      ),
                    );
                  }

                  if (viewModel.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bir hata oluştu',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.error!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.loadUserProfile(),
                            style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentBlue),
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    );
                  }

                  final profile = viewModel.userProfile;
                  if (profile == null) {
                    return const Center(
                      child: Text(
                        'Profil bulunamadı',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          ProfileHeader(
                            name: profile.name,
                            username: profile.username,
                          ),
                          const SizedBox(height: 30),
                          ProfileStats(
                            stories: profile.stories,
                            missions: profile.missions,
                            level: profile.level,
                          ),
                          const SizedBox(height: 30),
                          ProfileActions(
                            onEditProfile: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfileView(),
                                ),
                              );
                            },
                            onSettings: () {
                              // TODO: Ayarlar sayfasına yönlendir
                            },
                            onHelp: () {
                              // TODO: Yardım sayfasına yönlendir
                            },
                          ),
                        ],
                      ),
                    ),
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