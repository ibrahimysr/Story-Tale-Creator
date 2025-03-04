import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/register_viewmodel.dart';
import 'package:masal/widgets/auth/header.dart';
import 'package:masal/widgets/auth/register_form.dart';
import 'package:provider/provider.dart';

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
  String _selectedAvatar = 'boy (1).png';

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
                    padding: context.paddingNormal * 1.4,
                    child: Column(
                      children: [
                        SizedBox(height: context.getDynamicHeight(5)),
                        buildHeader(context, Icons.auto_awesome, 'Uzay Macerasına Katıl'),
                        SizedBox(height: context.getDynamicHeight(5)),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: RegisterForm(
                              formKey: _formKey,
                              usernameController: _usernameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              selectedAvatar: _selectedAvatar,
                              avatars: _avatars,
                              onAvatarSelected: (avatar) {
                                setState(() {
                                  _selectedAvatar = avatar;
                                });
                              },
                            ),
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
}