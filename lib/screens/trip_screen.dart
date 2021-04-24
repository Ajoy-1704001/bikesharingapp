import 'package:bikesharingapp/Global/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          return Column(
            children: [
              ListTile(
                  // Access the fields as defined in FireStore
                  title: Text(
                    snapshot.data.get('Trips')[index]['date'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text(
                    "Cycle Code: ${snapshot.data.get('Trips')[index]['code']}",
                  ),
                  trailing: SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        Text('Cost'),
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
                  )),
              Divider(
                thickness: 1,
              )
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
      return CircularProgressIndicator();
    }
  }
}
