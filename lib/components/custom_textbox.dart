import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  static double _size;
  static String _hintText;
  static ColorPalette _colorPalette;
  static Function _function;

  CustomTextBox({double edges, String hintText, Function function}) {
    _size = edges;
    _hintText = hintText;
    _colorPalette = new ColorPalette();
    _function = function;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _function(),
      decoration: InputDecoration(
        hintText: _hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _colorPalette.darkBlue,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              _size,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _colorPalette.pink,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              _size,
            ),
          ),
        ),
      ),
    );
  }
}
