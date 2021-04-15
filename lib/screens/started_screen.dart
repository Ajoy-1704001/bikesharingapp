import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  static const String id = "getStarted_screen";
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BIKESHARING",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/bikeapp.png'),
                width: 280,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, _createRoute());
                  }),
            )
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 1300));
  }
}
