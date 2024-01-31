// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/presentation/views/payment/payment.dart';
import 'package:cucumber_app/presentation/views/product/products_info.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaleItem extends StatelessWidget {
  final String name;
  final int price;
  final int? quantity;
  final String imageUrl;

  const SaleItem({
    super.key,
    required this.name,
    required this.price,
    this.quantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          decoration: const BoxDecoration(color: kwhite),
          width: 70,
          height: 70,
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl) // Load image from URL
              : Image.asset('assets/images.jpeg'),
        ),
        title: Text(name),
        subtitle: Text(' Rs.$price per Kg'),
        trailing: ElevatedButton(
          onPressed: () async {
            bool hasPaymentSubcollection = await checkPaymentSubcollection();
            if (hasPaymentSubcollection) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetails(
                  vegetablePrice: price,
                  vegetableName: name,
                  imageURL: imageUrl,
                ),
              ));
            } else {
              showAlertDialog(context);
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(homeorange),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          child: const Text('Add to Sale', style: TextStyle(color: kwhite)),
        ),
      ),
    );
  }

  Future<bool> checkPaymentSubcollection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the reference to the user's document
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final check = userDoc.data() as Map<String, dynamic>;
      if (check['ifsc'] == null) {
        return false;
      }
    }
    return true;
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kwhite,
        title: const Text('Payment details pending'),
        content:
            const Text('Provide your bank details before proceeding to sales'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Payment()),
                );
              },
              child: const Text('Go to payment screen'))
        ],
      ),
    );
  }
}
