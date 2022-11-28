import 'package:firebase_auth/firebase_auth.dart';
import 'package:tarot/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:tarot/widgets/login_alert.dart';
import 'package:email_validator/email_validator.dart';

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
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> loginState = GlobalKey<FormFieldState>();
  var error = '';

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
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: loginController.text, password: passwordController.text)
          .then((_) => {Navigator.popAndPushNamed(context, HomeScreen.id)});
    } on FirebaseAuthException catch (authError) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formState,
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
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
                    if(!EmailValidator.validate(value)){
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
                    if (value != passwordCheckController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordCheckController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Repeat password',
                    hintText: 'Enter your password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is empty';
                    }
                    if (value != passwordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formState.currentState!.validate()) {
                      signup(context);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        signup(context);
                      }
                    },
                    child: const Text('Signup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
