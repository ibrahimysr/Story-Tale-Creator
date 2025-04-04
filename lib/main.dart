import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masal/environment_config.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/viewmodels/locale_provider.dart';
import 'package:masal/viewmodels/register_viewmodel.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'views/auth/login_view.dart';
import 'viewmodels/story_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EnvironmentConfig.initializeEnvironment();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(
          create: (context) => StoryViewModel(
            localeProvider: context.read<LocaleProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel()..loadUserProfile(),
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Masal',
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data != null) {
                  return const MainScreen();
                }

                return const LoginView();
              },
            ),
          );
        },
      ),
    );
  }
}
