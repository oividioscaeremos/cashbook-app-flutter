import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/singleTransactionView.dart';
import 'package:cash_book_app/screens/adding_pages/add_revenue_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userID;

class ViewUpcomingPaymentsForPartner extends StatefulWidget {
  ViewUpcomingPaymentsForPartner(String currUserId) {
    userID = currUserId;
  }

  @override
  _ViewUpcomingPaymentsForPartnerState createState() =>
      _ViewUpcomingPaymentsForPartnerState();
}

class _ViewUpcomingPaymentsForPartnerState
    extends State<ViewUpcomingPaymentsForPartner> {
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  String _detail;
  double _amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            detail: f.data["details"]);
        if (paymentsList.indexOf(rev) == -1) {
          paymentsList.add(rev);
        }
      }
    });

    paymentsList.sort((a, b) => a.date.compareTo(b.date));

    return paymentsList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseCrud.getPaymentsForUser(userID),
      builder: (context, snapshot) {
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
                  "Upcoming Payments",
                ),
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: new ListView.builder(
                itemCount: snapshot.data.documents.length - 1,
                itemBuilder: (BuildContext context, int index) {
                  List<TransactionApp> paymentsList =
                      new List<TransactionApp>();

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
                                buildPaymentList(snapshot);
                              });

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
                              await _firebaseCrud.deleteTransaction(
                                  paymentsList[index].docID, false);

                              setState(() {
                                paymentsList = buildPaymentList(snapshot);
                              });

                              Navigator.of(context, rootNavigator: true).pop();
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
