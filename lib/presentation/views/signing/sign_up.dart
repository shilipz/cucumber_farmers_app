// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cucumber_app/presentation/views/contact_details/contact_details.dart';
import 'package:cucumber_app/presentation/views/contact_details/contact_profile.dart';
import 'package:cucumber_app/presentation/views/signing/login.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import 'package:cucumber_app/domain/models/user_model.dart';
import 'package:cucumber_app/domain/repositories/auth.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.customValidator}) : super(key: key);
  final String? Function(String?)? customValidator;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  @override
  void dispose() {
    // Dispose the controllers when they are no longer needed to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

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
            const LoginHeading(
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
                        height: 50,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (widget.customValidator != null) {
                              final customError =
                                  widget.customValidator!(value);
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
                          obscureText: true,
                          inputController: passwordController),
                      SizedBox(height: screenHeight * 0.05),
                      Forms(loginText: 'Confirm Password', obscureText: true),
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

  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset(
            'assets/511-976-dot-loading-loaders.riv');
      },
    );
  }

  Future<void> _signup(BuildContext context) async {
    UserModel userModel = UserModel(
        email: emailController.text,
        password: passwordController.text,
        username: _capitalizeFirstLetter(usernameController.text));

    showLoading(context);

    User? user = await _auth.signUpWithEmailAndPassword(userModel);

    if (user != null) {
      log("User is successfully created");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactDetails(),
      ));
    } else if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill all fields")));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Something went wrong")));
      Navigator.of(context).pop();
      // log("User is null - some error happened");
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
