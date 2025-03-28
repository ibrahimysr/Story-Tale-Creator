import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masal/EnvironmentConfig.dart';
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
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set path URL strategy for web
  setPathUrlStrategy();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize environment configuration
  await EnvironmentConfig.initializeEnvironment();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // View Model Providers
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => StoryViewModel()),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel()..loadUserProfile()
        ),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        
        // Locale Provider
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            // Remove debug banner
            debugShowCheckedModeBanner: false,
            
            // App title
            title: 'Masal',
            
            // Localization settings
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            
            // Theme configuration
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              
              // Optional: Add a more comprehensive app-wide theme
              brightness: Brightness.light,
              fontFamily: 'Roboto', // Replace with your preferred font
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            
            // Authentication state management
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // Show loading indicator while checking auth state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }
                
                // Navigate based on authentication state
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