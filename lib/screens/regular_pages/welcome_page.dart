import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ColorPalette colorPalette = new ColorPalette();

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_page';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void onChangeFunction() {
    print("selam");
  }

  void onChangeFunctionTwo() {
    print("selam2");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorPalette.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 150,
                  child: Image.asset(
                    "lib/assets/images/logo-with-name.png",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: CustomTextBox(
                  size: 8.0,
                  hintText: "E-Mail",
                  borderColor: colorPalette.logoLightBlue,
                  function: onChangeFunction,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: CustomTextBox(
                  size: 8.0,
                  hintText: "Password",
                  borderColor: colorPalette.logoLightBlue,
                  function: onChangeFunctionTwo,
                  keyboardType: TextInputType.text,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                    child: Material(
                      elevation: 5.0,
                      color: colorPalette.lighterPink,
                      borderRadius: BorderRadius.circular(10.0),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, HomePage.id);
                          });
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: colorPalette.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("or"),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(context, RegistrationPage.id);
                      });
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorPalette.logoLightBlue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
