import 'package:flutter/material.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../widgets/auth/space_text_field.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/login_viewmodel.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
          child: Stack(
            children: [
              const StarryBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildLoginForm(),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                SpaceTheme.accentGold.withValues(alpha:0.8),
                SpaceTheme.accentPurple.withValues(alpha:0.8),
              ],
            ),
            boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentGold),
          ),
          child: const Icon(
            Icons.rocket_launch,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Galaktik Giriş',
          style: SpaceTheme.titleStyle,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha:0.2),
                width: 1,
              ),
              boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentPurple),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SpaceTextField(
                    controller: _emailController,
                    label: 'Galaktik E-posta',
                    icon: Icons.email_outlined,
                    onChanged: viewModel.setEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen e-posta adresinizi girin';
                      }
                      if (!value.contains('@')) {
                        return 'Geçerli bir e-posta adresi girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SpaceTextField(
                    controller: _passwordController,
                    label: 'Gizli Şifre',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: viewModel.setPassword,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        viewModel.login(context);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şifrenizi girin';
                      }
                      if (value.length < 6) {
                        return 'Şifre en az 6 karakter olmalıdır';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLoginButton(viewModel),
                  const SizedBox(height: 16),
                  _buildRegisterButton(),
                  const SizedBox(height: 16),
                  _buildNoAccountButton(),
                  if (viewModel.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        viewModel.error!,
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        onPressed: viewModel.isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  await viewModel.login(context);
                }
              },
        style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentPurple),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text(
                    'Galaksiye Giriş Yap',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterView()),
        );
      },
      child: Text(
        'Yeni bir kaşif misin? Kayıt ol',
        style: TextStyle(
          color: SpaceTheme.accentGold,
          fontSize: 16,
        ),
      ),
    );
  }
  Widget _buildNoAccountButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MainScreen()),
        );
      },
      child: Text(
        'Kayıt Olmadan Devam Et',
        style: TextStyle(
          color: SpaceTheme.accentGold,
          fontSize: 16,
        ),
      ),
    );
  }
}



