import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final TextInputType keyboardType;
  final double size;
  final String hintText;
  final Function function;
  final Color borderColor;

  CustomTextBox(
      {this.size,
      this.hintText,
      this.borderColor,
      this.function,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: function(),
      obscureText: this.hintText == "Password" ? true : false,
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        hintText: this.hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: this.borderColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(this.size)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: this.borderColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(this.size)),
        ),
      ),
    );
  }
}
