import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarot/login/login_screen.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const id = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.pushReplacementNamed(context, HomeScreen.id));
    } else {
      Future.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.pushReplacementNamed(context, LoginScreen.id));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Tarot App')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/icons/splash.png', height: 256,)),
        ],
      ),
    );
  }
}
