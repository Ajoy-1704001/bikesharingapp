import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bikesharingapp/screens/bkash_screen.dart';

class RechargeScreen extends StatefulWidget {
  static const String id = "recharge_screen";
  String amount;
  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  GlobalKey<FormState> _AmountStateFormKey = new GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        backgroundColor: Color(0xFFECECEC),
        elevation: 0,
        title: Text(
          "Balance",
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please enter amount for recharge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: ColorCode.textFieldColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/taka.png',
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          child: Form(
                            key: _AmountStateFormKey,
                            child: TextFormField(
                              autofocus: true,
                              validator: (input) => input.trim().length == 0 ||
                                      int.parse(input) == 0
                                  ? "Not a valid number"
                                  : null,
                              onSaved: (input) => widget.amount = input,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              decoration: InputDecoration(
                                hintText: "0.00",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 50))),
                      child: Text(
                        "Procced",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (_AmountStateFormKey.currentState.validate()) {
      _AmountStateFormKey.currentState.save();
      /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => (BkashScreen(widget.amount))));*/
      double bal =
          double.parse(balance.of(context)) + double.parse(widget.amount);
      await firestore
          .collection('Users')
          .doc(uid.of(context))
          .update({'balance': bal.toString()});
      _AmountStateFormKey.currentState.reset();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Recharge Successful")));
    }
  }
}
