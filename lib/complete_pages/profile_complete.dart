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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Text('Profile'),
      ),
    );
  }
}
