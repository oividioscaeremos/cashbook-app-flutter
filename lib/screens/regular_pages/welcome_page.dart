import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ColorPalette colorPalette = new ColorPalette();

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_page';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _email, _password;
  String userId;
  AuthService authService = new AuthService();
  ColorPalette colorPalette = new ColorPalette();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorPalette.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: colorPalette.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void onChangeFunction(input) {
    setState(() {
      _email = input.toString().toLowerCase();
    });
  }

  void onChangeFunctionTwo(input) {
    setState(() {
      _password = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: authService.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            print('this is the userdata!!!');
            print(snapshot.data.uid);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: CustomTextBox(
                          size: 8.0,
                          hintText: "E-Mail",
                          borderColor: colorPalette.logoLightBlue,
                          function: onChangeFunction,
                          keyboardType: TextInputType.emailAddress,
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
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                            child: Material(
                              elevation: 5.0,
                              color: colorPalette.lighterPink,
                              borderRadius: BorderRadius.circular(10.0),
                              child: MaterialButton(
                                onPressed: () {
                                  signIn();
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

  void signIn() async {
    if (userId == null) {
      userId = await authService.signInWithEmailAndPassword(_email, _password);
    }

    setState(() {
      if (userId != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(userId)));
      }
    });
  }
}
