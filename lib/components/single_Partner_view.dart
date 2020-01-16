import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'custom_tappable_container.dart';

class SinglePartner extends StatelessWidget {
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  static double fontSize = 24;
  final Company company;
  final Function paymentTap;
  final Function revenueTap;
  final Function showOurDialogFunc;

  SinglePartner(
      {this.company,
      this.paymentTap,
      this.revenueTap,
      this.showOurDialogFunc}) {}

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      color: colorPalette.darkerPink,
      edgeInsets: 10.0,
      onTap: () {},
      cardChild: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    company.companyName,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: colorPalette.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20.0,
                child: GestureDetector(
                  onTap: showOurDialogFunc,
                  child: Icon(
                    Icons.delete_forever,
                    color: colorPalette.white,
                  ),
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ReusableCard(
                color: colorPalette.white54,
                edgeInsets: 0.0,
                onTap: () {},
                cardChild: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                company.personOne.nameAndSurname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: colorPalette.white54,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      company.personOne.phoneNumber,
                                      style: TextStyle(
                                        color: colorPalette.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                company.personTwo != null
                                    ? company.personTwo.nameAndSurname
                                    : '(---)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      company.personTwo != null
                                          ? company.personTwo.phoneNumber
                                          : '(---)',
                                      style: TextStyle(
                                        color: colorPalette.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(
                                      Icons.phone,
                                      color: colorPalette.white54,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text("__"),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            company.address,
                            style: TextStyle(
                              color: colorPalette.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              TappableContainer(
                companyId: company.uid,
                colors: [
                  Color(0xff08bcff),
                  Color(0xff08bcdd),
                ],
                buttonText: company.revenueBalance.toString(),
                textColor: colorPalette.white,
                func: revenueTap,
              ),
              SizedBox(
                width: 10.0,
              ),
              TappableContainer(
                companyId: company.uid,
                colors: [
                  Color(0xffffac84),
                  Color(0xffff795a),
                ],
                buttonText: company.paymentBalance.toString(),
                textColor: colorPalette.white,
                func: paymentTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
