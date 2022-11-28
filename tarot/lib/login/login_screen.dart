import 'package:email_validator/email_validator.dart';
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
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

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
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
    return Form(
      key: formState,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Material(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: loginController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Enter your email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'E-mail is empty';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid e-mail';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formState.currentState!.validate()) {
                      login(context);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        login(context);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, SignupScreen.id),
                  child: const Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
