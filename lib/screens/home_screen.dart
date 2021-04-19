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
import 'package:firebase_database/firebase_database.dart';

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
  DatabaseReference _reference = FirebaseDatabase.instance.reference();
  Set<Circle> _circle = {};
  Set<Marker> _markers = {};
  static final CameraPosition _initialCamera =
      CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 13);

  getData() {
    getUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _checkpermissionAndLocation();
    getData();
    customMarker();
    uid.value = _auth.currentUser.uid;
    super.initState();
  }

  void customMarker() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/cycle_icon.png');
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
    Stream<DocumentSnapshot> _stream =
        _firestore.collection('Users').doc(_auth.currentUser.uid).snapshots();
    balance.value = snapshot.data()['balance'];
    mobile.value = snapshot.data()['phone'];
    _stream.listen((event) {
      balance.value = event.data()['balance'];
    });
  }

  void _onMapcreated(GoogleMapController controller) {
    try {
      controller.setMapStyle(MapStyle.mapStyle);
      setState(() {
        _circle.add(Circle(
            circleId: CircleId("1"),
            center: Data.mapCenter,
            radius: Data.radius,
            strokeWidth: 3));
        getVehicles();
      });
    } catch (e) {
      print("on create" + e);
    }
  }

  getVehicles() async {
    Set<Marker> list = {};
    /*CollectionReference ref = _firestore.collection('vehicles');
    await ref.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        //print(value.docs[i].data()["cordinate"].latitude);
        if (!value.docs[i].data()['active']) {
          GeoPoint geoPoint = value.docs[i].data()['cordinate'];
          Marker _marker = new Marker(
            markerId: MarkerId(value.docs[i].id),
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            icon: marker,
          );
          list.add(_marker);
        }
      }
    });*/
    try {
      Stream<QuerySnapshot> stream =
          _firestore.collection('vehicles').snapshots();
      stream.listen((event) {
        event.docs.forEach((element) {
          print(element.id);
          if (!element.data()['active']) {
            GeoPoint geoPoint = element.data()['cordinate'];
            Marker _marker = new Marker(
              markerId: MarkerId(element.id),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: marker,
            );
            list.add(_marker);
          }
        });
        setState(() {
          this._markers = list;
          print(_markers.length);
        });
      });
    } catch (e) {
      print("getvehicl;e" + e);
    }
  }
}
