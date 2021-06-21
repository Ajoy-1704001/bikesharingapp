import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_value/shared_value.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Data {
  static String qrData;
}

final SharedValue<String> uid = SharedValue(value: "");
final SharedValue<String> balance = SharedValue(value: "0.0");
final SharedValue<String> barCode = SharedValue(value: "");
final SharedValue<String> mobile = SharedValue(value: "");
final SharedValue<String> name = SharedValue(value: "");
final SharedValue<String> email = SharedValue(value: "");
final SharedValue<String> bkash = SharedValue(value: "");

final SharedValue<LatLng> mapCenter = SharedValue(value: LatLng(0, 0));
final SharedValue<double> radius = SharedValue(value: 2000.0);

final SharedValue<String> token = SharedValue(value: "");
final SharedValue<String> link = SharedValue(value: "");
