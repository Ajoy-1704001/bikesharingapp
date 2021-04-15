import 'dart:async';
import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/screens/timer_screen.dart';
import 'package:bikesharingapp/widget/appbarWidget.dart';
import 'package:bikesharingapp/widget/drawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:rubber/rubber.dart';
import 'package:bikesharingapp/controller/usercontroller.dart';
import 'package:bikesharingapp/model/UserData.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bikesharingapp/Global/mapStyle.dart';
import 'package:bikesharingapp/model/LatLong.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AnimationController controller;
  GoogleMapController _controller;
  Completer<GoogleMapController> completer = Completer();
  Future data;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _myHomeState = GlobalKey<ScaffoldState>();
  Geolocator geolocator;
  LocationPermission permission;
  Position position;
  double lat;
  double lon;
  bool isPermission = false;
  BitmapDescriptor marker;
  Set<Circle> _circle = {
    Circle(
        circleId: CircleId("1"),
        center: Data.mapCenter,
        radius: 500,
        strokeWidth: 3)
  };
  Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    // _checkpermissionAndLocation();
    data = getUser();

    uid.value = _auth.currentUser.uid;
    super.initState();
    customMarker();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      data = getUser();
    });
    return FutureBuilder<DocumentSnapshot>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            balance.value = snapshot.data.data()['balance'];
            return Scaffold(
                appBar: CustomAppbar(_myHomeState),
                drawer: CustomDrawer(),
                body: GoogleMap(
                    onMapCreated: _onMapcreated,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    circles: _circle,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(23.8103, 90.4125), zoom: 15)));
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Future<DocumentSnapshot> getUser() async {
    return await _firestore
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get();
  }

  void _onMapcreated(GoogleMapController controller) {
    controller.setMapStyle(MapStyle.mapStyle);
    //_circle.add(
    //Circle(circleId: CircleId("1"), center: Data.mapCenter, radius: 200));
  }

  getVehicles() async {
    Set<Marker> list = {};
    await for (var snapshots in _firestore.collection("vehicles").snapshots()) {
      LatLong latLong = LatLong(snapshots.docs[0].data()['cordinate']);
      list.add(Marker(
        markerId: MarkerId(snapshots.docs[0].id),
        icon: marker,
        position: LatLng(latLong.geoPoint.latitude, latLong.geoPoint.longitude),
      ));
    }
    setState(() {
      this._markers = list;
    });
  }

  void customMarker() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/dot.png');
  }
}
