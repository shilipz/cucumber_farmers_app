import 'dart:developer';

import 'package:cucumber_app/domain/repositories/auth.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/home/home_screen.dart';
import 'package:cucumber_app/presentation/views/home_screen.dart';
import 'package:cucumber_app/presentation/views/sign_up.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                  child: LoginHeading(
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
                    loginText: 'Username',
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
                      _signin(context);
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
                                builder: (context) => SignUpScreen()));
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

  Future<void> _signin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        log("User is successfully signed in");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      } else {
        const AlertDialog(
          title: Text("Usename and Password doesn't match"),
        );
        log("User is null - some error happened");
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
