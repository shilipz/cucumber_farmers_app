import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/domain/models/user_model.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/views/home/main_screens_nav.dart';
import 'package:cucumber_app/presentation/views/settings/settings.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Home extends StatelessWidget {
  final String? receiverId;
  const Home({super.key, this.receiverId});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    DateTime now = DateTime.now();
    int hour = now.hour;

    String greeting;
    if (hour >= 6 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: kwhite,
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/signin.png', fit: BoxFit.fill)),
          FutureBuilder<UserModel>(
            future: _getUserData(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("user not found"));
              } else {
                var userData = snapshot.data;
                var username = userData?.username;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.1,
                            top: screenHeight * 0.1),
                        child: WelcomeCaptions(
                            captionColor: kwhite,
                            captions: '$greeting , $username'),
                      ),
                      const MainSreensNav(),
                    ],
                  ),
                );
              }
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
                color: kwhite,
                onPressed: () {
                  log('icon pressed');
                  log('IconButton pressed - Context: $context');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ));
                },
                icon: const Icon(Icons.settings, size: 32)),
          ),
        ],
      ),
    ));
  }

  Future<UserModel> _getUserData(String? uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userData = userSnapshot.data() as Map<String, dynamic>;

    return UserModel(uid: uid, username: userData['username']);
  }

  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset('assets/6334-12291-searching.riv');
      },
    );
  }
}
