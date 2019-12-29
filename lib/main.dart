import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(CashBookApp());

class CashBookApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ColorPalette().white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        WelcomePage.id: (context) => WelcomePage(),
        RegistrationPage.id: (context) => RegistrationPage()
      },
    );
  }
}
