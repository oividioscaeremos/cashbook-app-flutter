import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/singleTransactionView.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userID;
String partnerID;
String companyName;

class ViewRevenuesForPartner extends StatefulWidget {
  ViewRevenuesForPartner(@required String partner_id, String currUserId) {
    partnerID = partner_id;
    userID = currUserId;
  }

  @override
  _ViewRevenuesForPartnerState createState() => _ViewRevenuesForPartnerState();
}

class _ViewRevenuesForPartnerState extends State<ViewRevenuesForPartner> {
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

  void addNewRevenue() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewTransactionPage(
                  currUser: userID,
                  from: partnerID,
                  to: userID,
                )));
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

  List<TransactionApp> buildRevList(AsyncSnapshot<QuerySnapshot> snapshot) {
    print('called this');
    List<TransactionApp> revenuesList = new List<TransactionApp>();

    //List snapShotDoc = snapshot.data.documents;
    snapshot.data.documents.forEach((f) {
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
    });

    revenuesList.sort((a, b) => a.date.compareTo(b.date));

    return revenuesList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseCrud.getTransactions(userID, partnerID, true),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
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
                  "Gelirler",
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: colorPalette.white,
                    ),
                    onPressed: addNewRevenue,
                  )
                ],
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: new ListView.builder(
                dragStartBehavior: DragStartBehavior.start,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  List<TransactionApp> revenuesList =
                      new List<TransactionApp>();

                  revenuesList = buildRevList(snapshot);

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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
                                buildRevList(snapshot);
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  }, () {
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          DialogButton(
                            onPressed: () async {
                              await _firebaseCrud.deleteTransaction(
                                  revenuesList[index].docID, true);

                              setState(() {
                                revenuesList = buildRevList(snapshot);
                              });

                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "Evet",
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
                "Gelirler",
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: colorPalette.white,
                    ),
                    onPressed: addNewRevenue)
              ],
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
