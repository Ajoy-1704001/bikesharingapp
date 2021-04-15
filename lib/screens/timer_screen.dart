import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  GlobalKey _key = GlobalKey();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
            ],
          ),
        ),
      ),
    );
  }

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
                  // todo: check korte hobe nirddisto radius e ache kina
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  await _firestore
                      .collection("vehicles")
                      .doc(barCode.of(context))
                      .update({'active': false, 'current_uid': ""});
                  int minute = StopWatchTimer.getRawMinute(
                      _stopWatchTimer.rawTime.valueWrapper.value);
                  double _bal =
                      double.parse(balance.of(context)) - (minute * 0.6);
                  await _firestore
                      .collection("Users")
                      .doc(uid.of(context))
                      .update({'balance': _bal.toString(), 'inUse': ""});
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.id, (route) => false);
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