import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/reset_password_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:masal/views/auth/login_view.dart'; 

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordResetViewModel(),
      child: Consumer<PasswordResetViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.shouldNavigateToLogin) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
              viewModel.resetNavigation(); 
            });
            return Container(); 
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: SpaceTheme.primaryDark,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                context.localizations.forgotPassword,
                style: SpaceTheme.titleStyle.copyWith(fontSize: 24),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeader(context),
                          SizedBox(height: context.getDynamicHeight(3)),
                          _buildEmailField(viewModel),
                          SizedBox(height: context.getDynamicHeight(3)),
                          _buildResetButton(viewModel),
                          if (viewModel.errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(top: context.lowValue),
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock_outline,
          size: 80,
          color: SpaceTheme.accentGold,
          shadows: [
            Shadow(color: SpaceTheme.accentPurple, blurRadius: 15),
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Text(
          context.localizations.resetPassword,
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          context.localizations.enterEmailAndReturnToSpace,
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.8),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(PasswordResetViewModel viewModel) {
    return TextField(
      controller: _emailController,
      onChanged: (value) => viewModel.updateEmail(value),
      decoration: InputDecoration(
        labelText: context.localizations.emailAddressLabel,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha:0.8)),
        hintText: 'örneğin: uzayci@masal.com',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: SpaceTheme.accentPurple,
        ),
        filled: true,
        fillColor: SpaceTheme.primaryDark.withValues(alpha:0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: SpaceTheme.accentPurple.withValues(alpha:0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: SpaceTheme.accentPurple, width: 2),
        ),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildResetButton(PasswordResetViewModel viewModel) {
    return viewModel.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: SpaceTheme.accentPurple,
            ),
          )
        : ElevatedButton(
            onPressed: () => viewModel.resetPassword(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 5,
              shadowColor: SpaceTheme.accentPurple.withValues(alpha:0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_open,
                  color: SpaceTheme.accentGold,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  context.localizations.resetPassword,
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}