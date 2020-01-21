import 'package:cash_book_app/components/custom_appBar.dart';
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
    super.initState();
    //refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseCrud.getCurrentCashBalance(userid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: PreferredSize(
              child: CustomAppBar("Home", Icons.refresh, () {}),
              preferredSize: new Size(
                MediaQuery.of(context).size.width,
                60.0,
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              color: colorPalette.darkGrey,
              child: Column(
                children: <Widget>[
                  ReusableCard(
                    color: colorPalette.darkerPink,
                    edgeInsets: 10.0,
                    paddingInsets: 10.0,
                    onTap: () {},
                    cardChild: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Current Cash Balance:",
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
                                    snapshot.data['properties']
                                                ['currentCashBalance']
                                            .toString() +
                                        " ₺",
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
        } else {
          return Scaffold(
            appBar: PreferredSize(
              child: CustomAppBar("Home", Icons.add_circle, () {}),
              preferredSize: new Size(
                MediaQuery.of(context).size.width,
                60.0,
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: Container(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
