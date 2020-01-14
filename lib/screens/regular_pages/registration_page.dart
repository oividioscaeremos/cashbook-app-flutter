import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  static String id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ColorPalette colorPalette = new ColorPalette();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String _companyName,
      _nameAndSurname,
      _eMail,
      _password,
      _passwordConfirm,
      _errorString = "";

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorPalette.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: colorPalette.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void onChangedPW(input) {
    setState(() {
      _password = input;
    });
  }

  void onChangedCPW(input) {
    setState(() {
      _passwordConfirm = input;
    });
  }

  void onChangedCN(input) {
    setState(() {
      _companyName = input;
    });
  }

  void onChangedEM(input) {
    setState(() {
      _eMail = input;
    });
  }

  void onChangedNS(input) {
    setState(() {
      _nameAndSurname = input;
    });
  }

  String validatorEmail(input) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    if (!emailValid) {
      return "Please enter a valid e-mail address.";
    }
  }

  String isEmpty(input) {
    if (input.length == 0) {
      return "This area can't be empty.";
    }
  }

  String validatorPassword(input) {
    if (input.length < 6) {
      return "Password can't be shorter than 6 characters.";
    }
  }

  String validatorCPassword(input) {
    print(input);
    if (input != _password) {
      return "Password doesn't match.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Material(
            child: Center(
              child: Form(
                key: _globalKey,
                child: Container(
                  color: colorPalette.white,
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(edgeInsets),
                        child: Center(
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: colorPalette.lighterDarkBlue),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: edgeInsets,
                          right: edgeInsets,
                          bottom: edgeInsets,
                        ),
                        child: CustomTextBox(
                          size: borderRadius,
                          hintText: "Company Name",
                          borderColor: colorPalette.lighterPink,
                          function: onChangedCN,
                          keyboardType: TextInputType.text,
                          validator: isEmpty,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: edgeInsets,
                          right: edgeInsets,
                          bottom: edgeInsets,
                        ),
                        child: CustomTextBox(
                          size: borderRadius,
                          hintText: "E-Mail",
                          borderColor: colorPalette.lighterPink,
                          function: onChangedEM,
                          keyboardType: TextInputType.emailAddress,
                          validator: validatorEmail,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: edgeInsets,
                          right: edgeInsets,
                          bottom: edgeInsets,
                        ),
                        child: CustomTextBox(
                          size: borderRadius,
                          hintText: "Name and Surname",
                          borderColor: colorPalette.lighterPink,
                          function: onChangedNS,
                          keyboardType: TextInputType.text,
                          validator: isEmpty,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: edgeInsets,
                          right: edgeInsets,
                          bottom: edgeInsets,
                        ),
                        child: CustomTextBox(
                          size: borderRadius,
                          hintText: "Password",
                          borderColor: colorPalette.lighterPink,
                          function: onChangedPW,
                          keyboardType: TextInputType.text,
                          validator: validatorPassword,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: edgeInsets,
                          right: edgeInsets,
                          bottom: edgeInsets,
                        ),
                        child: CustomTextBox(
                          size: borderRadius,
                          hintText: "Confirm Password",
                          borderColor: colorPalette.lighterPink,
                          function: onChangedCPW,
                          keyboardType: TextInputType.text,
                          validator: validatorCPassword,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 100.0),
                        child: Material(
                          elevation: 5.0,
                          color: colorPalette.lighterDarkBlue,
                          borderRadius: BorderRadius.circular(10.0),
                          child: MaterialButton(
                            minWidth: double.maxFinite,
                            onPressed: () {
                              signUp();
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: colorPalette.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() {
    final formState = _globalKey.currentState;
    if (formState.validate()) {
      AuthService authService = new AuthService();
      var returned = authService.createUser(
          _eMail, _password, _companyName, _nameAndSurname);

      /*if(returned == "ERROR_EMAIL_ALREADY_IN_USE"){
        formState.
      }*/
    }
  }
}
