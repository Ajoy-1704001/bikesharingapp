import 'dart:async';

import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/Global/mapStyle.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TimerScreen extends StatefulWidget {
  static const String id = "timer_screen";

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<DocumentSnapshot> data;
  GoogleMapController _controller;
  Completer<GoogleMapController> completer = Completer();
  Position position;
  GlobalKey _key = GlobalKey();
  static final CameraPosition _initialCamera =
      CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 13);
  Set<Circle> _circle = {};
  GlobalKey<ScaffoldState> _keystate = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _stopWatchTimer.dispose();
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
      });
    } catch (e) {
      print("on create" + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: _keystate,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    padding: EdgeInsets.all(15),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _showContent();
                      });
                    }),
              ),
              Expanded(
                child: GoogleMap(
                    onMapCreated: _onMapcreated,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    circles: _circle,
                    initialCameraPosition: _initialCamera),
              )
            ],
          ),
        ),
        bottomSheet: Container(
            color: Colors.grey.shade200,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                title: FutureBuilder(
                    future: _firestore
                        .collection("vehicles")
                        .doc(barCode.of(context))
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Text(
                              snapshot.data.data()['lock'],
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(" (Unlock Code)")
                          ],
                        );
                      } else {
                        return SizedBox(
                            width: 20,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              color: Colors.blue,
                            ));
                      }
                    }),
                subtitle: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.valueWrapper.value,
                    builder: (context, snapshot) {
                      final value = snapshot.data;
                      final displayTime = StopWatchTimer.getDisplayTime(value);
                      return Text(
                        displayTime,
                        key: _key,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Ubuntu",
                            fontSize: 18,
                            color: ColorCode.mainColor),
                      );
                    }),
                trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showContent();
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: Text(
                      "Lock",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            )),
      ),
    );
  }

  /*

Text(
                  "Unlock Code",
                  style: TextStyle(fontSize: 20),
  FutureBuilder(
                    future: _firestore
                        .collection("vehicles")
                        .doc(barCode.of(context))
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.data()['lock'],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return SizedBox(
                            width: 40,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              color: Colors.blue,
                            ));
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/timer.png",
                          width: 190,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData:
                                _stopWatchTimer.rawTime.valueWrapper.value,
                            builder: (context, snapshot) {
                              final value = snapshot.data;
                              final displayTime =
                                  StopWatchTimer.getDisplayTime(value);
                              return Text(
                                displayTime,
                                key: _key,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Ubuntu",
                                    fontSize: 30,
                                    color: ColorCode.mainColor),
                              );
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showContent();
                              });
                            },
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(150, 40)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            child: Text(
                              "Lock",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                )
   */

  void _showContent() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String bal = balance.of(context);
        return AlertDialog(
          title: Text(
            "Do you want to lock the bike?",
            style: TextStyle(
                color: ColorCode.textFieldColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Ubuntu"),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            TextButton(
                onPressed: () async {
                  position = await Geolocator.getCurrentPosition();
                  double distance = Geolocator.distanceBetween(
                      mapCenter.of(context).latitude,
                      mapCenter.of(context).longitude,
                      position.latitude,
                      position.longitude);
                  print(distance);
                  if (distance > radius.of(context)) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(_keystate.currentContext).showSnackBar(
                        SnackBar(content: Text("Please park inside the zone")));
                  } else {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    await _firestore
                        .collection("vehicles")
                        .doc(barCode.of(context))
                        .update(
                            {'active': false, 'current_uid': "", 'mobile': ""});
                    int minute = StopWatchTimer.getRawMinute(
                        _stopWatchTimer.rawTime.valueWrapper.value);
                    double _bal =
                        double.parse(balance.of(context)) - (minute * 0.6);
                    double cost = minute * 0.6;
                    String formattedDateTime =
                        DateFormat('yyyy-MM-dd \n kk:mm:ss')
                            .format(DateTime.now())
                            .toString();
                    await _firestore
                        .collection("Users")
                        .doc(uid.of(context))
                        .update({
                      'balance': _bal.toString(),
                      'inUse': "",
                      'Trips': FieldValue.arrayUnion([
                        {
                          'cost': cost.toString(),
                          'date': formattedDateTime,
                          'code': barCode.of(context)
                        }
                      ])
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.id, (route) => false);
                  }
                },
                child: Text("Lock",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }
}
