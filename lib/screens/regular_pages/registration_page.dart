import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  static String id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ColorPalette colorPalette = new ColorPalette();

  void onTapController() {
    print("vuhu");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPalette.white,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextBox(
                    size: 10.0,
                    hintText: "Name and Surname",
                    keyboardType: TextInputType.text,
                    borderColor: colorPalette.lighterPink,
                    function: onTapController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextBox(
                    size: 10.0,
                    hintText: "Name",
                    keyboardType: TextInputType.text,
                    borderColor: colorPalette.lighterPink,
                    function: onTapController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextBox(
                    size: 10.0,
                    hintText: "Name and Surname",
                    keyboardType: TextInputType.text,
                    borderColor: colorPalette.lighterPink,
                    function: onTapController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextBox(
                    size: 10.0,
                    hintText: "Name and Surname",
                    keyboardType: TextInputType.text,
                    borderColor: colorPalette.lighterPink,
                    function: onTapController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomTextBox(
                    size: 10.0,
                    hintText: "Name and Surname",
                    keyboardType: TextInputType.text,
                    borderColor: colorPalette.lighterPink,
                    function: onTapController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
