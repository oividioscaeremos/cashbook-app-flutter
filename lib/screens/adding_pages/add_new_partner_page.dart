import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/complete_pages/home_complete.dart';
import 'package:cash_book_app/complete_pages/partners_complete.dart';
import 'package:cash_book_app/components/custom_phone_textbox.dart';
import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String userId;

class NewPartnerPage extends StatefulWidget {
  NewPartnerPage(String userId) {
    userId = userId;
  }

  @override
  _NewPartnerPageState createState() => _NewPartnerPageState();
}

class _NewPartnerPageState extends State<NewPartnerPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();

  ColorPalette colorPalette = new ColorPalette();
  Company newCompany = new Company();
  Person newPerson1 = new Person();
  Person newPerson2 = new Person();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorPalette.darkBlue,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: colorPalette.darkBlue,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void companyNameChanged(String input) {
      newCompany.companyName = input;
    }

    void companyAddressChanged(String input) {
      newCompany.address = input;
    }

    void personOneNameChanged(String input) {
      print('personOneeeee');
      print(newPerson1.nameAndSurname);
      newPerson1.nameAndSurname = input;
    }

    void personOnePhoneNumberChanged(String input) {
      newPerson1.phoneNumber = input;
    }

    void personTwoNameChanged(String input) {
      newPerson2.nameAndSurname = input;
    }

    void personTwoPhoneNumberChanged(String input) {
      print('changed=' + input);
      newPerson2.phoneNumber = input;
    }

    void addressChanged(String input) {
      newCompany.address = input;
    }

    String companyNameValidator(String input) {
      if (input.isEmpty) {
        return "Company Name cannot be empty.";
      } else if (input.length < 3) {
        return "Company name should at least be 3 characters.";
      }
    }

    String isEmptyValidator(String input) {
      print(input);
      if (input.isEmpty) {
        return "This area cannot be empty.";
      }
    }

    return Scaffold(
      backgroundColor: colorPalette.white,
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(edgeInsets),
              child: Center(
                child: Text(
                  "Add New Company",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: colorPalette.lighterDarkBlue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: edgeInsets,
                right: edgeInsets,
                bottom: edgeInsets,
              ),
              child: CustomTextBox(
                size: borderRadius,
                hintText: "Company Name",
                borderColor: colorPalette.lighterPink,
                function: companyNameChanged,
                keyboardType: TextInputType.text,
                validator: companyNameValidator,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: edgeInsets,
                right: edgeInsets,
                bottom: edgeInsets,
              ),
              child: CustomTextBox(
                size: borderRadius,
                hintText: "Address",
                borderColor: colorPalette.lighterPink,
                function: companyAddressChanged,
                keyboardType: TextInputType.text,
                validator: isEmptyValidator,
                maxLines: 4,
              ),
            ),
            ReusableCard(
              color: Colors.orange,
              onTap: () {},
              edgeInsets: edgeInsets,
              paddingInsets: edgeInsets,
              cardChild: Column(
                children: <Widget>[
                  Text(
                    'Person One',
                    style: kAddPartnerPersonNameTextStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomTextBox(
                        size: borderRadius,
                        hintText: "Name and Surname",
                        borderColor: colorPalette.white,
                        function: personOneNameChanged,
                        keyboardType: TextInputType.text,
                        validator: isEmptyValidator,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomPhoneTextBox(
                        size: borderRadius,
                        hintText: "Phone Number",
                        borderColor: colorPalette.white,
                        function: personOnePhoneNumberChanged,
                        keyboardType: TextInputType.number,
                        validator: isEmptyValidator,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ReusableCard(
              color: Colors.orange,
              onTap: () {},
              edgeInsets: edgeInsets,
              paddingInsets: edgeInsets,
              cardChild: Column(
                children: <Widget>[
                  Text(
                    'Person Two',
                    style: kAddPartnerPersonNameTextStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomTextBox(
                        size: borderRadius,
                        hintText: "Name and Surname",
                        borderColor: colorPalette.white,
                        function: personTwoNameChanged,
                        keyboardType: TextInputType.text,
                        validator: isEmptyValidator,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomPhoneTextBox(
                        size: borderRadius,
                        hintText: "Phone Number",
                        borderColor: colorPalette.white,
                        function: personTwoPhoneNumberChanged,
                        keyboardType: TextInputType.number,
                        validator: isEmptyValidator,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
              child: Material(
                elevation: 5.0,
                color: colorPalette.lighterDarkBlue,
                borderRadius: BorderRadius.circular(10.0),
                child: MaterialButton(
                  minWidth: double.maxFinite,
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      newCompany.personOne = newPerson1;
                      newCompany.personTwo = newPerson2;
                      _firebaseCrud.createCompany(newCompany);

                      setState(() {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PartnersComplete(userId)));
                      });
                    }
                  },
                  child: Text(
                    "Create Company",
                    style: TextStyle(
                      color: colorPalette.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
