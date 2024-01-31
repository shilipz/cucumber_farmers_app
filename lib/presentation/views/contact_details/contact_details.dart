import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/contact_details/current_location.dart';

import 'package:cucumber_app/presentation/views/signing/login.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formkey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name cant be empty';
    }

    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Number is required';
    }

    return null;
  }

  String? validateFarmName(String? value) {
    if (value == null || value.isEmpty) {
      return 'House/Farm name  is required';
    }

    return null;
  }

  String? validateStreetName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Street name is required';
    }

    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }

    return null;
  }

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController farmNameController = TextEditingController();

  final TextEditingController streetNameController = TextEditingController();

  final TextEditingController landMarkController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    farmNameController.dispose();
    streetNameController.dispose();
    pincodeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.8),
              child: const Arrowback(backcolor: darkgreen),
            ),
            const Captions(
                captions: 'Join Cucumber Sales Team', captionColor: darkgreen),
            Container(
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contactsssss Details',
                            style: TextStyle(fontSize: 18, color: darkgreen)),
                        sheight,
                        ContactForm(
                            inputController: nameController,
                            customValidator: validateFullName,
                            formHints: 'Full Name'),
                        sheight,
                        ContactForm(
                            inputController: phoneNumberController,
                            customValidator: validatePhoneNumber,
                            formHints: 'Contact Number'),
                        sheight,
                        const Text('Address for Collection',
                            style: TextStyle(fontSize: 18, color: darkgreen)),
                        sheight,
                        ContactForm(
                            inputController: farmNameController,
                            customValidator: validateFarmName,
                            formHints: 'House/Farm name'),
                        sheight,
                        ContactForm(
                            inputController: streetNameController,
                            customValidator: validateStreetName,
                            formHints: 'Street Name'),
                        sheight,
                        ContactForm(
                            inputController: landMarkController,
                            formHints: 'Landmark(optional)'),
                        sheight,
                        ContactForm(
                            inputController: pincodeController,
                            customValidator: validatePincode,
                            formHints: 'Pincode'),
                        sheight,
                        const Text('also pin your location on map',
                            style: TextStyle(fontSize: 18, color: darkgreen)),
                        SizedBox(height: screenHeight * 0.01),
                        Center(
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CurrentLocation(),
                                ));
                              },
                              icon: const Icon(
                                Icons.location_pin,
                                size: 42,
                                color: Colors.red,
                              )),
                        ),
                        Next(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                addUserDetails(context);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => const CurrentLocation(),
                                // ));
                              }
                              log('message');
                            },
                            buttonText: 'Save',
                            buttonColor: darkgreen),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addUserDetails(BuildContext context) async {
    log('1');

    User? user = FirebaseAuth.instance.currentUser;

    String fullName = formatText(nameController.text);
    String phoneNumber = formatText(phoneNumberController.text);
    String houseName = formatText(farmNameController.text);
    String streetName = formatText(streetNameController.text);
    String landmark = formatText(landMarkController.text);

    var userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    // .collection('contact_details')
    // .doc()
    await userDocRef.update({
      'fullname': fullName,
      'phoneNumber': phoneNumber,
      'houseName': houseName,
      'streetName': streetName,
      'landmark': landmark,
      // 'pincode': pincode,
    });
    // ignore: use_build_context_synchronously
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile created successfully')),
      );
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    }
  }

  String formatText(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
