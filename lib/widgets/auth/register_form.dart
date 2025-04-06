import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/register_viewmodel.dart';
import 'package:masal/widgets/auth/space_text_field.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedAvatar;
  final List<String> avatars;
  final Function(String) onAvatarSelected;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.selectedAvatar,
    required this.avatars,
    required this.onAvatarSelected,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: SpaceTheme.getMagicalGlow(SpaceTheme.accentPurple),
            ),
            child: Form(
              key: widget.formKey,
              child: Column(
                children: [
                  _buildAvatarSelector(context),
                  SizedBox(height: context.getDynamicHeight(3)),
                  _buildUsernameField(),
                  SizedBox(height: context.getDynamicHeight(2)),
                  _buildEmailField(),
                  SizedBox(height: context.getDynamicHeight(2)),
                  _buildPasswordField(viewModel),
                  const SizedBox(height: 24),
                  _buildRegisterButton(viewModel),
                  const SizedBox(height: 16),
                  _buildLoginButton(),
                  if (viewModel.state == RegisterState.error)
                    Padding(
                      padding: EdgeInsets.only(top: context.lowValue),
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

  Widget _buildAvatarSelector(BuildContext context) {
    return Container(
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.selectAvatar, 
            style: TextStyle(
              color: SpaceTheme.accentGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.getDynamicHeight(2)),
          SizedBox(
            height: context.getDynamicHeight(20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: widget.avatars.length,
              itemBuilder: (context, index) {
                final avatar = widget.avatars[index];
                final isSelected = avatar == widget.selectedAvatar;
                return GestureDetector(
                  onTap: () => widget.onAvatarSelected(avatar),
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
    );
  }

  Widget _buildUsernameField() {
    return SpaceTextField(
      controller: widget.usernameController,
      label: context.localizations.explorerName,
      icon: Icons.person_outline,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.localizations.enterExplorerName;
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return SpaceTextField(
      controller: widget.emailController,
      label: context.localizations.galacticEmail,
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.localizations.enterEmail; 
        }
        if (!value.contains('@')) {
          return context.localizations.invalidEmail; 
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(RegisterViewModel viewModel) {
    return SpaceTextField(
      controller: widget.passwordController,
      label: context.localizations.secretPassword, 
      icon: Icons.lock_outline,
      isPassword: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        if (widget.formKey.currentState!.validate()) {
          viewModel.register(
            widget.usernameController.text,
            widget.emailController.text,
            widget.passwordController.text,
            widget.selectedAvatar, 
            context,
          );
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.localizations.enterPassword; 
        }
        if (value.length < 6) {
          return context.localizations.passwordMinLength; 
        }
        return null;
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
                if (widget.formKey.currentState!.validate()) {
                  await viewModel.register(
                    widget.usernameController.text,
                    widget.emailController.text,
                    widget.passwordController.text,
                    widget.selectedAvatar, 
                    context
                  );
                  if (viewModel.state == RegisterState.success) {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    }
                  }
                }
              },
        style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentPurple),
        child: Container(
          padding: context.paddingLowVertical,
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
                : Text(
                    context.localizations.joinAdventure, 
                    style: const TextStyle(
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
      onPressed: () => Navigator.pop(context),
      child: Text(
        context.localizations.alreadyExplorerLogin,
        style: TextStyle(
          color: SpaceTheme.accentGold,
          fontSize: 16,
        ),
      ),
    );
  }
}