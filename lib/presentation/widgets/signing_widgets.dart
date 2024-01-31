// ignore_for_file: use_build_context_synchronously

import 'package:cucumber_app/presentation/views/contact_details/contact_details.dart';
import 'package:cucumber_app/presentation/views/home/home_screen.dart';
import 'package:cucumber_app/utils/authentication.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

// ignore: must_be_immutable
class Forms extends StatelessWidget {
  final String loginText;
  final TextEditingController? inputController;
  final String? Function(String?)? customValidator;
  final bool? obscureText;
  FocusNode? focusNode;
  Forms(
      {this.customValidator,
      required this.loginText,
      this.inputController,
      Key? key,
      this.focusNode,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        validator: (value) {
          if (customValidator != null) {
            final customError = customValidator!(value);
            if (customError != null) {
              return customError;
            }
          }
          return null;
        },
        obscureText: obscureText ?? false,
        controller: inputController,
        decoration: InputDecoration(
          hintText: loginText,
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
    );
  }
}

class SignUpButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Function()? onPressed;
  const SignUpButton(
      {required this.buttonText,
      super.key,
      required this.onPressed,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(lightgreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ))),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, color: kwhite),
        ),
      ),
    );
  }
}

class SigninButton extends StatelessWidget {
  const SigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.login, color: darkgreen, size: 45);
  }
}

// arrow button calling widget
class SignInCard extends StatelessWidget {
  final String cardtext;
  const SignInCard({required this.cardtext, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: screenWidth * 0.9,
        // height: screenHeight * 0.2,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(cardtext, style: TextStyle(fontSize: 20, color: darkgreen)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ContactDetails()));
                },
                child: Text(cardtext,
                    style: const TextStyle(fontSize: 20, color: darkgreen))),
            const SigninButton()
          ],
        ),
      ),
    );
  }
}

class Arrowback extends StatelessWidget {
  final Color backcolor;
  const Arrowback({required this.backcolor, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 25, color: backcolor));
  }
}

class LoginButton extends StatelessWidget {
  final String buttonText;
  final String email;
  final String password;
  const LoginButton(
      {required this.buttonText,
      super.key,
      required this.email,
      required this.password});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (FirebaseAuth.instance.currentUser != null) {
            await signIn(email, password);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Home(),
            ));
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(lightgreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ))),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class LoginHeading extends StatelessWidget {
  final String signingText;
  final Color textcolor;
  const LoginHeading(
      {super.key, required this.signingText, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Text(signingText,
        style: GoogleFonts.playfairDisplay(
            textStyle: TextStyle(
                color: textcolor, fontSize: 36, fontWeight: FontWeight.bold)));
  }
}
