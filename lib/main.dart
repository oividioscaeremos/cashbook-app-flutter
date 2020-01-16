import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/registration_page.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(CashBookApp());

class CashBookApp extends StatefulWidget {
  @override
  _CashBookAppState createState() => _CashBookAppState();
}

class _CashBookAppState extends State<CashBookApp> {
  AuthService authService = new AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(null),
        WelcomePage.id: (context) => WelcomePage(),
        RegistrationPage.id: (context) => RegistrationPage()
      },
    );
  }
}
