import 'package:flutter/material.dart';
import 'package:masal/views/auth/login_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/space_theme.dart';
import '../../../core/theme/widgets/starry_background.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_stats.dart';
import '../../widgets/profile/profile_actions.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çıkış yapılırken bir hata oluştu: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

                // Check for auth error specifically
                if (viewModel.error == "auth_required") {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 80,
                          color: SpaceTheme.accentGold,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Profil Sayfasını Görmek İçin Lütfen Giriş Yapınız',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to login page
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
                          },
                          style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentBlue),
                          child: const Text('Giriş Yap',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  );
                }

                // Other error handling
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
                          avatar: profile.avatar,
                        ),
                        const SizedBox(height: 30),
                        ProfileStats(
                          stories: viewModel.totalStories,
                          totalLikes: viewModel.totalLikes,
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
                          onSettings: () {},
                          onHelp: () {},
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _signOut(context),
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: SpaceTheme.accentPurple.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: SpaceTheme.accentPurple.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.logout_rounded,
                                            color: SpaceTheme.accentGold,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Çıkış Yap',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}