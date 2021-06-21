import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:bikesharingapp/screens/bkash_screen.dart';
import 'package:bikesharingapp/screens/login_screen.dart';
import 'package:bikesharingapp/screens/recharge_screen.dart';
import 'package:bikesharingapp/screens/support.dart';
import 'package:bikesharingapp/screens/trip_screen.dart';
import 'package:bikesharingapp/widget/drawerListTileWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bikesharingapp/screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
        child: Column(children: [
          DrawerHeader(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage:
                      link.of(context) != "" || link.of(context) != null
                          ? NetworkImage(
                              link.of(context),
                            )
                          : AssetImage('assets/images/user_icon.png'),
                  backgroundColor: Colors.white,
                  radius: 40,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${mobile.of(context)}",
                  style: TextStyle(
                      color: ColorCode.mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Balance :"), Text("${balance.of(context)}")],
                )
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorCode.mainColor),
              child: ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, HomeScreen.id);
                },
              )),
          MenuTile(
              "Trips",
              Icon(
                Icons.bike_scooter,
                color: ColorCode.mainColor,
              ),
              TripScreen.id),
          MenuTile(
              "Recharge",
              Icon(
                Icons.monetization_on,
                color: ColorCode.mainColor,
              ),
              RechargeScreen.id),
          MenuTile(
              "Settings",
              Icon(
                Icons.settings,
                color: ColorCode.mainColor,
              ),
              SettingScreen.id),
          MenuTile(
              "Help & Support",
              Icon(
                Icons.help_outlined,
                color: ColorCode.mainColor,
              ),
              SupportScreen.id),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (route) => false);
                  },
                  title: Text("Log Out",
                      style:
                          TextStyle(color: ColorCode.mainColor, fontSize: 20)),
                  leading: Icon(
                    Icons.logout,
                    color: ColorCode.mainColor,
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
