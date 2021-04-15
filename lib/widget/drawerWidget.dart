import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:bikesharingapp/widget/drawerListTileWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                  "Ajoy Deb Nath",
                  style: TextStyle(
                      color: ColorCode.mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Balance :"), Text("0.0")],
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
              HomeScreen.id),
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
                    // Todo: pop korte hobe ekebbare
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
