import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

String userid;

class ProfileComplete extends StatefulWidget {
  ProfileComplete(String uid) {
    userid = uid;
  }
  @override
  _ProfileCompleteState createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  ColorPalette colorPalette = new ColorPalette();
  AuthService _authService = new AuthService();

  @override
  void initState() {
    super.initState();
  }

  void signOut() {
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: CustomAppBar("Partners", Icons.close, signOut),
        preferredSize: new Size(
          MediaQuery.of(context).size.width,
          60.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Text('Profile'),
      ),
    );
  }
}
