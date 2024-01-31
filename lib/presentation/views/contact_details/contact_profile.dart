import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/contact_details/current_location.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactProfile extends StatelessWidget {
  ContactProfile({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  void _openEditBottomSheet(
      BuildContext context, String field, String initialValue) {
    TextEditingController controller;

    if (field == 'Name') {
      controller = fullNameController..text = initialValue;
    } else if (field == 'Phone number') {
      controller = phoneNumberController..text = initialValue;
    } else if (field == 'house name') {
      controller = houseNameController..text = initialValue;
    } else if (field == 'street name') {
      controller = streetNameController..text = initialValue;
    } else if (field == 'landmark') {
      controller = landmarkController..text = initialValue;
    } else {
      controller = TextEditingController()..text = initialValue;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(labelText: 'Edit $field'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (field == 'Name') {
                            fullNameController.text = controller.text;
                          } else if (field == 'Phone number') {
                            phoneNumberController.text = controller.text;
                          } else if (field == 'house name') {
                            houseNameController.text = controller.text;
                          } else if (field == 'street name') {
                            streetNameController.text = controller.text;
                          } else if (field == 'landmark') {
                            landmarkController.text = controller.text;
                          } else if (field == 'pincode') {
                            pincodeController.text = controller.text;
                          }
                        });

                        updateContactDetails(context);
                        Navigator.of(context).pop();
                      },
                      child: const Text('save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Arrowback(backcolor: darkgreen),
                  const Captions(
                      captions: 'Contact Details', captionColor: darkgreen),
                ],
              ),
              Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: Alignment.bottomCenter,
                      colors: [kwhite, lightgreen]),
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(40),
                  //   topRight: Radius.circular(40),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error occurred: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        // Handle the case where the document does not exist
                        return const Center(
                          child: Text('Document not found'),
                        );
                      }

                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      var fullName = userData['fullname']?.toString() ??
                          'Provide full name ';
                      var phoneNumber = userData['phoneNumber']?.toString() ??
                          'Add phone number';
                      var houseName = userData['houseName']?.toString() ??
                          'Provide address details';
                      //var streetName = userData['streetName']?.toString() ??
                      'complete address';
                      var landmark = userData['landmark']?.toString() ??
                          'provide a landmark';

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Contact Details',
                                style:
                                    TextStyle(fontSize: 18, color: darkgreen)),
                            sheight,
                            //------------------------------contact---------------------------------------
                            ProfileEdit(
                                icons: Icons.person,
                                onpressed: () {
                                  _openEditBottomSheet(
                                      context, 'Name', fullName);
                                },
                                label: 'Name',
                                text: fullName),
                            sheight,
                            ProfileEdit(
                                icons: Icons.phone,
                                label: 'Phone number',
                                onpressed: () {
                                  _openEditBottomSheet(
                                      context, 'Phone number', phoneNumber);
                                },
                                text: phoneNumber),
                            sheight,
                            const Text('Address for Collection',
                                style:
                                    TextStyle(fontSize: 18, color: darkgreen)),
                            sheight,
                            ProfileEdit(
                                icons: Icons.house,
                                label: 'Farm/House address',
                                onpressed: () {
                                  _openEditBottomSheet(
                                      context, 'house name', houseName);
                                },
                                text: houseName),
                            sheight,
                            // ProfileEdit(
                            //     icons: Icons.streetview,
                            //     label: 'Street name',
                            //     onpressed: () {
                            //       _openEditBottomSheet(
                            //           context, 'street name', streetName);
                            //     },
                            //     text: streetName),
                            // sheight,
                            ProfileEdit(
                                icons: Icons.landscape,
                                label: 'Landmark',
                                onpressed: () {
                                  _openEditBottomSheet(
                                      context, 'landmark', landmark);
                                },
                                text: landmark),
                            sheight,
                            ProfileEdit(
                                icons: Icons.pin,
                                label: 'pincode',
                                onpressed: () {},
                                text: 'pincode'),
                            // sheight,

                            // SizedBox(height: screenHeight * 0.01),
                            // const Center(
                            //     child: Icon(
                            //   Icons.location_pin,
                            //   color: Colors.red,
                            //   size: 32,
                            // )),
                            lheight,
                            Center(
                              child: Next(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CurrentLocation(),
                                    ));
                                  },
                                  buttonText: 'Click to add location in  map',
                                  pinIcon: Icons.location_pin,
                                  buttonColor: darkgreen),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateContactDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    String fullName = formatText(fullNameController.text);
    String phoneNumber = formatText(phoneNumberController.text);
    String houseName = formatText(houseNameController.text);
    // String streetName = formatText(streetNameController.text);
    String landmark = formatText(landmarkController.text);

    var userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    if (fullName != '') {
      await userDocRef.update({
        'fullname': fullName,
      });
    } else if (phoneNumber != '') {
      await userDocRef.update({
        'phoneNumber': phoneNumber,
      });
    } else if (houseName != '') {
      await userDocRef.update({
        'houseName': houseName,
      });
    }
    // else if (streetName != '') {
    //   await userDocRef.update({
    //     "streetName": streetName,
    //   });
    // }
    else if (landmark != '') {
      await userDocRef.update({
        'landmark': landmark,
      });
    }
  }
}

String formatText(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
