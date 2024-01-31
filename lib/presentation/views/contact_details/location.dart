import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_app/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({super.key, required this.latitude, required this.longitude});
  final String latitude;
  final String longitude;

  @override
  State<Location> createState() => LocationState();
}

class LocationState extends State<Location> {
  CameraPosition? _kGooglePlex;

  @override
  void initState() {
    generatemarker();
    super.initState();
    _kGooglePlex = CameraPosition(
      target:
          LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
      zoom: 14.4746,
    );
  }

  Set<Marker> marker = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkgreen,
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        markers: marker,
        initialCameraPosition: _kGooglePlex ?? _kLake,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: darkgreen,
        onPressed: () {
          saveToFirebase(widget.latitude, widget.longitude);
        },
        label: const Text('Save Location', style: TextStyle(color: kwhite)),
      ),
    );
  }

  saveToFirebase(String latitude, String longitude) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "latitude": latitude,
      "longitude": longitude,
    });
    Navigator.of(context).pop();
  }

  void generatemarker() {
    marker.add(Marker(
      markerId: const MarkerId('1'),
      position:
          LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }
}
