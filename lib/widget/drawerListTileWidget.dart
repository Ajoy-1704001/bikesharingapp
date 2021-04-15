import 'package:bikesharingapp/Global/colors.dart';
import 'package:bikesharingapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String _title;
  final Icon _icon;
  final String _navigation;

  MenuTile(this._title, this._icon, this._navigation);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _title,
        style: TextStyle(color: ColorCode.mainColor, fontSize: 20),
      ),
      leading: _icon,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, HomeScreen.id);
        // TODO: implement navigation, just function e j string ta ashbe oita boshabo
      },
    );
  }
}
