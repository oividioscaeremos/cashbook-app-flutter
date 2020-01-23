import 'dart:async';

import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_upcoming_payments_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_upcoming_revenues_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/reusable_card.dart';

String userid = "";
double _currentCashBalance = 0.0;
int counterFutureRev = 0, dueRev = 0;
double expectedRev = 0.0;
int counterFuturePay = 0, duePay = 0;
double expectedPay = 0;

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

  void buildFromRevSnapshot(AsyncSnapshot<QuerySnapshot> revSnapshot) {
    counterFutureRev = 0;
    dueRev = 0;
    expectedRev = 0.0;
    revSnapshot.data.documents.forEach((d) {
      if (!d.data['isProcessed']) {
        if (DateTime.fromMillisecondsSinceEpoch(
                    d.data["date"].millisecondsSinceEpoch)
                .compareTo(DateTime.now()) <=
            0) {
          dueRev++;
        }
        counterFutureRev++;
        expectedRev += d.data['amount'];
      }
    });
  }

  void buildFromPaySnapshot(AsyncSnapshot<QuerySnapshot> paySnapshot) {
    counterFuturePay = 0;
    duePay = 0;
    expectedPay = 0;
    paySnapshot.data.documents.forEach((d) {
      if (!d.data['isProcessed']) {
        if (DateTime.fromMillisecondsSinceEpoch(
                    d.data["date"].millisecondsSinceEpoch)
                .compareTo(DateTime.now()) <=
            0) {
          duePay++;
        }
        counterFuturePay++;
        expectedPay += d.data['amount'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double edgeInsets = 10.0;
    const double paddingInsets = 10.0;
    const double fontSizeNumber = 24.0;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: StreamBuilder(
                          stream: _firebaseCrud.getRevenuesForUser(userid),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> revSnapshot) {
                            if (revSnapshot.hasData) {
                              buildFromRevSnapshot(revSnapshot);

                              Timer.periodic(Duration(seconds: 5), (Timer t) {
                                buildFromRevSnapshot(revSnapshot);
                              });
                              return Expanded(
                                child: ReusableCard(
                                  color: colorPalette.lighterPink,
                                  edgeInsets: edgeInsets,
                                  paddingInsets: paddingInsets,
                                  onTap: () {
                                    if (counterFutureRev > 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewUpcomingRevenuesForPartner(
                                                  userid),
                                        ),
                                      );
                                    }
                                  },
                                  cardChild: Column(
                                    children: <Widget>[
                                      Text(
                                        'Upcoming\nRevenues:',
                                        style: kUpcomingRevTextStyle,
                                      ),
                                      Text(
                                        '$counterFutureRev',
                                        style: TextStyle(
                                          fontSize: fontSizeNumber,
                                          fontWeight: FontWeight.bold,
                                          color: colorPalette.darkerPink,
                                        ),
                                      ),
                                      Text('$expectedRev TL in total.'),
                                      Text('($dueRev are due.)'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ReusableCard(
                                  color: colorPalette.lighterPink,
                                  edgeInsets: edgeInsets,
                                  paddingInsets: paddingInsets,
                                  onTap: () {},
                                  cardChild: Column(
                                    children: <Widget>[
                                      CircularProgressIndicator()
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        child: StreamBuilder(
                          stream: _firebaseCrud.getPaymentsForUser(userid),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> paySnapshot) {
                            if (paySnapshot.hasData) {
                              buildFromPaySnapshot(paySnapshot);
                              Timer.periodic(Duration(seconds: 5), (Timer t) {
                                buildFromPaySnapshot(paySnapshot);
                              });
                              return Expanded(
                                child: ReusableCard(
                                  color: colorPalette.lighterPink,
                                  edgeInsets: edgeInsets,
                                  paddingInsets: paddingInsets,
                                  onTap: () {
                                    if (counterFuturePay > 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewUpcomingPaymentsForPartner(
                                                  userid),
                                        ),
                                      );
                                    }
                                  },
                                  cardChild: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Upcoming\nPayments:',
                                        style: kUpcomingRevTextStyle,
                                      ),
                                      Text(
                                        '$counterFuturePay',
                                        style: TextStyle(
                                          fontSize: fontSizeNumber,
                                          fontWeight: FontWeight.bold,
                                          color: colorPalette.darkerPink,
                                        ),
                                      ),
                                      Text('$expectedPay TL in total.'),
                                      Text('($duePay are due.)'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ReusableCard(
                                  color: colorPalette.lighterPink,
                                  edgeInsets: edgeInsets,
                                  paddingInsets: paddingInsets,
                                  onTap: () {},
                                  cardChild: Column(
                                    children: <Widget>[
                                      CircularProgressIndicator()
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(
                          color: colorPalette.dollarGreen,
                          edgeInsets: edgeInsets,
                          paddingInsets: paddingInsets,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewTransactionPage(
                                  currUser: userid,
                                  to: userid,
                                  from: null,
                                ),
                              ),
                            );
                          },
                          cardChild: Column(
                            children: <Widget>[
                              Text(
                                'Add Revenue',
                                style: kUpcomingRevTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          color: colorPalette.middlePink,
                          edgeInsets: edgeInsets,
                          paddingInsets: paddingInsets,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewTransactionPage(
                                  currUser: userid,
                                  to: null,
                                  from: userid,
                                ),
                              ),
                            );
                          },
                          cardChild: Column(
                            children: <Widget>[
                              Text(
                                'Add Payment',
                                style: kUpcomingRevTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                kAppBarHeight,
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
