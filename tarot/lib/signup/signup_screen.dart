import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:tarot/widgets/login_alert.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const id = 'signup_screen';

  @override
  State<SignupScreen> createState() {
    return _SignupScreen();
  }
}

class _SignupScreen extends State<SignupScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  bool validate(BuildContext context) {
    if (loginController.text == '') {
      return loginAlert(context, 'Empty e-mail');
    } else if (passwordController.text == '') {
      return loginAlert(context, 'Empty password');
    }
    return true;
  }

  void signup(BuildContext context) async {
    if (validate(context) == false) {
      return;
    }
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: loginController.text, password: passwordController.text)
        .then((_) => {Navigator.popAndPushNamed(context, HomeScreen.id)})
        .catchError((e) {
      var authError = e as FirebaseAuthException;
      switch (authError.code) {
        case 'invalid-email':
          loginAlert(context, 'Invalid e-mail');
          break;
        case 'email-already-in-use':
          loginAlert(context, 'E-mail already in use');
          break;
        case 'weak-password':
          loginAlert(context, 'Weak password');
          break;
        case 'operation-not-allowed':
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
                helperText: 'example@example.com', prefixText: 'E-mail'),
            controller: loginController,
          ),
          TextField(
            decoration: const InputDecoration(
              helperText: '*****',
              prefixText: 'Password',
            ),
            obscureText: true,
            controller: passwordController,
          ),
          TextField(
            decoration: const InputDecoration(
              helperText: '*****',
              prefixText: 'Repeat Password',
            ),
            obscureText: true,
            controller: passwordCheckController,
          ),
          TextButton(
              onPressed: () => signup(context), child: const Text('Sign up')),
        ],
      ),
    );
  }
}
