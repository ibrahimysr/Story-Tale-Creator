import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/reset_password_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:masal/views/auth/login_view.dart'; // LoginView import et

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
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
                'Şifremi Unuttum',
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
          'Şifreni Yenile!',
          style: SpaceTheme.titleStyle.copyWith(
            fontSize: 28,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.getDynamicHeight(1)),
        Text(
          'E-posta adresini gir, uzay maceralarına geri dön!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
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
        labelText: 'E-posta Adresi',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintText: 'örneğin: uzayci@masal.com',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: SpaceTheme.accentPurple,
        ),
        filled: true,
        fillColor: SpaceTheme.primaryDark.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: SpaceTheme.accentPurple.withOpacity(0.5)),
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
            onPressed: () => viewModel.resetPassword(),
            style: ElevatedButton.styleFrom(
              backgroundColor: SpaceTheme.accentPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 5,
              shadowColor: SpaceTheme.accentPurple.withOpacity(0.5),
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
                  'Şifremi Sıfırla',
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