import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final TextInputType keyboardType;
  final double size;
  final String hintText;
  final Function function;
  final Color borderColor;
  final Function validator;
  final int maxLines;

  CustomTextBox(
      {this.size,
      this.hintText,
      this.borderColor,
      this.function,
      this.keyboardType,
      this.validator,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (input) {
        function(input);
      },
      maxLines: maxLines,
      obscureText:
          this.hintText == "Password" || this.hintText == "Confirm Password"
              ? true
              : false,
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        labelText: this.hintText,
        contentPadding: EdgeInsets.symmetric(
            vertical: contentPaddingTB, horizontal: contentPaddingTB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(this.size)),
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
      validator: (input) {
        print('validator:' + input);
        return validator(input);
      },
    );
  }
}
