import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
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
    const double borderRadius = 10.0;

    return RaisedButton(
      onPressed: () {
        func(companyId);
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      padding: zeroAllPadding,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: this.colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: Container(
          constraints: kBoxConstraintsv2, // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: TextStyle(
              color: colorPalette.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
