import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/widgets/auth/header.dart';
import 'package:masal/widgets/auth/login_form.dart';
import 'package:provider/provider.dart';
import '../../core/theme/space_theme.dart';
import '../../core/theme/widgets/starry_background.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
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
                    padding: context.paddingNormal,
                    child: Column(
                      children: [
                        SizedBox(height: context.getDynamicHeight(8)),
                        buildHeader(context,Icons.rocket_launch, 'Galaktik Giriş'),
                        SizedBox(height: context.getDynamicHeight(5)),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: buildLoginForm(
                                _emailController, _passwordController, _formKey),
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
