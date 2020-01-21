import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomPhoneTextBox extends StatelessWidget {
  final TextInputType keyboardType;
  final double size;
  final String hintText;
  final Function function;
  final Color borderColor;
  final Function validator;

  CustomPhoneTextBox(
      {this.size,
      this.hintText,
      this.borderColor,
      this.function,
      this.keyboardType,
      this.validator});

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '+## (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

    return TextFormField(
      onChanged: (input) {
        function(input);
      },
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        labelText: '+01(234)567-89-01',
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
      inputFormatters: [maskFormatter],
    );
  }
}
