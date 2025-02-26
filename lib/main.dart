import 'package:flutter/material.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/story/viewmodels/story_viewmodel.dart';

void main() {
  runApp(const HikayeUygulamasi());
}

class HikayeUygulamasi extends StatelessWidget {
  const HikayeUygulamasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}