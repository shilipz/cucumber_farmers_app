// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/main.dart';
import 'package:cucumber_app/presentation/presentation_logic/quantity_button/quantity_button_bloc.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/sales_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class ProductDetails extends StatefulWidget {
  final String vegetableName;
  final int vegetablePrice;
  final int? quantity;
  final String imageURL;
  // final DateTime collectionDate;
  const ProductDetails({
    super.key,
    required this.vegetableName,
    required this.vegetablePrice,
    this.quantity,
    required this.imageURL,
    // required this.collectionDate
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DateTime today = DateTime.now();

  final QuantityButtonBloc quantityButtonBloc = QuantityButtonBloc();
  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = today;
    return SafeArea(
      child: Scaffold(
        body: Container(
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
            child: Column(
              children: [
                // Image.asset('assets/sale info.png', fit: BoxFit.cover),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Arrowback(backcolor: darkgreen),
                      Captions(
                          captions: 'Tell us  about your Sales',
                          captionColor: darkgreen),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.04, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.vegetableName,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              color: darkgreen)),
                      sheight,
                      Row(
                        children: [
                          const Text("Today's Price", style: commonText),
                          kwidth,
                          SalesContainer(saleText: "${widget.vegetablePrice}"),
                          kwidth,
                          const Text("per Kg ", style: commonText),
                        ],
                      ),
                      const Text('(for successful quality analysis)'),
                      sheight,
                      Row(
                        children: [
                          const Text('Quantity', style: commonText),
                          kwidth,
                          QuantityButton(
                              onpressed: () {
                                BlocProvider.of<QuantityButtonBloc>(context)
                                    .add(DecreaseQuantity());
                              },
                              quantityIcon: Icons.remove),
                          kwidth,
                          BlocBuilder<QuantityButtonBloc, QuantityButtonState>(
                            builder: (context, state) {
                              return SalesContainer(
                                  saleText: state.quantity.toString());
                            },
                          ),
                          kwidth,
                          QuantityButton(
                              onpressed: () {
                                BlocProvider.of<QuantityButtonBloc>(context)
                                    .add(IncreaseQuantity());
                              },
                              quantityIcon: Icons.add),
                        ],
                      ),
                      lheight,
                      const Center(
                          child: Text('pick a date of collection from calendar',
                              style: commonText)),
                      lheight,
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: kwhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TableCalendar(
                              selectedDayPredicate: (day) {
                                // Use the _selectedDay variable to highlight the selected day
                                return isSameDay(today, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                // Update the _selectedDay variable when a day is selected
                                setState(() {
                                  today = selectedDay;
                                });
                              },
                              rowHeight: 35,
                              focusedDay: today,
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14)),
                        ),
                      ),
                      sheight,
                      Center(
                        child: SizedBox(
                          // width: 90,
                          // height: 60,
                          child: BlocBuilder<QuantityButtonBloc,
                              QuantityButtonState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  _addVegetableToFirestore(
                                      context,
                                      widget.vegetableName,
                                      widget.vegetablePrice,
                                      selectedDay,
                                      state.quantity,
                                      widget.imageURL);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kwhite),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ))),
                                child: const Text(
                                  'Done',
                                  style:
                                      TextStyle(fontSize: 18, color: darkgreen),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _addVegetableToFirestore(
    BuildContext context,
    String vegetableName,
    int vegetablePrice,
    DateTime selectedDay,
    int quantity,
    String imageURL) async {
  // Get the current user
  log('collection created');
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DateTime today = DateTime.now();

    if (selectedDay.isBefore(today) || selectedDay.isAtSameMomentAs(today)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a date after today.'),
      ));
      return;
    } else {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      DocumentReference userDocument = users.doc(user.uid);

      // Check if the vegetable with the same name and collection date already exists
      QuerySnapshot existingVegetables = await userDocument
          .collection('selling_vegetables')
          .where('vegetable_name', isEqualTo: vegetableName)
          .where('collection_date', isEqualTo: selectedDay)
          .get();

      if (existingVegetables.docs.isNotEmpty) {
        // If the vegetable already exists, display a SnackBar and return
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('This vegetable is already added for the selected date.'),
          ),
        );
        return;
      }
      await userDocument.collection('selling_vegetables').add({
        'vegetable_name': vegetableName,
        'isOnSale': false,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
        'collection_date': selectedDay,
        'vegPrice': vegetablePrice,
        'imageURL': imageURL
      });
      final email = FirebaseAuth.instance.currentUser!.email;
      FirebaseFirestore.instance.collection('insales').doc().set({
        'vegetable_name': vegetableName,
        'isOnSale': false,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
        'collection_date': selectedDay,
        'email': email,
        'username': user.displayName,
        'vegPrice': vegetablePrice,
        'imageURL': imageURL
      });
// FirebaseFirestore.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vegetable added to your next sale.'),
      ));
      Navigator.of(context).pop();
    }
  }
  return null;
}
