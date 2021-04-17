import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/Global/data.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:bikesharingapp/screens/bkash_screen.dart';
import 'package:bikesharingapp/screens/login_screen.dart';
import 'package:bikesharingapp/screens/recharge_screen.dart';
import 'package:bikesharingapp/widget/drawerListTileWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  backgroundImage: AssetImage('assets/images/user_icon.png'),
                  backgroundColor: Colors.white,
                  radius: 40,
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
          MenuTile(
              "Home",
              Icon(
                Icons.home,
                color: ColorCode.mainColor,
              ),
              HomeScreen.id),
          MenuTile(
              "Trips",
              Icon(
                Icons.bike_scooter,
                color: ColorCode.mainColor,
              ),
              HomeScreen.id),
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
              HomeScreen.id),
          MenuTile(
              "Help & Support",
              Icon(
                Icons.help_outlined,
                color: ColorCode.mainColor,
              ),
              HomeScreen.id),
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
