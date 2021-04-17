import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_value/shared_value.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Data {
  static String qrData;
  static LatLng mapCenter = LatLng(23.8103, 90.4125);
  static double radius = 2000;
}

final SharedValue<String> uid = SharedValue(value: "");
final SharedValue<String> balance = SharedValue(value: "0.0");
final SharedValue<String> barCode = SharedValue(value: "");
final SharedValue<String> mobile = SharedValue(value: "");
