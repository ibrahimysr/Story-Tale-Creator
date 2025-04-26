import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/views/auth/login_view.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SpaceTheme.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title:  Text(
        context.localizations.loginRequiredTitle,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content:  Text(
        context.localizations.loginRequiredMessage,
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            context.localizations.cancel,
            style: TextStyle(color: SpaceTheme.accentBlue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SpaceTheme.accentPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:  Text(
            context.localizations.login,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}