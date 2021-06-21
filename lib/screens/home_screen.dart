import 'dart:async';
import 'package:bikesharingapp/model/Tracker.dart';
import 'package:intl/intl.dart';
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
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  Timer timer;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _myHomeState = GlobalKey<ScaffoldState>();
  Geolocator geolocator;
  LocationPermission permission;
  Position position;
  double lat;
  double lon;
  bool isPermission = false;
  Tracker tracker;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
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
    email.value = snapshot.data()['email'];
    bkash.value = snapshot.data()['bkash'];
    name.value = snapshot.data()['name'];
    await downloadURLExample();
    _stream.listen((event) {
      balance.value = event.data()['balance'];
      email.value = event.data()['email'];
      bkash.value = event.data()['bkash'];
      name.value = event.data()['name'];
      print(name.of(context));
    });
  }

  Future<void> downloadURLExample() async {
    link.value = await firebase_storage.FirebaseStorage.instance
        .ref('uploads/' + uid.of(context) + '.jpg')
        .getDownloadURL();

    setState(() {});
  }

  void _onMapcreated(GoogleMapController controller) {
    try {
      controller.setMapStyle(MapStyle.mapStyle);
      setState(() {
        _circle.add(Circle(
            circleId: CircleId("1"),
            center: mapCenter.of(context),
            radius: radius.of(context),
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
    GeoPoint temp;

    /*try {
      Stream<QuerySnapshot> stream =
          _firestore.collection('vehicles').snapshots();
      stream.listen((event) {
        event.docs.forEach((element) async {
          print(element.id);
          if (!element.data()['active']) {
            GeoPoint geoPoint = element.data()['cordinate'];
            temp = geoPoint;
            print(element.data()['active']);
            print(geoPoint.latitude);
            print(element.data()['lock']);
            Marker _marker = new Marker(
              markerId: MarkerId(element.id),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: marker,
            );
            setState(() {
              _markers.add(_marker);
              print(_markers.length);
            });
          }
        });
      });
    } catch (e) {
      print("getvehicl;e" + e);
    }*/

    try {
      Stream<DocumentSnapshot> stream =
          _firestore.collection('vehicles').doc("3563").snapshots();
      stream.listen((event) {
        print(event.id);
        if (!event.data()['active']) {
          GeoPoint geoPoint = event.data()['cordinate'];
          temp = geoPoint;
          /*Marker _marker = new Marker(
            markerId: MarkerId(event.id),
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            icon: marker,
          );*/
          setState(() {
            _markers.clear();
            _markers.add(Marker(
              markerId: MarkerId(event.id),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: marker,
            ));
            print(_markers.length);
          });
        } else {
          setState(() {
            _markers.clear();
          });
        }
      });
    } catch (e) {
      print("getvehicl;e" + e);
    }
    timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      String uri =
          "https://api.prohori.com/v2/get-packet?t=${token.of(context)}&d=3563";
      http.Response response1 = await http.get(Uri.parse(uri));
      tracker = TrackerResponseFromJson(response1.body);
      print(temp.latitude);
      if ((temp.latitude ==
              double.parse(tracker.detailed_user[0].packet[0].lat)) &&
          (temp.longitude ==
              double.parse(tracker.detailed_user[0].packet[0].lon))) {
        print("This is it-------------------------------");
      } else {
        _firestore.collection("vehicles").doc("3563").update({
          'cordinate': GeoPoint(
              double.parse(tracker.detailed_user[0].packet[0].lat),
              double.parse(tracker.detailed_user[0].packet[0].lon))
        });
      }

      print(tracker.detailed_user[0].packet[0].receive_time);
      print(tracker.detailed_user[0].packet[0].lat);
      //print(tracker.detailed_user[0].packet[0].lon);
    });
  }
}
