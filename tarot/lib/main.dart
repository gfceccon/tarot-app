import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tarot/card/card_screen.dart';
import 'package:tarot/draw/draw_screen.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:tarot/signup/signup_screen.dart';
import 'package:tarot/splash/splash_screen.dart';
import 'package:tarot/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(TarotApp(app: app));
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key, required this.app});

  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Tarot App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.deepPurple,
        secondaryHeaderColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
      ),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        DrawScreen.id: (context) => const DrawScreen(),
        CardScreen.id: (context) => const CardScreen(),
        SplashScreen.id: (context) => const SplashScreen()
      },
      home: const SplashScreen(),
    );
  }
}
