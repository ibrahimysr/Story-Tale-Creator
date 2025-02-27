import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masal/widgets/navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'views/auth/login_view.dart';
import 'viewmodels/story_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()..loadUserProfile()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Masal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
        routes: {
          '/login': (context) => const LoginView(),
        },
      ),
    );
  }
}