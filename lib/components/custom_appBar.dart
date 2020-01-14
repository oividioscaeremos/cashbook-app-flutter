import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function iconOnPressed;

  CustomAppBar(this.title, this.icon, this.iconOnPressed);

  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = new ColorPalette();

    return AppBar(
      backgroundColor: colorPalette.darkBlue,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              icon,
              color: colorPalette.white,
            ),
            onPressed: iconOnPressed)
      ],
    );
  }
}
