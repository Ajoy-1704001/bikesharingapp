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
    hello();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
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
    LocationPermission p = await _checkpermissionAndLocation();
    if (p == LocationPermission.always || p == LocationPermission.whileInUse) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    }
  }
}
