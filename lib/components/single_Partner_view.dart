import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/viewing_pages/view_payments_for_partner_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/services/pdfGenerator.dart';
import 'package:cash_book_app/services/pdf_viewer.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
    const double edgeInsets = 10.0;
    const double paddingInsets = 10.0;
    const double deleteIconRight = 20.0;

    void generatePDF(String cID) {
      PDFGenerator pdfGenerator = new PDFGenerator();
      getTemporaryDirectory().then((output) {
        pdfGenerator.GeneratePDFForCompany(cID).then((byteList) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerOfOurs(
                '${output.path}/exampleDr.pdf',
                byteList,
              ),
            ),
          );
        });
      });
    }

    return ReusableCard(
      color: colorPalette.darkerPink,
      edgeInsets: edgeInsets,
      paddingInsets: paddingInsets,
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
                right: deleteIconRight,
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
              padding: tenSymmetricPadding,
              child: ReusableCard(
                color: colorPalette.white54,
                edgeInsets: 0.0,
                paddingInsets: 0.0,
                onTap: () {},
                cardChild: Padding(
                  padding: tenAllPadding,
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
                                style: kOnlyBoldTextStyle,
                              ),
                              Padding(
                                padding: tenLeftPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: colorPalette.white54,
                                    ),
                                    tenWidthSizedBox,
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
                                style: kOnlyBoldTextStyle,
                              ),
                              Padding(
                                padding: tenRightPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: colorPalette.white54,
                                    ),
                                    Text(
                                      company.personTwo != null
                                          ? company.personTwo.phoneNumber
                                          : '(---)',
                                      style: TextStyle(
                                        color: colorPalette.white,
                                      ),
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
                        padding: tenAllPadding,
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
              Expanded(
                child: TappableContainer(
                  companyId: company.uid,
                  colors: kColorArrayRev,
                  buttonText: company.revenueBalance.toString(),
                  textColor: colorPalette.white,
                  func: revenueTap,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TappableContainer(
                  companyId: company.uid,
                  colors: kColorArrayPay,
                  buttonText: company.paymentBalance.toString(),
                  textColor: colorPalette.white,
                  func: paymentTap,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TappableContainer(
              companyId: company.uid,
              colors: kColorArrayPay,
              buttonText: 'Get Report for ' + company.companyName,
              textColor: colorPalette.white,
              func: generatePDF,
            ),
          ),
        ],
      ),
    );
  }
}
