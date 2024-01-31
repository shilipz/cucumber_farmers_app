// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/home/home_screen.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController accountNameController = TextEditingController();

  final TextEditingController accountNumberController = TextEditingController();

  final TextEditingController ifscController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldMessengerState> scaffoldKey =
        GlobalKey<ScaffoldMessengerState>();
    String? validateAccountName(String? value) {
      if (value == null || value.isEmpty) {
        return "Fields cant be empty";
      }
      return null;
    }

    String? validateAccountNo(String? value) {
      if (value == null || value.isEmpty) {
        return "Fields cant be empty";
      }
      return null;
    }

    String? validateIfsc(String? value) {
      if (value == null || value.isEmpty) {
        return "Fields cant be empty";
      }
      return null;
    }

    @override
    void dispose() {
      accountNameController.dispose();
      accountNumberController.dispose();
      ifscController.dispose();
      super.dispose();
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kblack,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: Alignment.bottomCenter,
                  colors: [kwhite, lightgreen]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  // Positioned(
                  //     right: 0,
                  //     child:
                  //         Image.asset('assets/sale info.png', fit: BoxFit.contain)),
                  const Row(
                    children: [
                      Arrowback(backcolor: darkgreen),
                      Captions(
                          captions: 'Payment Information,',
                          captionColor: darkgreen),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.1, left: 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bank Details",
                              style: TextStyle(fontSize: 18, color: darkgreen)),
                          sheight,
                          const Text("Account holder's Name",
                              style: commonText),
                          sheight,
                          ContactForm(
                            inputController: accountNameController,
                            customValidator: validateAccountName,
                          ),
                          sheight,
                          const Text("Account Number", style: commonText),
                          sheight,
                          ContactForm(
                              inputController: accountNumberController,
                              customValidator: validateAccountNo),
                          const Text("Confirm Account Number",
                              style: commonText),
                          sheight,
                          ContactForm(
                              inputController: accountNumberController,
                              customValidator: validateAccountNo),
                          sheight,
                          const Text("IFSC Code", style: commonText),
                          sheight,
                          ContactForm(
                            inputController: ifscController,
                            customValidator: validateIfsc,
                          ),
                          const SizedBox(height: 34),
                          Center(
                              child: InkWell(
                                  onTap: () {
                                    if (formkey.currentState!.validate()) {
                                      addPaymentDetails(context).then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Payment details added successfully')));
                                        navigatorKey.currentState
                                            ?.pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => const Home(),
                                          ),
                                          (route) => false,
                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Failed to add payment details: $error')));
                                      });
                                    }
                                  },
                                  child: const Next(
                                    buttonText: 'Submit',
                                    buttonColor: darkgreen,
                                  ))),
                          sheight,
                          const Center(
                              child: Text(
                                  'By clicking on the submit button, you agreed to our terms and conditions',
                                  style: TextStyle(fontSize: 12))),
                          const SizedBox(height: 32),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list),
                              Text('Terms & Conditions', style: commonText),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPaymentDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    String accountName = formatText(accountNameController.text);
    String accountNumber = formatText(accountNumberController.text);
    String ifscNumber = formatText(ifscController.text);

    var userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    await userDocRef.update({
      'accountName': accountName,
      'accountNumber': accountNumber,
      'ifsc': ifscNumber,
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment details added successfully')));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false);
  }

  String formatText(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
