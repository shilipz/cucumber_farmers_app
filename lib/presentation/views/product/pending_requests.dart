import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingRequests extends StatelessWidget {
  const PendingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }
    final email = FirebaseAuth.instance.currentUser!.email;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kwhite,
        body: Column(
          children: [
            sheight,
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Under review',
                style: GoogleFonts.akshar(
                  textStyle: const TextStyle(color: darkgreen, fontSize: 20),
                ),
              ),
            ),
            sheight,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pending_approval')
                    .where('email', isEqualTo: email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No vegetables available.'));
                  } else {
                    var pendingApproval = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: pendingApproval.length,
                      itemBuilder: (context, index) {
                        var vegetable = pendingApproval[index];
                        var name = vegetable['name'];
                        var vegetableId = vegetable.id;

                        var price = vegetable['price'];

                        var imageUrl = vegetable['imageUrl'];

                        return Card(
                          child: ListTile(
                            leading: Container(
                              decoration: const BoxDecoration(color: kwhite),
                              width: 70,
                              height: 70,
                              child: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl)
                                  : Image.asset('assets/images.jpeg'),
                            ),
                            title: Text(name),
                            subtitle: Text('$price per Kg'),
                            trailing: IconButton(
                              onPressed: () {
                                _showEditOptions(context,
                                    vegetableId: vegetableId);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditOptions(BuildContext context, {required String vegetableId}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ListTile(
          //   leading: const Icon(Icons.edit),
          //   title: const Text('Edit Image'),
          //   onTap: () {
          //     Navigator.pop(context); // Close the bottom sheet
          //     _editImage(context, vegetableId);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Vegetable'),
            onTap: () {
              Navigator.pop(context); // Close the bottom sheet
              _removeVegetable(context, vegetableId);
            },
          ),
        ],
      );
    },
  );
}

// void _editImage(BuildContext context, String vegetableId) {
//   // Implement the logic for editing the image here
// }

void _removeVegetable(BuildContext context, String vegetableId) {
  FirebaseFirestore.instance
      .collection('pending_approval')
      .doc(vegetableId)
      .delete();
}
