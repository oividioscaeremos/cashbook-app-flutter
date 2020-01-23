import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/components/custom_textbox.dart';
import 'package:cash_book_app/components/reusable_card.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/styles/color_palette.dart';
import 'package:cash_book_app/styles/home_page_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String globalFrom, globalTo;
String currUserID;
List<DropdownMenuItem<String>> ourCompItem =
    new List<DropdownMenuItem<String>>();

List<DropdownMenuItem<String>> theirCompItem =
    new List<DropdownMenuItem<String>>();

String otherCompanyName;
var formatter = new DateFormat("dd.MM.yyyy");
DateTime now = new DateTime.now();

class NewTransactionPage extends StatefulWidget {
  NewTransactionPage({String from, String to, String currUser}) {
    globalFrom = from;
    globalTo = to;
    currUserID = currUser;
  }

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
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

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  FirebaseCrud _firebaseCrud = new FirebaseCrud();
  ColorPalette colorPalette = new ColorPalette();
  TransactionApp newTransaction = new TransactionApp(date: DateTime.now());
  String selectedItemFrom;
  String selectedItemTo;
  String transactionDate = formatter.format(now);
  int amount;

  @override
  Widget build(BuildContext context) {
    void showCalender() {
      showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: DateTime(2018),
              lastDate: DateTime(2021))
          .then((date) {
        if (date != null) {
          setState(() {
            transactionDate = formatter.format(date);
            newTransaction.date = date;
          });
        }
      });
    }

    if (ourCompItem.indexOf(
            DropdownMenuItem(child: Text('Our Company'), value: currUserID)) !=
        -1) {
      ourCompItem.add(
          new DropdownMenuItem(child: Text('Our Company'), value: currUserID));
    }

    void amountChanged(String input) {
      newTransaction.amount = double.parse(input);
    }

    void detailChanged(String input) {
      newTransaction.detail = input;
    }

    String isEmptyValidator(String input) {
      print(input);
      if (input.isEmpty) {
        return "This area cannot be empty.";
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorPalette.white,
        body: Form(
          key: _globalKey,
          child: Container(
            child: StreamBuilder(
              stream: _firebaseCrud.getCompanies(currUserID),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (ourCompItem.indexOf(DropdownMenuItem(
                        child: Text("Our Company"),
                        value: currUserID,
                      )) !=
                      -1) {
                    theirCompItem.add(new DropdownMenuItem(
                      child: Text("Our Company"),
                      value: currUserID,
                    ));
                  }
                  List<Company> currentCompanies = new List<Company>();

                  snapshot.data.documents.forEach((f) {
                    Company comp = new Company(
                        uid: f.reference.documentID,
                        companyName: f.data['properties']['companyName'],
                        address: f.data['properties']['address'],
                        paymentBalance: double.parse(
                            f.data['currentPaymentBalance'].toString()),
                        revenueBalance: double.parse(
                            f.data['currentRevenueBalance'].toString()),
                        personOne: new Person(
                            phoneNumber: f.data['properties']['personOne']
                                ['phoneNumber'],
                            nameAndSurname: f.data['properties']['personOne']
                                ['nameAndSurname']),
                        personTwo: new Person(
                            phoneNumber: f.data['properties']['personTwo']
                                ['phoneNumber'],
                            nameAndSurname: f.data['properties']['personTwo']
                                ['nameAndSurname']));

                    if (currentCompanies.indexOf(comp) == -1) {
                      currentCompanies.add(comp);
                      if (comp.uid == globalTo || comp.uid == globalFrom) {
                        otherCompanyName = comp.companyName;
                        if (theirCompItem.indexOf(DropdownMenuItem(
                              child: Text(comp.companyName),
                              value: comp.uid,
                            )) !=
                            -1) {
                          theirCompItem.add(new DropdownMenuItem(
                            child: Text(comp.companyName),
                            value: comp.uid,
                          ));
                        }
                      }
                    }
                  });

                  if (globalFrom != null && globalTo != null) {
                    return ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(edgeInsets),
                          child: Center(
                            child: Text(
                              globalFrom == currUserID
                                  ? "New Payment to " + otherCompanyName
                                  : "New Revenue from " + otherCompanyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: colorPalette.lighterDarkBlue,
                              ),
                            ),
                          ),
                        ),
                        ReusableCard(
                          color: Colors.orange,
                          onTap: () {},
                          edgeInsets: edgeInsets,
                          paddingInsets: edgeInsets,
                          cardChild: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorPalette.white,
                                      border: Border.all(
                                        width: 2.0,
                                        color: colorPalette.orange,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        items: globalFrom == currUserID
                                            ? ourCompItem
                                            : theirCompItem,
                                        hint: globalFrom == currUserID
                                            ? Text('From : Our Company')
                                            : Text(
                                                'From : ' + otherCompanyName),
                                        onChanged: (newVal) {},
                                        value: selectedItemFrom,
                                        focusColor: Colors.blue,
                                        iconSize: 35.0,
                                        isExpanded: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorPalette.white,
                                      border: Border.all(
                                        width: 2.0,
                                        color: colorPalette.orange,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton(
                                        hint: globalTo == currUserID
                                            ? Text('To : Our Company')
                                            : Text('To : ' + otherCompanyName),
                                        items: globalTo == currUserID
                                            ? ourCompItem
                                            : theirCompItem,
                                        onChanged: (newVal) {
                                          setState(() {
                                            selectedItemTo = newVal;
                                          });
                                        },
                                        value: selectedItemTo,
                                        iconSize: 35.0,
                                        isExpanded: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 0.0,
                                    ),
                                    child: Material(
                                      elevation: 5.0,
                                      color: colorPalette.lighterDarkBlue,
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: MaterialButton(
                                        minWidth: double.maxFinite,
                                        onPressed: () {
                                          showCalender();
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.calendar_today,
                                              color: colorPalette.white,
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Text(
                                              "Date : " + transactionDate,
                                              style: TextStyle(
                                                color: colorPalette.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              "(day/month/year)",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colorPalette.white54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: edgeInsets,
                                    ),
                                    child: CustomTextBox(
                                      size: borderRadius,
                                      hintText: "Amount",
                                      borderColor: colorPalette.darkBlue,
                                      function: amountChanged,
                                      keyboardType: TextInputType.number,
                                      validator: isEmptyValidator,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: edgeInsets,
                                    ),
                                    child: CustomTextBox(
                                      size: borderRadius,
                                      hintText: "Details",
                                      borderColor: colorPalette.darkBlue,
                                      function: detailChanged,
                                      keyboardType: TextInputType.text,
                                      validator: isEmptyValidator,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 100.0),
                          child: Material(
                            elevation: 5.0,
                            color: colorPalette.lighterDarkBlue,
                            borderRadius: BorderRadius.circular(10.0),
                            child: MaterialButton(
                              minWidth: double.maxFinite,
                              onPressed: () {
                                if (_globalKey.currentState.validate()) {
                                  newTransaction.from = globalFrom;
                                  newTransaction.to = globalTo;
                                  if (newTransaction.date
                                          .compareTo(new DateTime.now()) <=
                                      0) {
                                    newTransaction.processed = true;
                                  } else {
                                    newTransaction.processed = false;
                                  }

                                  if (globalFrom == currUserID) {
                                    _firebaseCrud.addTransaction(
                                        newTransaction, false);
                                  } else {
                                    _firebaseCrud.addTransaction(
                                        newTransaction, true);
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                globalFrom == currUserID
                                    ? "Add Payment"
                                    : "Add Revenuse",
                                style: TextStyle(
                                  color: colorPalette.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (globalFrom != null) {
                    print("here2");
                    return ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(edgeInsets),
                          child: Center(
                            child: Text(
                              globalFrom == currUserID
                                  ? "New Payment to " + otherCompanyName
                                  : "New Revenue from " + otherCompanyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: colorPalette.lighterDarkBlue,
                              ),
                            ),
                          ),
                        ),
                        ReusableCard(
                          color: Colors.orange,
                          onTap: () {},
                          edgeInsets: edgeInsets,
                          paddingInsets: edgeInsets,
                          cardChild: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  DropdownButton(
                                    items: globalFrom == currUserID
                                        ? ourCompItem
                                        : currentCompanies.map((c) {
                                            return DropdownMenuItem<String>(
                                              value: c.uid,
                                              child: Text(c.companyName),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      globalFrom = newValue;
                                    },
                                    hint: Text('Select Company'),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  DropdownButton(
                                    items: globalFrom == currUserID
                                        ? ourCompItem
                                        : currentCompanies.map((c) {
                                            return DropdownMenuItem<String>(
                                              value: c.uid,
                                              child: Text(c.companyName),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      globalFrom = newValue;
                                    },
                                    hint: Text('Select Company'),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: edgeInsets,
                                    ),
                                    child: CustomTextBox(
                                      size: borderRadius,
                                      hintText: "Amount",
                                      borderColor: colorPalette.lighterPink,
                                      function: amountChanged,
                                      keyboardType: TextInputType.number,
                                      validator: isEmptyValidator,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 100.0),
                          child: Material(
                            elevation: 5.0,
                            color: colorPalette.lighterDarkBlue,
                            borderRadius: BorderRadius.circular(10.0),
                            child: MaterialButton(
                              minWidth: double.maxFinite,
                              onPressed: () {
                                if (_globalKey.currentState.validate()) {
                                  setState(() {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                }
                              },
                              child: Text(
                                globalFrom == currUserID
                                    ? "Add Payment"
                                    : "Add Revenuse",
                                style: TextStyle(
                                  color: colorPalette.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (globalTo != null) {
                    print("here3");
                    return ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(edgeInsets),
                          child: Center(
                            child: Text(
                              globalFrom == currUserID
                                  ? "New Payment"
                                  : "New Revenue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: colorPalette.lighterDarkBlue,
                              ),
                            ),
                          ),
                        ),
                        ReusableCard(
                          color: Colors.orange,
                          onTap: () {},
                          edgeInsets: edgeInsets,
                          paddingInsets: edgeInsets,
                          cardChild: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  DropdownButton(
                                    items: globalFrom == currUserID
                                        ? ourCompItem
                                        : currentCompanies.map((c) {
                                            return DropdownMenuItem<String>(
                                              value: c.uid,
                                              child: Text(c.companyName),
                                            );
                                          }).toList(),
                                    onChanged: (newValue) {
                                      globalFrom = newValue;
                                    },
                                    hint: Text('Select Company'),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: edgeInsets,
                                    ),
                                    child: CustomTextBox(
                                      size: borderRadius,
                                      hintText: "Amount",
                                      borderColor: colorPalette.lighterPink,
                                      function: amountChanged,
                                      keyboardType: TextInputType.text,
                                      validator: isEmptyValidator,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 100.0),
                          child: Material(
                            elevation: 5.0,
                            color: colorPalette.lighterDarkBlue,
                            borderRadius: BorderRadius.circular(10.0),
                            child: MaterialButton(
                              minWidth: double.maxFinite,
                              onPressed: () {
                                if (_globalKey.currentState.validate()) {
                                  setState(() {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                }
                              },
                              child: Text(
                                globalFrom == currUserID
                                    ? "Add Payment"
                                    : "Add Revenuse",
                                style: TextStyle(
                                  color: colorPalette.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
