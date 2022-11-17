import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarot/signup/signup_screen.dart';
import 'package:tarot/widgets/login_alert.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: loginController.text, password: passwordController.text)
        .then((_) => {Navigator.popAndPushNamed(context, HomeScreen.id)})
        .catchError((e) {
      var authError = e as FirebaseAuthMultiFactorException;
      switch (authError.code) {
        case 'invalid-email':
          loginAlert(context, 'Invalid e-mail');
          break;
        case 'user-disabled':
          loginAlert(context, 'User disabled');
          break;
        case 'user-not-found':
        case 'wrong-password':
          loginAlert(context, 'User not found, check e-mail and password');
          break;
        default:
          loginAlert(context, 'Unknown error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Use Form
    return Material(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
                hintText: 'example@example.com', prefixText: 'E-mail'),
            controller: loginController,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: '*****',
              prefixText: 'Password',
            ),
            obscureText: true,
            controller: passwordController,
          ),
          TextButton(
              onPressed: () => login(context), child: const Text('Login')),
          TextButton(
              onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
              child: const Text('Signup')),
        ],
      ),
    );
  }
}
