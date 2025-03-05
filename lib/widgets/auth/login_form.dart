import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/viewmodels/login_viewmodel.dart';
import 'package:masal/views/auth/reset_password_view.dart';
import 'package:masal/widgets/auth/register_button.dart';
import 'package:masal/widgets/auth/space_text_field.dart';
import 'package:provider/provider.dart';

Widget buildLoginForm(TextEditingController emailController,
    TextEditingController passwordController, GlobalKey<FormState> formKey) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
              key: formKey,
              child: Column(
                children: [
                  SpaceTextField(
                    controller: emailController,
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
                  SizedBox(height: context.getDynamicHeight(2)),
                  SpaceTextField(
                    controller: passwordController,
                    label: 'Gizli Şifre',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: viewModel.setPassword,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
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
                  SizedBox(height: context.getDynamicHeight(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetScreen(),));
                        },
                        child: Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildLoginButton(viewModel,formKey,context),
                  SizedBox(height: context.getDynamicHeight(1)),
                  buildRegisterButton(context),
                  SizedBox(height: context.getDynamicHeight(1)),
                  buildNoAccountButton(context),
                  if (viewModel.error != null)
                    Padding(
                      padding: context.paddingNormalVertical,
                      child: Container(
                        padding:  EdgeInsets.symmetric(
                            horizontal: context.normalValue, vertical: context.lowValue),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withValues(alpha:  0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[300],
                              size: 24,
                            ),
                             SizedBox(width: context.getDynamicWidth(2)),
                            Expanded(
                              child: Text(
                                viewModel.error!,
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red[300],
                                size: 20,
                              ),
                              onPressed: () => viewModel.clearError(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            )
                          ],
                        ),
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

  Widget _buildLoginButton(LoginViewModel viewModel,GlobalKey<FormState> formKey,BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ElevatedButton(
        onPressed: viewModel.isLoading
            ? null
            : () async {
                if (formKey.currentState!.validate()) {
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