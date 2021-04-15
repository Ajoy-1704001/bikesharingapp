import 'dart:async';

import 'package:bikesharingapp/Global/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:rubber/rubber.dart';
import 'package:bikesharingapp/screens/timer_screen.dart';
import 'package:bikesharingapp/model/UserData.dart';

typedef void StringCallback(String val);

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final GlobalKey key;

  CustomAppbar(this.key);

  Widget build(BuildContext context) {
    String barcodeScanRes;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "BIKESHARING",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      leading: IconButton(
          iconSize: 20,
          icon: Image.asset(
            "assets/images/menu.png",
            height: 20,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          }),
      actions: [
        IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
            ),
            onPressed: () async {
              barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  "#384B4B", "Finish", true, ScanMode.QR);
              if (barcodeScanRes == '-1') {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nothing to Capture")));
              } else {
                _showContent(barcodeScanRes);
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  void _showContent(String code) {
    showDialog(
      context: key.currentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String bal = balance.of(context);
        return AlertDialog(
          title: new Text(
            'Wanna Ride?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'assets/fonts/ubuntu', color: ColorCode.mainColor),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage("assets/images/trip_dialog.png"),
                  height: 200,
                ),
                Text("Your Current Balance"),
                Text(
                  bal,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    leading: Icon(
                      Icons.fiber_manual_record_rounded,
                      color: Colors.green,
                    ),
                    title: Text("Please wear helmet",
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    leading: Icon(
                      Icons.fiber_manual_record_rounded,
                      color: Colors.green,
                    ),
                    title: Text("Make sure you have enough balance",
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 20))),
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: new Text('Start Trip', style: TextStyle(fontSize: 17)),
                  onPressed: () async {
                    barCode.value = code;
                    FirebaseFirestore _firestore = FirebaseFirestore.instance;
                    await _firestore
                        .collection("vehicles")
                        .doc(code)
                        .get()
                        .then((value) async {
                      if (await value.data()['active']) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(key.currentContext).showSnackBar(
                            SnackBar(
                                content: Text("The bike is already in use")));
                      } else {
                        await _firestore
                            .collection("vehicles")
                            .doc(code)
                            .update({
                          'active': true,
                          'current_uid': uid.of(context)
                        });
                        await _firestore
                            .collection("Users")
                            .doc(uid.of(context))
                            .update({'inUse': code});
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, TimerScreen.id);
                      }
                    });
                  },
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 20))),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: new Text('Cancel', style: TextStyle(fontSize: 17)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*void _showBottomContent() {
    showBottomSheet(
        context: key.currentContext,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Your Ride is on',
                    style: TextStyle(
                        color: ColorCode.textFieldColor,
                        fontFamily: "Ubuntu",
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.bike_scooter,
                      color: Colors.green,
                    ),
                    title:
                  ),
                ],
              ),
            ),
          );
        });
  }*/

}
