import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  static const String id = "support_screen";
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: Text(
          "Help & Support",
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
      body: Stack(
        children: [
          Image.asset("assets/images/dashboard.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "For any kind of support"
                    ", Please contact us",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.email_rounded,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                      Expanded(
                          child: Text("Bikesharing@gmail.com",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end)),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                      Expanded(
                          child: Text(
                        "+990223919",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                      Expanded(
                          child: Text(
                        "120, Tejgaon Industrial Area, Dhaka",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      )),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
