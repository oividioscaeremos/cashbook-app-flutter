import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/singleTransactionView.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userID;
String companyName;

class ViewUpcomingRevenuesForPartner extends StatefulWidget {
  ViewUpcomingRevenuesForPartner(String currUserId) {
    userID = currUserId;
  }

  @override
  _ViewUpcomingRevenuesForPartnerState createState() =>
      _ViewUpcomingRevenuesForPartnerState();
}

class _ViewUpcomingRevenuesForPartnerState
    extends State<ViewUpcomingRevenuesForPartner> {
  final Firestore _firestore = Firestore.instance;
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  String _detail;
  double _amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget addNewRevenueWidget(
      List<TransactionApp> revenuesList,
      TransactionApp company,
      int index,
      Function dialogFun,
      Function deleteFun) {
    return SingleTransaction(
      list: revenuesList,
      index: index,
      dialogFun: dialogFun,
      isRevenue: true,
      deleteFunction: deleteFun,
    );
  }

  void amountChanged(String input) {
    _amount = double.parse(input);
  }

  void detailChanged(String input) {
    _detail = input;
  }

  List<TransactionApp> buildRevenueList(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<TransactionApp> revenuesList = new List<TransactionApp>();

    List snapShotDoc = snapshot.data.documents;

    snapshot.data.documents.forEach((f) {
      if (!f.data["isProcessed"]) {
        TransactionApp rev = new TransactionApp(
          docID: f.documentID,
          from: f.data["from"],
          to: f.data["to"],
          date: DateTime.fromMillisecondsSinceEpoch(
              f.data["date"].millisecondsSinceEpoch),
          amount: double.parse(f.data["amount"].toString()),
          processed: f.data["isProcessed"],
          detail: f.data["details"],
        );

        if (revenuesList.indexOf(rev) == -1) {
          revenuesList.add(rev);
        }
      }
    });

    revenuesList.sort((a, b) => a.date.compareTo(b.date));

    return revenuesList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseCrud.getRevenuesForUser(userID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TransactionApp> revenuesList = new List<TransactionApp>();

          revenuesList = buildRevenueList(snapshot);
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
                  "Yaklaşan Gelirler",
                ),
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: new ListView.builder(
                dragStartBehavior: DragStartBehavior.start,
                itemCount: revenuesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return addNewRevenueWidget(
                      revenuesList, revenuesList[index], index, () {
                    Alert(
                        context: context,
                        title: "Gelir",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                labelText: revenuesList[index].detail,
                              ),
                              onChanged: detailChanged,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.attach_money),
                                labelText:
                                    revenuesList[index].amount.toString(),
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
                              "Vazgeç",
                              style: kRegistrationStyle,
                            ),
                          ),
                          DialogButton(
                            onPressed: () {
                              setState(() {
                                _firebaseCrud.changeTransactionData(
                                    revenuesList[index],
                                    _detail,
                                    _amount,
                                    true);
                                buildRevenueList(snapshot);
                              });

                              Navigator.of(context, rootNavigator: true).pop();
                              /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewRevenuesForPartner(
                                            partnerID, currUserID),
                                  ),
                                );*/
                            },
                            child: Text(
                              "Değiştir",
                              style: kRegistrationStyle,
                            ),
                          )
                        ]).show();
                  }, () {
                    setState(() {
                      Alert(
                          context: context,
                          title: "Dikkat",
                          desc: 'Silmek istediğinize emin misiniz?',
                          buttons: [
                            DialogButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              child: Text(
                                "Vazgeç",
                                style: kRegistrationStyle,
                              ),
                            ),
                            DialogButton(
                              onPressed: () async {
                                await _firebaseCrud.deleteTransaction(
                                    revenuesList[index].docID, true);
                                setState(() {
                                  revenuesList = buildRevenueList(snapshot);
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Text(
                                "Evet",
                                style: kRegistrationStyle,
                              ),
                            )
                          ]).show();
                    });
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
                "Yaklaşan Gelirler",
              ),
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
      },
    );
  }
}
