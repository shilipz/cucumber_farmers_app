import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentProfile extends StatelessWidget {
  PaymentProfile({super.key});
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  String holdersName = '';
  String accountNum = '';
  String ifscCode = '';

  void _openEditBottomSheet(
      BuildContext context, String field, String initialValue) {
    TextEditingController controller;

    if (field == 'accountName') {
      controller = accountNameController..text = initialValue;
    } else if (field == 'accountNumber') {
      controller = accountNumberController..text = initialValue;
    } else if (field == 'ifsc') {
      controller = ifscController..text = initialValue;
    } else {
      controller = TextEditingController()..text = 'hellooo';
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
                          if (field == 'accountName') {
                            accountNameController.text = controller.text;
                          } else if (field == 'accountNumber') {
                            accountNumberController.text = controller.text;
                          } else if (field == 'ifsc') {
                            ifscController.text = controller.text;
                          }
                        });

                        updatePaymentDetails(context);
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                children: [
                  Arrowback(backcolor: darkgreen),
                  Captions(
                      captions: 'Payment Information', captionColor: darkgreen),
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
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.08, left: 20),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
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
                        return const Center(
                          child: Text('Document not found'),
                        );
                      }
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      holdersName =
                          userData['accountName']?.toString() ?? 'N/A';
                      accountNum =
                          userData['accountNumber']?.toString() ?? 'N/A';
                      ifscCode = userData['ifsc']?.toString() ?? 'N/A';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bank Details",
                              style: TextStyle(fontSize: 18, color: darkgreen)),
                          sheight,
                          sheight,
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //-----------title
                                const Text("Account holder's Name",
                                    style: TextStyle(color: Colors.grey)),
                                sheight,
                                Text(
                                  holdersName,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  _openEditBottomSheet(
                                      context, 'accountName', holdersName);
                                },
                                icon: const Icon(Icons.edit)),
                          ),
                          sheight,
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Account Number",
                                    style: TextStyle(color: Colors.grey)),
                                sheight,
                                Text(
                                  accountNum,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  _openEditBottomSheet(
                                      context, 'accountNumber', accountNum);
                                },
                                icon: const Icon(Icons.edit)),
                          ),
                          sheight,
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("IFSC Code",
                                    style: TextStyle(color: Colors.grey)),
                                sheight,
                                Text(ifscCode,
                                    style: const TextStyle(fontSize: 22))
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  _openEditBottomSheet(
                                      context, 'ifsc', ifscCode);
                                },
                                icon: const Icon(Icons.edit)),
                          ),
                          const SizedBox(height: 34),
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
                          lheight,
                          lheight,
                          lheight
                        ],
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

  Future<void> updatePaymentDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    String accountName = formatText(accountNameController.text);
    String accountNumber = formatText(accountNumberController.text);
    String ifscNumber = formatText(ifscController.text);

    var userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    if (accountName != '') {
      await userDocRef.update({
        'accountName': accountName,
      });
    } else if (accountNumber != '') {
      await userDocRef.update({
        'accountNumber': accountNumber,
      });
    } else if (ifscNumber != '') {
      await userDocRef.update({
        'ifsc': ifscNumber,
      });
    }
  }

  String formatText(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
