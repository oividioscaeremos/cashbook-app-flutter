import 'package:cash_book_app/screens/regular_pages/login_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(CashBookApp());

class CashBookApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegistrationPage.id: (context) => RegistrationPage()
      },
    );
  }
}
