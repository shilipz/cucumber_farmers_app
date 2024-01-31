import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHistory extends StatelessWidget {
  const SalesHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kwhite, lightgreen])),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: kwhite,
                title: const Row(
                  children: [
                    Arrowback(backcolor: darkgreen),
                    Captions(captionColor: darkgreen, captions: 'Sales so far')
                  ],
                ),
                automaticallyImplyLeading: false,
                expandedHeight: 100.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          kwhite,
                          Color.fromARGB(237, 227, 251, 224)
                        ])),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('collected_vegetables')
                    .orderBy('collection_date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('Something went wrong'),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('No sales so far'),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var vegetable = snapshot.data!.docs[index];
                        var vegetableName =
                            vegetable['vegetable_name'] ?? 'N/A';
                        var quantity = vegetable['quantity'] ?? 0;
                        var collectionDate =
                            vegetable['collection_date'] as Timestamp;
                        var formattedDate = DateFormat('dd MMMM').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                collectionDate.seconds * 1000));

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              title: Text(
                                vegetableName,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(quantity.toString()),
                            ),
                          ],
                        );
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
