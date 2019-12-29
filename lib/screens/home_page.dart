import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  static String id = "home_page";
  static String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ColorPalette colorPalette = new ColorPalette();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorPalette.darkBlue,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: colorPalette.darkBlue,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _onTapFunc(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPalette.pink,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "mahmut",
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTapFunc,
          items: hBottomNavBarItems,
          currentIndex: _selectedIndex,
          backgroundColor: colorPalette.spotifyBlack,
          unselectedItemColor: colorPalette.white54,
          selectedItemColor: colorPalette.white,
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
          ),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorPalette.darkBlue,
        body: Container(
          child: Text(
            "Merhaba",
            style: TextStyle(
              color: colorPalette.white,
            ),
          ),
        ),
      ),
    );
  }
}
