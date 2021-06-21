import 'package:bikesharingapp/Global/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TripScreen extends StatefulWidget {
  static const String id = 'trip_screen';
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  FirebaseFirestore firestore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        backgroundColor: Color(0xFFECECEC),
        elevation: 0,
        title: Text(
          "My Trips",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 20,
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder(
          future: firestore.collection('Users').doc(uid.of(context)).get(),
          builder: buildUserList,
        ),
      ),
    );
  }

  Widget buildUserList(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: snapshot.data.get('Trips').length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        snapshot.data.get('Trips')[index]['date'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${snapshot.data.get('Trips')[index]['code']}",
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        thickness: 1,
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Text(''),
                      Row(
                        children: [
                          Text(
                            "-${snapshot.data.get('Trips')[index]['cost']}",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Image.asset(
                            'assets/images/taka.png',
                            width: 20,
                            height: 14,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No users found."),
      );
    } else {
      // Still loading
      return SizedBox(
          width: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotate,
            color: Colors.blue,
          ));
    }
  }
}
