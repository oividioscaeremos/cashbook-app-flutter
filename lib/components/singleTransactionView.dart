import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/viewing_pages/view_revenues_for_partner_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SingleTransaction extends StatelessWidget {
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  var formatter = new DateFormat("dd.MM.yyyy");
  ColorPalette colorPalette = new ColorPalette();
  List<TransactionApp> list;
  int index;
  Function dialogFun;
  Function deleteFunction;
  bool isRevenue;
  SingleTransaction(
      {this.list,
      this.index,
      this.dialogFun,
      this.isRevenue,
      this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    const double fontSize = 18.0;
    const double deleteIconRight = 10.0;

    if (list[index].processed) {
      return GestureDetector(
        onTap: dialogFun,
        child: Container(
          child: Padding(
            padding: kTransactionPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          list[index].detail.toString(),
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                    ),
                    Positioned(
                      right: deleteIconRight,
                      child: GestureDetector(
                        onTap: deleteFunction,
                        child: Icon(
                          Icons.delete_forever,
                          color: colorPalette.white54,
                        ),
                      ),
                    ),
                  ],
                ),
                kTwentyHeightSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      list[index].amount.toString() + " ₺",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: colorPalette.white,
                      ),
                    ),
                    Icon(
                      Icons.check,
                      color: colorPalette.darkerPink,
                    ),
                    Text(
                      formatter.format(list[index].date).toString(),
                    )
                  ],
                )
              ],
            ),
          ),
          margin: EdgeInsets.all(edgeInsets),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: colorPalette.lighterPink,
          ),
        ),
      );
    } else if (!list[index].processed &&
        list[index].date.compareTo(DateTime.now()) > 0) {
      return Container(
        child: ReusableCard(
          color: colorPalette.white54,
          onTap: dialogFun,
          edgeInsets: edgeInsets,
          paddingInsets: 10.0,
          cardChild: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Text(
                            list[index].detail.toString(),
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ),
                      Positioned(
                        right: deleteIconRight,
                        child: GestureDetector(
                          onTap: deleteFunction,
                          child: Icon(
                            Icons.delete_forever,
                            color: colorPalette.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  kTwentyHeightSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        list[index].amount.toString() + " ₺",
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          fontWeight: FontWeight.bold,
                          color: colorPalette.white,
                        ),
                      ),
                      Icon(
                        Icons.timer,
                        color: colorPalette.darkerPink,
                      ),
                      Text(
                        formatter.format(list[index].date).toString(),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: ReusableCard(
          color: Colors.red,
          onTap: dialogFun,
          edgeInsets: edgeInsets,
          paddingInsets: 10.0,
          cardChild: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      children: <Widget>[
                        Text(
                          list[index].amount.toString() + " ₺",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          child: Text(
                            (isRevenue ? "Ödeme " : "Gelir ") +
                                (DateTime.now()
                                            .difference(list[index].date)
                                            .inDays
                                            .toString() ==
                                        "0"
                                    ? " bugüne kayıtlı. "
                                    : DateTime.now()
                                            .difference(list[index].date)
                                            .inDays
                                            .toString() +
                                        " gün önce eklenmeliydi."),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: GestureDetector(
                      onTap: () {
                        Alert(
                            context: context,
                            title: "Onayla",
                            type: AlertType.warning,
                            desc:
                                "İşlem bakiyenize aktarılacaktır, onaylıyor musunuz?",
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  _firebaseCrud.setTransactionToProcessed(
                                      list[index], isRevenue);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => isRevenue
                                          ? ViewRevenuesForPartner(
                                              list[index].from, list[index].to)
                                          : ViewRevenuesForPartner(
                                              list[index].to, list[index].from),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Evet",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              DialogButton(
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                child: Text(
                                  "Vazgeç",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                      },
                      child: Icon(
                        Icons.check_circle,
                        color: colorPalette.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
