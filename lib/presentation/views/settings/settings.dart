import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/settings/about.dart';
import 'package:cucumber_app/presentation/views/signing/login.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Arrowback(backcolor: darkgreen),
                  Captions(captionColor: darkgreen, captions: 'Settings')
                ],
              ),
              Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: Alignment.bottomCenter,
                        colors: [kwhite, lightgreen])),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.share,
                            color: darkgreen,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Share',
                                style:
                                    TextStyle(color: darkgreen, fontSize: 16),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_document,
                            color: darkgreen,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AboutScreen()));
                              },
                              child: const Text(
                                'About',
                                style:
                                    TextStyle(color: darkgreen, fontSize: 16),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: darkgreen,
                          ),
                          TextButton(
                              onPressed: () {
                                showAlertDialog(context);
                              },
                              child: const Text(
                                'Signout',
                                style:
                                    TextStyle(color: darkgreen, fontSize: 16),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign-out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Sign out'))
        ],
      ),
    );
  }
}
