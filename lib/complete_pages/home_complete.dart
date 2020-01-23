import 'dart:async';

import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_upcoming_payments_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_upcoming_revenues_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  edgeInsets: 10.0,
                                  paddingInsets: 10.0,
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
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$counterFutureRev',
                                        style: TextStyle(
                                          fontSize: 24.0,
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
                              return ReusableCard(
                                onTap: () {},
                                color: colorPalette.lighterPink,
                                cardChild: Center(
                                  child: CircularProgressIndicator(),
                                ),
                                edgeInsets: 10.0,
                                paddingInsets: 10.0,
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
                                  edgeInsets: 10.0,
                                  paddingInsets: 10.0,
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
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$counterFuturePay',
                                        style: TextStyle(
                                          fontSize: 24.0,
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
                              return ReusableCard(
                                onTap: () {},
                                color: colorPalette.lighterPink,
                                cardChild: Center(
                                  child: CircularProgressIndicator(),
                                ),
                                edgeInsets: 10.0,
                                paddingInsets: 10.0,
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
                          edgeInsets: 10.0,
                          paddingInsets: 10.0,
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
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          color: colorPalette.middlePink,
                          edgeInsets: 10.0,
                          paddingInsets: 10.0,
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
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
