import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/components/custom_tappable_container.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/components/single_Partner_view.dart';
import 'package:cash_book_app/screens/adding_pages/add_new_partner_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:flutter/material.dart';

String userid;

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
  List<Company> ourCompanies = new List<Company>();

  @override
  void initState() {
    super.initState();
    print("partners init");
  }

  showPaymentsToCompany(String cId) {
    print(cId);
  }

  showRevenuesFromCompany(String cId) {}

  void addNewPartner() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NewPartnerPage(userid)));
    });
  }

  Widget addNewPartnerWidget(Company company, int index) {
    print('companySomethng');
    print(company.personTwo);
    return SinglePartner(
      company: ourCompanies[index],
      revenueTap: showRevenuesFromCompany(company.uid),
      paymentTap: showPaymentsToCompany(company.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> paymentGradient = [
      /*Color(0xffF5D020),
      Color(0xffF53803),*/
      colorPalette.darkBlue,
      colorPalette.darkBlue
    ];

    List<Color> revenueGradient = [Color(0xff21bc87), Color(0xff129b8e)];

    return FutureBuilder(
      future: _firebaseCrud.getCompanies(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ourCompanies = snapshot.data;
          for (var d in snapshot.data) {
            return Scaffold(
              appBar: PreferredSize(
                child:
                    CustomAppBar("Partners", Icons.add_circle, addNewPartner),
                preferredSize: new Size(
                  MediaQuery.of(context).size.width,
                  60.0,
                ),
              ),
              backgroundColor: colorPalette.darkGrey,
              body: new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      addNewPartnerWidget(d, index)),

              //addNewPartnerWidget(d),
            );
          }
        }
        return Scaffold(
          appBar: PreferredSize(
            child: CustomAppBar("Partners", Icons.add_circle, addNewPartner),
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
      },
    );
  }
}
