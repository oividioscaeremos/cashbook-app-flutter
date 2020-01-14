import 'package:cash_book_app/components/custom_tappable_container.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/services/auth_service.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _buttonGradientColors = [
      colorPalette.orange,
      colorPalette.middlePink,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPalette.darkBlue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Partners",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: colorPalette.white,
            ),
            onPressed: () {
              setState(() {
                AuthService authservice = new AuthService();
                authservice.signOut();
              });
            },
          )
        ],
      ),
      backgroundColor: colorPalette.darkGrey,
      body: Container(
        color: colorPalette.darkGrey,
        child: Column(
          children: <Widget>[
            ReusableCard(
              color: colorPalette.orange,
              onTap: () {},
              cardChild: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "HELLO",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: colorPalette.darkBlue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TappableContainer(
                        colors: _buttonGradientColors,
                        buttonText: "1250",
                        textColor: colorPalette.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              "HELLO",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: colorPalette.darkBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
