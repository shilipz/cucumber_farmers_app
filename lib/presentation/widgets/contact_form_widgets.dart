import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/constants.dart';

class ContactForm extends StatelessWidget {
  final String? formHints;
  final TextEditingController? inputController;
  final String? Function(String?)? customValidator;
  final Color? nameBorder;
  const ContactForm(
      {this.formHints,
      super.key,
      this.inputController,
      this.customValidator,
      this.nameBorder});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
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
        controller: inputController,
        decoration: InputDecoration(
          hintText: formHints,
          hintStyle: const TextStyle(color: Colors.white),
          prefix: const SizedBox(width: 25, height: 30),
          filled: true,
          fillColor: transOrange,
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

class Next extends StatelessWidget {
  final IconData? pinIcon;
  final String buttonText;
  final Color buttonColor;
  final Function()? onPressed;
  const Next(
      {required this.buttonText,
      required this.buttonColor,
      super.key,
      this.onPressed,
      this.pinIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // height: 40,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonText,
                style: const TextStyle(fontSize: 18, color: kwhite),
              ),
              Icon(
                pinIcon,
                size: 32,
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Captions extends StatelessWidget {
  final String captions;
  final Color captionColor;
  const Captions(
      {required this.captionColor, required this.captions, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(captions,
        style: GoogleFonts.playfairDisplay(
            textStyle: TextStyle(
                color: captionColor,
                fontSize: 24,
                fontWeight: FontWeight.bold)));
  }
}

class WelcomeCaptions extends StatelessWidget {
  final String captions;
  final Color captionColor;
  const WelcomeCaptions(
      {required this.captionColor, required this.captions, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(captions,
        style: GoogleFonts.playfairDisplay(
            textStyle: TextStyle(
                color: captionColor,
                fontSize: 30,
                fontWeight: FontWeight.bold)));
  }
}

class ProfileEdit extends StatelessWidget {
  final String? label;
  final String? text;
  final IconData? icons;
  final Function()? onpressed;
  const ProfileEdit({
    super.key,
    this.label,
    this.text,
    this.icons,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icons),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(text ?? '')
        ],
      ),
      trailing: IconButton(onPressed: onpressed, icon: const Icon(Icons.edit)),
    );
  }
}
