import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundScreen extends StatefulWidget {
  static const String id = "background";
  @override
  _BackgroundScreenState createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {
  LocationPermission permission;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkpermissionAndLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkpermissionAndLocation() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    } else {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    }
  }
}
