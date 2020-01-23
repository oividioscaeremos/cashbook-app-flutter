import 'dart:async';

import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/singleTransactionView.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userID;
String partnerID;

class ViewPaymentsForPartner extends StatefulWidget {
  ViewPaymentsForPartner(@required String partner_id, String currUserId) {
    partnerID = partner_id;
    userID = currUserId;
  }

  @override
  _ViewPaymentsForPartnerState createState() => _ViewPaymentsForPartnerState();
}

class _ViewPaymentsForPartnerState extends State<ViewPaymentsForPartner> {
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  String _detail;
  double _amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addNewPayment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewTransactionPage(
                  currUser: userID,
                  from: userID,
                  to: partnerID,
                )));
  }

  Widget addNewPaymentWidget(
      List<TransactionApp> paymentsList,
      TransactionApp company,
      int index,
      Function dialogFun,
      Function deleteFun) {
    return SingleTransaction(
      list: paymentsList,
      index: index,
      dialogFun: dialogFun,
      isRevenue: false,
      deleteFunction: deleteFun,
    );
  }

  void amountChanged(String input) {
    _amount = double.parse(input);
  }

  void detailChanged(String input) {
    _detail = input;
  }

  List<TransactionApp> buildPaymentList(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<TransactionApp> paymentsList = new List<TransactionApp>();

    snapshot.data.documents.forEach((f) {
      TransactionApp rev = new TransactionApp(
          docID: f.documentID,
          from: f.data["from"],
          to: f.data["to"],
          date: DateTime.fromMillisecondsSinceEpoch(
              f.data["date"].millisecondsSinceEpoch),
          amount: double.parse(f.data["amount"].toString()),
          processed: f.data["isProcessed"],
          detail: f.data["details"]);
      if (paymentsList.indexOf(rev) == -1) {
        paymentsList.add(rev);
      }
    });

    paymentsList.sort((a, b) => a.date.compareTo(b.date));

    return paymentsList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseCrud.getTransactions(userID, partnerID, false),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print('What does this say -> ${snapshot.data.documents.length}');

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: colorPalette.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: colorPalette.darkBlue,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  "Payments",
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: colorPalette.white,
                      ),
                      onPressed: addNewPayment)
                ],
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  print('tID');
                  print(snapshot.data.documents[index].documentID);
                  List<TransactionApp> paymentsList =
                      new List<TransactionApp>();

                  print('building a new one!');
                  print(snapshot.data.documents.length);
                  paymentsList = buildPaymentList(snapshot);

                  return addNewPaymentWidget(
                      paymentsList, paymentsList[index], index, () {
                    Alert(
                        context: context,
                        title: "Payment",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                labelText: paymentsList[index].detail,
                              ),
                              onChanged: detailChanged,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.attach_money),
                                labelText:
                                    paymentsList[index].amount.toString(),
                              ),
                              onChanged: amountChanged,
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          DialogButton(
                            onPressed: () {
                              setState(() {
                                _firebaseCrud.changeTransactionData(
                                    paymentsList[index],
                                    _detail,
                                    _amount,
                                    false);
                              });
                              paymentsList = buildPaymentList(snapshot);

                              Navigator.of(context, rootNavigator: true).pop();

                              /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPaymentsForPartner(
                                            partnerID, currUserID),
                                  ),
                                );*/
                            },
                            child: Text(
                              "Change",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  }, () {
                    Alert(
                        context: context,
                        title: "Warningo",
                        desc: 'Do you want to delete?',
                        buttons: [
                          DialogButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          DialogButton(
                            onPressed: () async {
                              await _firebaseCrud
                                  .deleteTransaction(paymentsList[index], false)
                                  .then((val) {
                                print('it is officially  here 0!');
                                setState(() {
                                  buildPaymentList(snapshot);
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              });

                              /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPaymentsForPartner(
                                            partnerID, currUserID),
                                  ),
                                );*/
                            },
                            child: Text(
                              "Delete",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  });
                }),
          );
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 80),
            child: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: colorPalette.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: colorPalette.darkBlue,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                "Payments",
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: colorPalette.white,
                  ),
                  onPressed: addNewPayment,
                )
              ],
            ),
          ),
          backgroundColor: colorPalette.darkGrey,
          body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 5.0,
            ),
          ),
        );
      },
    );
  }
}
