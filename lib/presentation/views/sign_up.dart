import 'dart:developer';

import 'package:cucumber_app/domain/repositories/auth.dart';
import 'package:cucumber_app/presentation/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../utils/constants/constants.dart';
import '../widgets/signing_widgets.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, this.customValidator});
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final String? Function(String?)? customValidator;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: screenWidth * 0.6, top: screenHeight * 0.02),
              child: Text(
                'Back to login page',
                style: GoogleFonts.aDLaMDisplay(),
              ),
            ),
            lheight,
            LoginHeading(
              signingText: 'Sign Up',
              textcolor: darkgreen,
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(80),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // width: 300,
                        height: 50,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (customValidator != null) {
                              final customError = customValidator!(value);
                              if (customError != null) {
                                return customError;
                              }
                            }
                            return null;
                          },
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(color: hintcolor),
                            prefix: const SizedBox(
                              width: 25,
                              height: 30,
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Forms(
                          loginText: 'Email', inputController: emailController),
                      SizedBox(height: screenHeight * 0.05),
                      Forms(
                          loginText: 'Password',
                          inputController: passwordController),
                      SizedBox(height: screenHeight * 0.05),
                      Forms(loginText: 'Confirm Password'),
                      SizedBox(height: screenHeight * 0.05),
                      SignUpButton(
                        buttonText: 'Sign Up',
                        onPressed: () async {
                          await _signup(context);
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
                    ],
                  ),
                ),
              ),
            ])
          ],
        ),
      )),
    );
  }

  Future<void> _signup(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = _capitalizeFirstLetter(
        usernameController.text); // Capitalize the first letter of the username
    User? user =
        await _auth.signUpWithEmailAndPassword(email, password, username);

    if (user != null) {
      log("User is successfully created");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    } else {
      log("some error happened");
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
