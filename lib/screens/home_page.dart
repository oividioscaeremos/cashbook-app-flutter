import 'package:cash_book_app/classes/Destination.dart';
import 'package:cash_book_app/complete_pages/partners_complete.dart';
import 'package:cash_book_app/complete_pages/profile_complete.dart';
import 'package:cash_book_app/components/destination_view.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../complete_pages/home_complete.dart';

String userId;

class HomePage extends StatefulWidget {
  static String id = "home_page";

  HomePage(String uid) {
    print("homepage" + uid);
    userId = uid;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = new AuthService();
  int _selectedIndex = 0;
  String _title = "Home";

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorPalette.darkBlue,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: colorPalette.darkBlue,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  List<Destination> allDestinations = [
    new Destination('Home', Icons.home, Colors.white10, HomeComplete(userId)),
    new Destination(
        'Partners', Icons.business, Colors.white10, PartnersComplete(userId)),
    new Destination('Profile', Icons.account_balance, Colors.white10,
        ProfileComplete(userId))
  ];

  final _pageOptions = [
    new HomeComplete(userId),
    new PartnersComplete(userId),
    new ProfileComplete(userId),
  ];

  ColorPalette colorPalette = new ColorPalette();

  _onTapFunc(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapFunc,
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title),
          );
        }).toList(),
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
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: allDestinations.map<Widget>((Destination destination) {
            return DestinationView(destination: destination);
          }).toList(),
        ),
      ),
    );
  }
}
