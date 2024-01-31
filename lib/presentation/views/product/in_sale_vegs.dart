import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InSale extends StatelessWidget {
  const InSale({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          sheight,
          Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Currently in sales',
                style: GoogleFonts.akshar(
                    textStyle: const TextStyle(color: darkgreen, fontSize: 20)),
              )),
          lheight,
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('selling_vegetables')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vegetables in sales.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var vegetable = snapshot.data!.docs[index];
                    var vegetableId = vegetable.id; // Document ID
                    var vegetableName = vegetable['vegetable_name'] ?? 'N/A';
                    var imageUrl = vegetable['imageURL'] ?? false;
                    var quantity = vegetable['quantity'] ?? 0;
                    var collectionDate = vegetable['collection_date'];
                    DateTime formattedDate;

                    if (collectionDate is Timestamp) {
                      formattedDate = DateTime.fromMillisecondsSinceEpoch(
                        collectionDate.seconds * 1000,
                      );
                    } else if (collectionDate is String) {
                      // Handle the case when 'collection_date' is a String
                      try {
                        formattedDate = DateFormat('dd MMMM', 'en_US')
                            .parse(collectionDate);
                      } catch (e) {
                        // Handle parsing error, e.g., provide a default value
                        formattedDate = DateTime.now();
                      }
                    } else {
                      // Handle other cases if needed
                      formattedDate = DateTime.now(); // Provide a default value
                    }

                    var formattedDateString =
                        DateFormat('dd MMMM').format(formattedDate);

                    return ListTile(
                        title: Text(
                          vegetableName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        leading: Container(
                            decoration: const BoxDecoration(color: kwhite),
                            width: 70,
                            height: 70,
                            child: Image.network(imageUrl)),
                        subtitle: Text(
                            ' \nQuantity:$quantity  \nReady for $formattedDateString'),
                        trailing: IconButton(
                          onPressed: () {
                            _showEditDialog(context, vegetableId, vegetableName,
                                quantity, formattedDateString, () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: darkgreen,
                                      content:
                                          Text('Vegetable details updated.')));
                            }, () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: darkgreen,
                                      content: Text(
                                          'Vegetable removed from next sale.')));
                            }, imageUrl);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

void _showEditDialog(
    BuildContext context,
    String vegetableId,
    String currentVegetableName,
    int currentQuantity,
    String currentCollectionDate,
    VoidCallback onEdit,
    VoidCallback onRemove,
    String imageUrl) {
  TextEditingController nameController =
      TextEditingController(text: currentVegetableName);
  TextEditingController quantityController =
      TextEditingController(text: currentQuantity.toString());
  TextEditingController collectionDatecontroller =
      TextEditingController(text: currentCollectionDate.toString());
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kwhite,
        title: const Text('Edit Vegetable', style: TextStyle(color: darkgreen)),
        content: Column(
          children: [
            Container(width: 180, height: 180, child: Image.network(imageUrl)),
            SizedBox(height: 32),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Vegetable Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: collectionDatecontroller,
              decoration: const InputDecoration(labelText: 'Collection Date'),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: darkgreen),
            ),
          ),
          TextButton(
            onPressed: () {
              // Perform the edit action
              _editVegetable(vegetableId, nameController.text,
                  int.parse(quantityController.text), currentCollectionDate);
              onEdit();
              Navigator.pop(context);
            },
            child: const Text('Update', style: TextStyle(color: darkgreen)),
          ),
          TextButton(
            onPressed: () {
              _removeVegetable(vegetableId);
              onRemove();
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: darkgreen)),
          ),
        ],
      );
    },
  );
}

void _editVegetable(String vegetableId, String newName, int newQuantity,
    var newCollectionDate) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('selling_vegetables')
      .doc(vegetableId)
      .update({
    'vegetable_name': newName,
    'quantity': newQuantity,
    'collection_date': newCollectionDate
    // Add more fields if needed
  });
}

void _removeVegetable(String vegetableId) {
  // Remove the vegetable from Firestore using the provided vegetableId
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('selling_vegetables')
      .doc(vegetableId)
      .delete();
}
