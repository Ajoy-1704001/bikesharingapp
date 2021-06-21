import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikesharingapp/screens/BackgroundScreen.dart';

class OtpScreen extends StatefulWidget {
  static const String id = "otp_screen";
  final String _number;

  OtpScreen(this._number);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _pinPutController = TextEditingController();
  String _num;
  String _verificationCode;
  int _resend;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _num = widget._number;
    _verifyNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black54,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                  child: Container(
                    width: 200,
                    child: Text(
                      'Verify Your Mobile Number',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: ColorCode.mainColor,
                          fontFamily: 'Ubuntu'),
                    ),
                  ),
                ),
              ),
              Text(
                "Enter your OTP code here",
                style: TextStyle(color: Colors.black38, fontSize: 17),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: PinPut(
                  autofocus: true,
                  fieldsCount: 6,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  separator: SizedBox(
                    width: 1,
                  ),
                  controller: _pinPutController,
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(.5),
                    ),
                  ),
                  onSubmit: (pin) async {
                    /*try {
                      await _auth
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        CollectionReference _ref = _firestore.collection("Users");
                        print(_auth.currentUser.uid);
                        await _ref
                            .doc(_auth.currentUser.uid)
                            .get()
                            .then((_value) {
                          print(_value.exists);
                          if (_value.exists) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, HomeScreen.id, (route) => false);
                          } else {
                            _addUser(_auth.currentUser.uid);
                            Navigator.pushNamedAndRemoveUntil(
                                context, HomeScreen.id, (route) => false);
                          }
                        });
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      print(e);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
                    }*/
                    await _auth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      CollectionReference _ref = _firestore.collection("Users");
                      print(_auth.currentUser.uid);
                      try {
                        await _ref
                            .doc(_auth.currentUser.uid)
                            .get()
                            .then((_value) {
                          if (_value.exists) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, BackgroundScreen.id, (route) => false);
                          } else {
                            _addUser(_auth.currentUser.uid);
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, BackgroundScreen.id, (route) => false);
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Didn't you receive any code?",
                style: TextStyle(color: Colors.black38, fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+88$_num",
                      codeSent: (String verificationId, int resendToken) {
                        setState(() {
                          _verificationCode = verificationId;
                        });
                      },
                      forceResendingToken: _resend);
                },
                child: Text(
                  "RESEND NEW CODE",
                  style: TextStyle(
                      color: ColorCode.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _verifyNumber() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+88$_num",
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential).then((value) async {
              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference _ref = firestore.collection("Users");
              _ref.doc(value.user.uid).get().then((_value) {
                if (_value.exists) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, BackgroundScreen.id, (route) => false);
                } else {
                  _addUser(value.user.uid);
                  Navigator.pushNamedAndRemoveUntil(
                      context, BackgroundScreen.id, (route) => false);
                }
              });
              //Navigator.pushNamedAndRemoveUntil(
              //context, HomeScreen.id, (route) => false);
            });
          } catch (e) {
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Network error, Try again")));
          }
          //Navigator.pushReplacementNamed(context, HomeScreen.id));
        },
        verificationFailed: (FirebaseAuthException e) {
          FocusScope.of(context).unfocus();
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Invalid Phone Number")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Something wrong occurred")));
          }
        },
        codeSent: (String verificationId, int resendToken) {
          setState(() {
            _verificationCode = verificationId;
            _resend = resendToken;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 40));
  }

  _addUser(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String balance = "20.00";
    CollectionReference _reference = firestore.collection("Users");
    await _reference.doc(uid).set({
      'phone': _num,
      'balance': balance,
      'inUse': "",
      'name': "",
      'bkash': "",
      'email': ''
    });
  }
}
