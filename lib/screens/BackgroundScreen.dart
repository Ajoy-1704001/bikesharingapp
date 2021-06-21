import 'dart:async';

import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/model/Tracker.dart';
import 'package:bikesharingapp/model/user.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

class BackgroundScreen extends StatefulWidget {
  static const String id = "background";
  @override
  _BackgroundScreenState createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {
  LocationPermission permission;
  Position position;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Timer timer;
  Tracker tracker;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hello();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
          width: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotate,
            color: Colors.blue,
          )),
    ));
  }

  Future _checkpermissionAndLocation() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied ||
        await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      print(permission);
      return permission;
    } else {
      permission = await Geolocator.checkPermission();
      return permission;
    }
  }

  void hello() async {
    String url =
        "https://api.prohori.com/auth/client-login?u=sarthok&p=12345Vts&pc=pcname&o=windows&av=10.1&mb=samsumg&mm=note&ov=android";
    http.Response response = await http.get(Uri.parse(url));
    print(response.body);
    GPS gps = GPSResponseFromJson(response.body);
    token.value = gps.detailed_user.user_token_text;
    print(token.value);

    position = await Geolocator.getCurrentPosition();
    LocationPermission p = await _checkpermissionAndLocation();
    if (p == LocationPermission.always || p == LocationPermission.whileInUse) {
      var snapshot = await firestore.collection('map').doc("1").get();
      mapCenter.value = LatLng(double.parse(snapshot.data()['lat']),
          double.parse(snapshot.data()['lon']));
      radius.value = double.parse(snapshot.data()['radius']);
      if (snapshot.exists) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (route) => false);
      }
    }
  }
}
