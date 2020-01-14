import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

class TappableContainer extends StatelessWidget {
  ColorPalette colorPalette = new ColorPalette();
  final String companyId;
  final Function func;
  final List<Color> colors;
  final String buttonText;
  final Color textColor;

  TappableContainer(
      {this.companyId,
      this.colors,
      this.buttonText,
      this.textColor,
      this.func});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      /*child: FlatButton(
        child: Text(
          "selam",
        ),
        onPressed: func(companyId),
        color: this.colors,
      ),*/
      child: GestureDetector(
        onTap: () {
          func(companyId);
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text(
              buttonText + " tl",
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
                fontWeight: FontWeight.bold,
                fontFamily: "LexendPeta",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
