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
  Set<Circle> _circle = {};
  Set<Marker> _markers = {};
  static final CameraPosition _initialCamera =
      CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 15);

  getData() {
    getUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _checkpermissionAndLocation();
    getData();

    uid.value = _auth.currentUser.uid;
    super.initState();
    customMarker();
  }

  @override
  Widget build(BuildContext context) {
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
            initialCameraPosition: _initialCamera));
  }

  getUser() async {
    var snapshot =
        await _firestore.collection('Users').doc(_auth.currentUser.uid).get();
    balance.value = snapshot.data()['balance'];
    print(balance.of(context));
  }

  void _onMapcreated(GoogleMapController controller) {
    controller.setMapStyle(MapStyle.mapStyle);
    setState(() {
      _circle.add(Circle(
          circleId: CircleId("1"),
          center: Data.mapCenter,
          radius: 500,
          strokeWidth: 3));

      _markers.add(Marker(
        markerId: MarkerId("Hello1"),
        icon: marker,
        position: LatLng(22.939655, 91.284065),
      ));
    });
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
