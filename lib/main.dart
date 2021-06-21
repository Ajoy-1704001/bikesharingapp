import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:bikesharingapp/screens/login_screen.dart';
import 'package:bikesharingapp/screens/support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:bikesharingapp/screens/trip_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'screens/splash_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/started_screen.dart';
import 'screens/BackgroundScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/timer_screen.dart';
import 'package:shared_value/shared_value.dart';
import 'screens/bkash_screen.dart';
import 'screens/recharge_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  runApp(SharedValue.wrapApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Nunito',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                )),
                backgroundColor:
                    MaterialStateProperty.all(ColorCode.textFieldColor)),
          )),
      home: SplashScreen(),
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        GetStartedScreen.id: (context) => GetStartedScreen(),
        OtpScreen.id: (context) =>
            OtpScreen(ModalRoute.of(context).settings.arguments),
        TimerScreen.id: (context) => TimerScreen(),
        BackgroundScreen.id: (context) => BackgroundScreen(),
        BkashScreen.id: (context) =>
            BkashScreen(ModalRoute.of(context).settings.arguments),
        RechargeScreen.id: (context) => RechargeScreen(),
        SettingScreen.id: (context) => SettingScreen(),
        TripScreen.id: (context) => TripScreen(),
        SupportScreen.id: (context) => SupportScreen()
      },
      initialRoute: SplashScreen.id,
    );
  }
}
