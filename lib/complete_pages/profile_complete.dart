import 'package:cash_book_app/classes/User.dart';
import 'package:cash_book_app/complete_pages/loadingScreen.dart';
import 'package:cash_book_app/components/custom_appBar.dart';
import 'package:cash_book_app/components/custom_tappable_container.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/screens/regular_pages/welcome_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/services/pdfGenerator.dart';
import 'package:cash_book_app/services/pdf_viewer.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/constants.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String userid;
User ourUser;

class ProfileComplete extends StatefulWidget {
  ProfileComplete(String uid) {
    userid = uid;
  }
  @override
  _ProfileCompleteState createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  ColorPalette colorPalette = new ColorPalette();
  AuthService _authService = new AuthService();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  String cNameBefore = '';

  @override
  void initState() {
    super.initState();
  }

  String newCompanyName, newNameAndSurname;

  void companyNameChanged(String input) {
    newCompanyName = input;
  }

  void nameAndSurnameChanged(String input) {
    newNameAndSurname = input;
  }

  void signOut() {
    const double fontSize = 16.0;

    Alert(
      type: AlertType.warning,
      context: context,
      title: "Change",
      desc: 'Do you want to sign out?',
      buttons: [
        DialogButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(
            "No",
            style: TextStyle(
              color: colorPalette.darkBlue,
              fontSize: fontSize,
            ),
          ),
          color: colorPalette.white54,
        ),
        DialogButton(
          onPressed: () {
            setState(() {
              _authService.signOut();
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(),
                ),
              );
            });
          },
          child: Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        )
      ],
    ).show();
  }

  void generatePDF() {
    PDFGenerator pdfGenerator = new PDFGenerator();
    getTemporaryDirectory().then((output) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(),
        ),
      );
      pdfGenerator.GenerateGeneralPDF().then((byteList) {
        Future.delayed(Duration(seconds: 4), () {
          Navigator.pop(context);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16.0;
    const double edgeInsets = 10.0;

    return StreamBuilder(
      stream: _firebaseCrud.getUserDetails(userid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: PreferredSize(
              child: CustomAppBar("Profile", Icons.highlight_off, signOut),
              preferredSize: new Size(
                MediaQuery.of(context).size.width,
                kAppBarHeight,
              ),
            ),
            backgroundColor: colorPalette.darkGrey,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ReusableCard(
                          color: colorPalette.lighterPink,
                          onTap: () {},
                          cardChild: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  'Company Name: ${snapshot.data['properties']['companyName']}',
                                  style: kCompanyNameTextStyle),
                              GestureDetector(
                                onTap: () {
                                  Alert(
                                      context: context,
                                      title: "Change",
                                      content: Column(
                                        children: <Widget>[
                                          TextField(
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.description),
                                              labelText: snapshot
                                                  .data['properties']
                                                      ['companyName']
                                                  .toString(),
                                            ),
                                            onChanged: companyNameChanged,
                                          ),
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          onPressed: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: colorPalette.darkBlue,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          color: colorPalette.white54,
                                        ),
                                        DialogButton(
                                          onPressed: () {
                                            setState(() {
                                              _firebaseCrud.updateUser(
                                                  userid, newCompanyName, true);
                                            });

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: Text(
                                            "Change",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                        )
                                      ]).show();
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: colorPalette.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          edgeInsets: edgeInsets,
                          paddingInsets: edgeInsets,
                        ),
                        ReusableCard(
                          color: colorPalette.lighterPink,
                          onTap: () {},
                          cardChild: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Name and Surname: ${snapshot.data['properties']['nameAndSurname']}',
                                style: kProfileNameAndSurnameTextStyle,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Alert(
                                      context: context,
                                      title: "Change",
                                      content: Column(
                                        children: <Widget>[
                                          TextField(
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.description),
                                              labelText: snapshot
                                                  .data['properties']
                                                      ['nameAndSurname']
                                                  .toString(),
                                            ),
                                            onChanged: nameAndSurnameChanged,
                                          ),
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          onPressed: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: colorPalette.darkBlue,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          color: colorPalette.white54,
                                        ),
                                        DialogButton(
                                          onPressed: () {
                                            setState(() {
                                              _firebaseCrud.updateUser(userid,
                                                  newNameAndSurname, false);
                                            });

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: Text(
                                            "Change",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                        )
                                      ]).show();
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: colorPalette.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          edgeInsets: edgeInsets,
                          paddingInsets: edgeInsets,
                        ),
                        Padding(
                          padding: tenAllPadding,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  generatePDF();
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: zeroAllPadding,
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: kGetReportGradient,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  constraints:
                                      kBoxConstraints, // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Get General Report',
                                    style: TextStyle(
                                      color: colorPalette.darkerPink,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
