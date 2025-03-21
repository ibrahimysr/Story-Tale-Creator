import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masal/viewmodels/home_viewmodel.dart';
import 'package:masal/viewmodels/register_viewmodel.dart';
// import 'package:masal/views/delete_account.view.dart';
// import 'package:masal/views/privacy_policy_view.dart';
// import 'package:masal/views/support_view.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'views/auth/login_view.dart';
import 'viewmodels/story_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
     runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
                ChangeNotifierProvider(create: (_) => RegisterViewModel()),

        ChangeNotifierProvider(create: (_) => StoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()..loadUserProfile()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'Masal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      //  initialRoute: '/delete-account', // Varsayılan açılış sayfası
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case '/delete-account':
      //       return MaterialPageRoute(builder: (_) => const DeleteAccountView());
      //     case '/support':
      //       return MaterialPageRoute(builder: (_) => const SupportView());
      //     case '/privacy-policy':
      //       return MaterialPageRoute(builder: (_) => const PrivacyPolicyView());
      //     default:
      //       return MaterialPageRoute(builder: (_) => const DeleteAccountView()); 
      //   }
      // },
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              );
            }
            
            if (snapshot.hasData && snapshot.data != null) {
              return  MainScreen();
            }
            
            return  LoginView();
        
   } )
      )
    
    ); }
}

