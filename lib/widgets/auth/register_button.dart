import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';
import 'package:masal/core/theme/space_theme.dart';
import 'package:masal/views/auth/register_view.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';

Widget buildRegisterButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterView()),
      );
    },
    child: Text(
      context.localizations.newExplorerRegister, 
      style: TextStyle(
        color: SpaceTheme.accentGold,
        fontSize: 16,
      ),
    ),
  );
}

Widget buildNoAccountButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    },
    child: Text(
      context.localizations.continueWithoutRegister, 
      style: TextStyle(
        color: SpaceTheme.accentGold,
        fontSize: 16,
      ),
    ),
  );
}