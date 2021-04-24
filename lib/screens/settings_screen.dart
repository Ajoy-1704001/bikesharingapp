import 'package:bikesharingapp/Global/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "settings_screen";
  String name;
  String email;
  String number;
  String bkash;
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  GlobalKey<FormState> _loginStateFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _StateFormKey = new GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        backgroundColor: Color(0xFFECECEC),
        elevation: 0,
        title: Text(
          "Settings",
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
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: ListTile(
              title: Text("Change Location access"),
              onTap: () {
                Geolocator.openLocationSettings();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListTile(
              onTap: () async {
                Geolocator.openAppSettings();
              },
              title: Text("Change Permission"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 1,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Form(
              key: _loginStateFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: TextFormField(
                      initialValue: name.of(context),
                      onSaved: (input) => widget.name = input,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        hintText: "Name",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        isDense: true,
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 40, maxWidth: 60),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.verified_user_outlined),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: TextFormField(
                      initialValue: email.of(context),
                      onSaved: (input) => widget.email = input,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        isDense: true,
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 40, maxWidth: 60),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.email_outlined),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: TextFormField(
                      initialValue: mobile.of(context),
                      enabled: false,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        isDense: true,
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 40, maxWidth: 60),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.phone),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                  onPressed: () async {
                    _loginStateFormKey.currentState.save();
                    await firestore
                        .collection('Users')
                        .doc(uid.of(context))
                        .update({
                      'name': widget.name,
                      'email': widget.email
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Updated Successfully")));
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 1,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Payment Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _StateFormKey,
                    child: TextFormField(
                      validator: (input) =>
                          input.trim().length == 11 || input.trim().length == 0
                              ? null
                              : "Not a valid number",
                      initialValue: bkash.of(context),
                      onSaved: (input) => widget.bkash = input,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        labelText: "Bkash Number",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                        isDense: true,
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 40, maxWidth: 60),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.phone),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                    onPressed: () async {
                      _StateFormKey.currentState.save();
                      await firestore
                          .collection('Users')
                          .doc(uid.of(context))
                          .update({
                        'bkash': widget.bkash,
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Updated Successfully")));
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: Text(
                      "Save",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
