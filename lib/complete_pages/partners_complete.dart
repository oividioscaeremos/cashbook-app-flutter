import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/components/custom_tappable_container.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/components/single_Partner_view.dart';
import 'package:cash_book_app/screens/adding_pages/add_new_partner_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_payments_for_partner_page.dart';
import 'package:cash_book_app/screens/viewing_pages/view_revenues_for_partner_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userid;
List<Company> ourCompanies = new List<Company>();

class PartnersComplete extends StatefulWidget {
  PartnersComplete(String uid) {
    userid = uid;
  }

  @override
  _PartnersCompleteState createState() => _PartnersCompleteState();
}

class _PartnersCompleteState extends State<PartnersComplete> {
  ColorPalette colorPalette = new ColorPalette();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();

  @override
  void initState() {
    super.initState();
  }

  void addNewPartner() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NewPartnerPage(userid)));
  }

  showPaymentsToCompany(String cId) {
    print('cId');
    print(cId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewPaymentsForPartner(cId, userid)));
    //Navigator.push(context, route)
  }

  showRevenuesFromCompany(String cId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewRevenuesForPartner(cId, userid)));
    print(cId);
  }

  Widget addNewPartnerWidget(Company company, int index, Function dialogFun) {
    return SinglePartner(
      company: ourCompanies[index],
      revenueTap: showRevenuesFromCompany,
      paymentTap: showPaymentsToCompany,
      showOurDialogFunc: dialogFun,
    );
  }

  List<Company> buildCurrentCompanies(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Company> currentCompanies = new List<Company>();

    snapshot.data.documents.forEach((f) {
      Company comp = new Company(
        uid: f.reference.documentID,
        companyName: f.data['properties']['companyName'],
        address: f.data['properties']['address'],
        paymentBalance:
            double.parse(f.data['currentPaymentBalance'].toString()),
        revenueBalance:
            double.parse(f.data['currentRevenueBalance'].toString()),
        personOne: new Person(
            phoneNumber: f.data['properties']['personOne']['phoneNumber'],
            nameAndSurname: f.data['properties']['personOne']
                ['nameAndSurname']),
        personTwo: new Person(
          phoneNumber: f.data['properties']['personTwo']['phoneNumber'],
          nameAndSurname: f.data['properties']['personTwo']['nameAndSurname'],
        ),
      );

      if (currentCompanies.indexOf(comp) == -1) {
        currentCompanies.add(comp);
      }
    });

    return currentCompanies;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> paymentGradient = [
      colorPalette.darkBlue,
      colorPalette.darkBlue
    ];

    List<Color> revenueGradient = [Color(0xff21bc87), Color(0xff129b8e)];

    return StreamBuilder(
      stream: _firebaseCrud.getCompanies(userid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ourCompanies = buildCurrentCompanies(snapshot);

          for (var d in ourCompanies) {
            return Scaffold(
              appBar: PreferredSize(
                child: CustomAppBar(
                    "İş Ortaklarınız", Icons.add_circle, addNewPartner),
                preferredSize: new Size(
                  MediaQuery.of(context).size.width,
                  kAppBarHeight,
                ),
              ),
              backgroundColor: colorPalette.darkGrey,
              body: new ListView.builder(
                  itemCount: ourCompanies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return addNewPartnerWidget(d, index, () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        closeFunction: () {},
                        title:
                            "${ourCompanies[index].companyName.toUpperCase()} Firmasını Sil",
                        desc:
                            "Bu işlem geri alınamaz, devam etmek istiyor musunuz?",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Evet",
                              style: kAlertButtonTextStyle,
                            ),
                            onPressed: () async {
                              await _firebaseCrud
                                  .deleteCompany(ourCompanies[index]);
                              Future.delayed(Duration(milliseconds: 2300), () {
                                setState(() {
                                  ourCompanies =
                                      buildCurrentCompanies(snapshot);
                                });
                              });
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            color: kAlertColor,
                          ),
                          DialogButton(
                            child: Text(
                              "Hayır",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            gradient: kAlertGradient,
                          )
                        ],
                      ).show();
                    });
                  }),
            );
          }
        }
        return Scaffold(
          appBar: PreferredSize(
            child: CustomAppBar(
                "İş Ortaklarınız", Icons.add_circle, addNewPartner),
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
      },
    );
  }
}
