import 'package:flutter/material.dart';
import 'package:masal/core/extension/context_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/core/theme/widgets/starry_background.dart';
import 'package:masal/viewmodels/delete_account_viewmodel.dart';
import 'package:provider/provider.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  _DeleteAccountViewState createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteAccountViewModel(),
      child: Consumer<DeleteAccountViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: SpaceTheme.mainGradient),
              child: Stack(
                children: [
                  const Positioned.fill(child: StarryBackground()),
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.getDynamicWidth(5),
                          vertical: context.getDynamicHeight(2),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 500, // Web için maksimum genişlik
                          ),
                          child: Card(
                            color: SpaceTheme.primaryDark.withOpacity(0.8),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    size: 80,
                                    color: SpaceTheme.accentGold,
                                    shadows: [
                                      Shadow(
                                        color: SpaceTheme.accentPurple,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.getDynamicHeight(3)),
                                  Text(
                                    'Hesabını Sil',
                                    style: SpaceTheme.titleStyle.copyWith(
                                      fontSize: 32,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  Text(
                                    'Bu işlem geri alınamaz! E-posta ve şifreni girerek hesabını sil. Uzay maceran sona erecek!',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: context.getDynamicHeight(3)),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'E-posta',
                                      labelStyle:
                                          TextStyle(color: Colors.white.withOpacity(0.8)),
                                      hintText: 'E-posta adresini gir',
                                      hintStyle:
                                          TextStyle(color: Colors.white.withOpacity(0.6)),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: SpaceTheme.accentPurple,
                                      ),
                                      filled: true,
                                      fillColor: SpaceTheme.primaryDark.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: SpaceTheme.accentPurple.withOpacity(0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: SpaceTheme.accentPurple, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Şifren',
                                      labelStyle:
                                          TextStyle(color: Colors.white.withOpacity(0.8)),
                                      hintText: 'Şifreni gir',
                                      hintStyle:
                                          TextStyle(color: Colors.white.withOpacity(0.6)),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: SpaceTheme.accentPurple,
                                      ),
                                      filled: true,
                                      fillColor: SpaceTheme.primaryDark.withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: SpaceTheme.accentPurple.withOpacity(0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: SpaceTheme.accentPurple, width: 2),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: context.getDynamicHeight(3)),
                                  if (viewModel.errorMessage != null)
                                    Text(
                                      viewModel.errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  viewModel.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: SpaceTheme.accentPurple,
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () async {
                                            await viewModel.deleteAccount(
                                              _emailController.text,
                                              _passwordController.text,
                                              context,
                                            );
                                            if (viewModel.successMessage != null &&
                                                context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    viewModel.successMessage!,
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      SpaceTheme.accentPurple.withOpacity(0.8),
                                                  duration: Duration(seconds: 3),
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(15)),
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: SpaceTheme.accentPurple,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25)),
                                            elevation: 5,
                                            shadowColor:
                                                SpaceTheme.accentPurple.withOpacity(0.5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: SpaceTheme.accentGold,
                                                size: 24,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Hesabımı Sil',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  SizedBox(height: context.getDynamicHeight(2)),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Vazgeç ve Geri Dön',
                                      style: TextStyle(
                                        color: SpaceTheme.accentGold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
}