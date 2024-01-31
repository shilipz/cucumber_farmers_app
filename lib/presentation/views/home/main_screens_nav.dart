// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/presentation/views/chat/chat_screen.dart';
import 'package:cucumber_app/presentation/views/contact_details/contact_profile.dart';
import 'package:cucumber_app/presentation/views/home/home_screen_widget.dart';
import 'package:cucumber_app/presentation/views/payment/payment.dart';
import 'package:cucumber_app/presentation/views/payment/payment_profile.dart';
import 'package:cucumber_app/presentation/views/product/product_homescreen.dart';
import 'package:cucumber_app/presentation/views/sales/sales_history.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainSreensNav extends StatelessWidget {
  const MainSreensNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const adminId = 'CxAvaCCbfQWkYJAADFogtJNbL1t1';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductsHomescreen())),
              child: const HomeContainer(
                title: 'Product Selection',
                subtitle: 'Add products for your next sale',
              )),
          sheight,
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactProfile(),
                ));
              },
              child: const HomeContainer(
                title: 'Contact Details',
                subtitle: 'Add/update collection address',
              )),
          sheight,
          InkWell(
              onTap: () async {
                bool hasPaymentSubcollection =
                    await checkPaymentSubcollection();
                if (hasPaymentSubcollection) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentProfile(),
                  ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Payment(),
                  ));
                }
              },
              child: const HomeContainer(
                title: 'Payment Details',
                subtitle: 'Add/edit payment profile',
              )),
          sheight,
          InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SalesHistory(),
                  )),
              child: const HomeContainer(
                title: 'Sales History',
                subtitle: 'See previous sales history',
              )),
          sheight,
          InkWell(
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            const ChatScreen(adminId: adminId)),
                  ),
              child: const HomeContainer(
                title: 'Chat Support',
                subtitle: 'Talk to our customer executive',
              )),
          lheight,
          lheight,
          lheight,
          lheight
        ],
      ),
    );
  }

  Future<bool> checkPaymentSubcollection() async {
    log('payment');
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the reference to the user's document
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      log('payment1');
      // Check if the "payment" subcollection exists
      var paymentSubcollection = await userDoc.get();
      return paymentSubcollection.exists;
    }
    log('payment2');
    return false;
  }
}
