import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

const fontWeight = 24.0;
const lighterPink = Color(0xffeda092);

const hBottomNavBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    title: Text('Home'),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.business),
    title: Text('Partners'),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.account_balance),
    title: Text('Profile'),
  ),
];

const double borderWidth = 3.0;
const double borderRadius = 15.0;
const double edgeInsets = 20.0;
const double contentPaddingTB = 10.0;

const h_c_CurrentBalanceTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: fontWeight,
  color: lighterPink,
);

const h_c_CurrentBalanceBalanceTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
