import 'dart:ffi';

import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  String number;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  GlobalKey<FormState> _loginStateFormKey = new GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/bikeapp.png'),
                    width: 150,
                  ),
                ),
              ),
              SlideTransition(
                position: offset,
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: ColorCode.textFieldColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You'll receive a 4 digit code for Phone Number Verification",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _loginStateFormKey,
                            child: TextFormField(
                              validator: (input) => input.trim().length != 11
                                  ? "Not a valid number"
                                  : null,
                              onSaved: (input) => widget.number = input,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 13),
                                isDense: true,
                                prefixIconConstraints:
                                    BoxConstraints(maxHeight: 40, maxWidth: 60),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Image.asset(
                                    'assets/images/bd.png',
                                  ),
                                ),
                                prefix: Text("+88"),
                                labelText: 'Mobile Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(double.infinity, 50))),
                            child: Text(
                              "Send OTP",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "By providing my phone number, I agree & accept the Terms of Service and Privacy policy in use of the app",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_loginStateFormKey.currentState.validate()) {
      _loginStateFormKey.currentState.save();
      Navigator.push(context, _createRoute());
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpScreen(widget.number),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 800));
  }
}
