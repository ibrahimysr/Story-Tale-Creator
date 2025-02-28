// lib/views/register_view.dart
import 'package:flutter/material.dart';
import 'package:masal/viewmodels/register_viewmodel.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth/space_text_field.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedAvatar = 'boy (1).png'; // Varsayılan avatar

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _avatars = [
    'boy (1).png', 'boy (2).png', 'boy (3).png', 'boy (4).png', 'boy (5).png',
    'boy (6).png', 'boy (7).png', 'boy (8).png', 'boy (9).png', 'boy (10).png',
    'girl (1).png', 'girl (2).png', 'girl (3).png', 'girl (4).png', 'girl (5).png',
    'girl (6).png', 'girl (7).png', 'girl (8).png', 'girl (9).png', 'girl (10).png',
  ];

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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
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
                            child: _buildRegisterForm(),
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
                SpaceTheme.accentGold.withOpacity(0.8),
                SpaceTheme.accentPurple.withOpacity(0.8),
              ],
            ),
            boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentGold),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Uzay Macerasına Katıl',
          style: SpaceTheme.titleStyle,
        ),
      ],
    );
  }

 
  Widget _buildRegisterForm() {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentPurple),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avatar Seç',
                          style: TextStyle(
                            color: SpaceTheme.accentGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 150,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: _avatars.length,
                            itemBuilder: (context, index) {
                              final avatar = _avatars[index];
                              final isSelected = avatar == _selectedAvatar;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAvatar = avatar;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? SpaceTheme.accentGold : Colors.transparent,
                                      width: 4,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: AssetImage('assets/avatar/$avatar'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SpaceTextField(
                    controller: _usernameController,
                    label: 'Kaşif Adı',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir kaşif adı girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SpaceTextField(
                    controller: _emailController,
                    label: 'Galaktik E-posta',
                    icon: Icons.email_outlined,
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
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        viewModel.register(
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _selectedAvatar,
                        );
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
                  _buildRegisterButton(viewModel),
                  const SizedBox(height: 16),
                  _buildLoginButton(),
                  if (viewModel.state == RegisterState.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        viewModel.errorMessage,
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

  Widget _buildRegisterButton(RegisterViewModel viewModel) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        onPressed: viewModel.state == RegisterState.loading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  await viewModel.register(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _selectedAvatar,
                  );
                  
                  if (viewModel.state == RegisterState.success) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  }
                }
              },
        style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentPurple),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: viewModel.state == RegisterState.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text(
                    'Maceraya Katıl',
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

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Zaten bir kaşif misin? Giriş yap',
        style: TextStyle(
          color: SpaceTheme.accentGold,
          fontSize: 16,
        ),
      ),
    );
  }
}