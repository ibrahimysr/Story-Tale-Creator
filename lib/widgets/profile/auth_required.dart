import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/views/auth/login_view.dart';

Widget buildAuthRequiredView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_circle_outlined,
          size: 80,
          color: SpaceTheme.accentGold,
        ),
        const SizedBox(height: 20),
        Text(
          context.localizations.authRequiredMessage, 
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          style: SpaceTheme.getMagicalButtonStyle(SpaceTheme.accentBlue),
          child: Text(
            context.localizations.login, 
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}