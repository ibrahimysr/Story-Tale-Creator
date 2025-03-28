import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/views/support_view.dart';
import 'package:masal/widgets/profile/auth_required.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/space_theme.dart';
import '../../../core/theme/widgets/starry_background.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_stats.dart';
import '../../widgets/profile/profile_actions.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'edit_profile_view.dart'; 
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _checkingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }
  Widget _buildLanguageDropdown(BuildContext context) {
     final localizations = context.localizations;
    final localeProvider = context.localeProvider;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<Locale>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          labelText: localizations.language,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        dropdownColor: SpaceTheme.accentPurple.withOpacity(0.8),
        value: localeProvider.locale ?? const Locale('en'),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            localeProvider.setLocale(newLocale);
          }
        },
        items: [
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(
              localizations.english, 
              style: const TextStyle(color: Colors.white),
            ),
          ),
          DropdownMenuItem(
            value: const Locale('tr'),
            child: Text(
              localizations.turkish, 
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
        icon: Icon(
          Icons.language, 
          color: SpaceTheme.accentGold,
        ),
      ),
    );
  }
  Future<void> _checkAuthentication() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      try {
        await currentUser.reload();
        if (mounted) {
          setState(() {
            _isAuthenticated = true;
            _checkingAuth = false;
          });
          Provider.of<ProfileViewModel>(context, listen: false).loadUserProfile();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isAuthenticated = false;
            _checkingAuth = false;
          });
          await FirebaseAuth.instance.signOut(); 
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _checkingAuth = false;
        });
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
        });
      }
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
        final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
      child: Stack(
        children: [
          const StarryBackground(),
          SafeArea(
            child: _checkingAuth 
              ? const Center(
                  child: CircularProgressIndicator(
                    color: SpaceTheme.accentGold,
                  ),
                )
              : !_isAuthenticated
                ? buildAuthRequiredView(context)
                : Consumer<ProfileViewModel>(
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
                                  color: Colors.white.withValues(alpha:0.7),
                                ),
                              ),
                               SizedBox(height: context.getDynamicHeight(5)),
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
                        return  Center(
                          child: Text(
                            localizations.profileNotFound,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding:  context.paddingNormalHorizontal,
                          child: Column(
                            children: [
                              ProfileHeader(
                                name: profile.name,
                                username: profile.username,
                                avatar: profile.avatar,
                              ),
                               SizedBox(height: context.getDynamicHeight(2)),
                              ProfileStats(
                                stories: viewModel.totalStories,
                                totalLikes: viewModel.totalLikes,
                              ),
                               SizedBox(height: context.getDynamicHeight(3)),
                              ProfileActions(
                                onEditProfile: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditProfileView(),
                                    ),
                                  );
                                },
                                onHelp: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SupportView(),
                                    ),
                                  );
                                },
                              ),

                                                                            _buildLanguageDropdown(context),

                               SizedBox(height: context.getDynamicHeight(2)),
                              Container(
                                margin: context.paddingNormalHorizontal,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _signOut(context),
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: context.normalValue,
                                        vertical: context.normalValue,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha:0.05),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha:0.1),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: SpaceTheme.accentPurple.withValues(alpha:0.1),
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
                                                  color: SpaceTheme.accentPurple.withValues(alpha:0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.logout_rounded,
                                                  color: SpaceTheme.accentGold,
                                                  size: 24,
                                                ),
                                              ),
                                               SizedBox(width: context.getDynamicWidth(4)),
                                              Text(
                                                localizations.signOut,
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.9),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white.withValues(alpha:0.5),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                               SizedBox(height: context.getDynamicHeight(2)),
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


