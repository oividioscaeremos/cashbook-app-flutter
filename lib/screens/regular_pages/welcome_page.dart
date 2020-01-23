import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final ColorPalette colorPalette = new ColorPalette();

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_page';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String email, password;
  String userId;
  AuthService authService = new AuthService();
  ColorPalette colorPalette = new ColorPalette();

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

  void onChangeFunction(String input) {
    email = input;
  }

  void onChangeFunctionTwo(String input) {
    password = input;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

    String validateEmail(String input) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(input);

      if (input.isEmpty) {
        return "E-Mail area cannot be empty.";
      } else if (!emailValid) {
        return 'E-Mail is not in valid shape.';
      }
    }

    String validatePassword(String input) {
      if (input.isEmpty) {
        return 'Password cannot be empty';
      }
    }

    void signIn() async {
      final state = _globalKey.currentState;
      if (state.validate()) {
        if (userId == null) {
          try {
            userId =
                await authService.signInWithEmailAndPassword(email, password);
          } catch (err) {
            Alert(
              context: context,
              type: AlertType.warning,
              title: "ERROR",
              desc: err.message,
              buttons: [
                DialogButton(
                  child: Text(
                    "OKAY",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();
          }
        }

        print('userId');
        print(userId);

        setState(() {
          if (userId != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage(userId)));
          }
        });
      }
    }

    return FutureBuilder<FirebaseUser>(
        future: authService.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: HomePage.id,
              routes: {
                HomePage.id: (context) => HomePage(snapshot.data.uid),
                WelcomePage.id: (context) => WelcomePage(),
                RegistrationPage.id: (context) => RegistrationPage()
              },
            );
          } else {
            return Scaffold(
              backgroundColor: colorPalette.white,
              body: Form(
                key: _globalKey,
                child: Padding(
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: CustomTextBox(
                          size: 8.0,
                          hintText: "E-Mail",
                          borderColor: colorPalette.logoLightBlue,
                          function: onChangeFunction,
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: CustomTextBox(
                          size: 8.0,
                          hintText: "Password",
                          borderColor: colorPalette.logoLightBlue,
                          function: onChangeFunctionTwo,
                          keyboardType: TextInputType.text,
                          validator: validatePassword,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                            child: RaisedButton(
                              elevation: 5.0,
                              color: colorPalette.lighterPink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                signIn();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                Navigator.pushNamed(
                                    context, RegistrationPage.id);
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
        });
  }
}
