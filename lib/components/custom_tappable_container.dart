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
    return RaisedButton(
      onPressed: () {
        func(companyId);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: this.colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 88.0,
            minHeight: 36.0,
          ), // min sizes for Material buttons
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
