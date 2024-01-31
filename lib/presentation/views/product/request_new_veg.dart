import 'dart:developer';
import 'dart:io';

import 'package:cucumber_app/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_app/presentation/widgets/signing_widgets.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RequestNewVeg extends StatefulWidget {
  const RequestNewVeg({Key? key}) : super(key: key);

  @override
  State<RequestNewVeg> createState() => _ApprovalsState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController priceController = TextEditingController();

class _ApprovalsState extends State<RequestNewVeg> {
  File? _image;
  UploadTask? uploadTask;
  Future _getImage(ImageSource source) async {
    final PickedFile = await ImagePicker().pickImage(source: source);

    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.clear();
    priceController.clear();
    super.dispose();
  }

  Future uploadFile() async {
    final path = 'files/$_image';
    final file = File(_image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

  String formatText(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Arrowback(backcolor: darkgreen),
                    Captions(
                        captionColor: darkgreen, captions: 'Add new Veggie'),
                  ],
                ),
                lheight,
                GestureDetector(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : null, // Display the selected image if available
                    child: _image == null
                        ? const Icon(Icons.image, color: Colors.white)
                        : null,
                  ),
                ),
                lheight,
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Vegetable Name'),
                ),
                lheight,
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Expected Price'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                      uploadFile();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Vegetable requested for approval.'),
                      ));
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(lightgreen),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 18, color: kwhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    String name = formatText(nameController.text);
    String price = priceController.text;

    User? user = FirebaseAuth.instance.currentUser;

    final pending =
        FirebaseFirestore.instance.collection('pending_approval').doc();
    CollectionReference pendingRef =
        FirebaseFirestore.instance.collection('pending_approval');

    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference vegRef =
        FirebaseFirestore.instance.collection('vegetables');
    Future uploadFile() async {
      final path = 'files/${_image!.path.split('/').last}';
      final file = File(_image!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        final urlDownload = await ref.getDownloadURL();
        log('Download Link: $urlDownload');

        // Update the Firestore document with the image URL
        await pending.update({'imageUrl': urlDownload});
      });
    }

    vegRef
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot vegQuerySnapshot) async {
      if (vegQuerySnapshot.docs.isNotEmpty) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('$name is already available for sale')));
      } else {
        QuerySnapshot pendingQuerySnapshot =
            await pendingRef.where('name', isEqualTo: name).get();
        if (pendingQuerySnapshot.docs.isNotEmpty) {
          // ignore: use_build_context_synchronously
          return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text('This vegetable is already under review')));
        } else {
          await pending.set({
            'name': name,
            'price': double.parse(price),
            'status': 'pending',
            'id': pending.id,
            'email': email,
            'username': user!.displayName,
            'imageUrl': '',
          });
          await uploadFile();
          nameController.clear();
          priceController.clear();
          _image = null;
          log("3");
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: darkgreen,
              content: Text('Vegetable requested for approval.')));
        }
      }
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a photo'),
              onTap: () {
                _getImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from gallery'),
              onTap: () {
                _getImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
