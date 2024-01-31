// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cucumber_app/domain/repositories/auth.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/home/home_screen.dart';
import 'package:cucumber_app/presentation/views/signing/sign_up.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(65),
                    bottomRight: Radius.circular(65)),
                child: Image.asset(
                  'assets/signup_img.jpg',
                  width: screenWidth,
                  height: screenHeight * 0.35,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  top: screenHeight * 0.13,
                  left: screenWidth * 0.25,
                  child: const LoginHeading(
                    signingText: 'Cucumber',
                    textcolor: kwhite,
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.33,
                    right: screenWidth * 0.13,
                    left: screenWidth * 0.13),
                child: Column(children: [
                  Forms(
                    loginText: 'Email',
                    inputController: emailController,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Forms(
                      obscureText: true,
                      loginText: 'Password',
                      inputController: passwordController),
                  SizedBox(height: screenHeight * 0.05),
                  SignUpButton(
                    buttonText: 'Login',
                    onPressed: () {
                      _signin(context, emailController.text,
                          passwordController.text);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  const Text('forgot your password?'),
                  SizedBox(
                    height: screenHeight * 0.13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(fontSize: 25, color: darkgreen),
                          )),
                      const SigninButton()
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset(
            'assets/511-976-dot-loading-loaders.riv');
      },
    );
  }

  Future<void> _signin(
      BuildContext context, String email, String password) async {
    showLoading(context);

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        log("User is successfully signed in");
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      } else if (emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please fill email and password fields")));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orange,
            content: Text("Usename and Password doesn't match")));
        Navigator.of(context).pop();
        // log("User is null - some error happened");
      }
    } catch (e) {
      log("Sign-in error: $e");
      const AlertDialog(
        title: Text("Usename and Password doesn't match"),
      );
      // Show an error dialog or update the UI to indicate the sign-in failure
    }
  }
}
