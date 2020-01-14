import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

class TappableContainer extends StatelessWidget {
  ColorPalette colorPalette = new ColorPalette();
  final List<Color> colors;
  final String buttonText;
  final Color textColor;

  TappableContainer({this.colors, this.buttonText, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print("bana tıkladınız.");
        },
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              colors: [
                colorPalette.orange,
                colorPalette.middlePink,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Text(
              buttonText + " tl",
              style: TextStyle(
                fontSize: 20.0,
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
