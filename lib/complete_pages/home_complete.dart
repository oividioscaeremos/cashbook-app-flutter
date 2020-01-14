import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';

String userid = "";
double _currentCashBalance = 0.0;

class HomeComplete extends StatefulWidget {
  HomeComplete(String userID) {
    userid = userID;
  }
  @override
  _HomeCompleteState createState() => _HomeCompleteState();
}

class _HomeCompleteState extends State<HomeComplete> {
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  static const fontWeight = 24.0;

  @override
  void initState() {
    print("before");
    print(_currentCashBalance);
    super.initState();
    //refreshPage();

    refreshPage();
    print("after");
    print(_currentCashBalance);
  }

  void refreshPage() {
    _firebaseCrud.getCurrentCashBalance(userId).then((data) {
      print("data");
      print(data);
      setState(() {
        _currentCashBalance = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPalette.darkBlue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Home",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: colorPalette.white,
            ),
            onPressed: () {
              refreshPage();
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: colorPalette.darkGrey,
        child: Column(
          children: <Widget>[
            ReusableCard(
              color: colorPalette.darkerPink,
              onTap: () {},
              cardChild: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Mevcut Nakit Bakiyeniz:",
                      style: h_c_CurrentBalanceTextStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Row(
                          children: <Widget>[
                            Text(
                              _currentCashBalance.toString() + " ₺",
                              style: h_c_CurrentBalanceBalanceTextStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
