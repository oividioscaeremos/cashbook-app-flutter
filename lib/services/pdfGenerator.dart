import 'dart:io';
import 'dart:typed_data';
import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/classes/User.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cash_book_app/services/firebase_crud.dart';
import 'package:cash_book_app/services/pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PDFGenerator {
  FirebaseCrud firebaseCrud = new FirebaseCrud();

  Future<List<int>> GeneratePDFForCompany(String cID) async {
    final fontData =
        await rootBundle.load('lib/assets/fonts/LexendPeta-Regular.ttf');

    var data = fontData.buffer.asByteData();
    var myFont = Font.ttf(data);

    List<List<TransactionApp>> allTransactions;
    final Document pdf = new Document();
    AuthService _authService = new AuthService();
    var formatter = new DateFormat("dd.MM.yyyy");

    FirebaseUser currUser = await _authService.getCurrentUser();
    Company comp = await firebaseCrud.getSingleCompanyFromID(cID);
    allTransactions =
        await firebaseCrud.getAllTransactionsForCompany(cID, currUser.uid);

    List<List<String>> revenues = new List<List<String>>();
    revenues.add(<String>['Details', 'Date', 'Amount', 'State']);
    List<List<String>> payments = new List<List<String>>();
    payments.add(<String>['Details', 'Date', 'Amount', 'State']);
    double futureRevenues = 0.0;
    double futurePayments = 0.0;
    double pastPayments = 0.0;
    double pastRevenues = 0.0;

    allTransactions[0]
        .sort((a, b) => a.date.compareTo(b.date)); // sort date ascending
    allTransactions[1]
        .sort((a, b) => a.date.compareTo(b.date)); // sort date ascending

    allTransactions[0].forEach((e) {
      if (!e.processed) {
        futureRevenues += e.amount;
      } else {
        pastRevenues += e.amount;
      }
      revenues.add(<String>[
        e.detail,
        formatter.format(e.date),
        e.amount.toString(),
        e.processed ? 'Processed' : 'Not Processed'
      ]);
    });

    allTransactions[1].forEach((e) {
      if (!e.processed) {
        futurePayments += e.amount;
      } else {
        pastPayments += e.amount;
      }
      payments.add(<String>[
        e.detail,
        formatter.format(e.date),
        e.amount.toString(),
        e.processed ? 'Processed' : 'Not Processed'
      ]);
    });

    var myTheme = Theme.withFont(
      base: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-Regular.ttf")),
      bold:
          Font.ttf(await rootBundle.load("lib/assets/fonts/OpenSans-Bold.ttf")),
      italic: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-BoldItalic.ttf")),
    );

    pdf.addPage(
      MultiPage(
        theme: myTheme,
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text(
              'Portable Document Format',
              style: Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey),
            ),
          );
        },
        footer: (Context context) {
          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey),
            ),
          );
        },
        build: (Context context) {
          return <Widget>[
            Header(
              level: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Partner Report', textScaleFactor: 2),
                  PdfLogo()
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Company Name: ${comp.companyName.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Address: ${comp.address.toString()}',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Person One: ${comp.personOne.nameAndSurname.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Phone Number: ${comp.personOne.phoneNumber.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Person Two: ${comp.personTwo.nameAndSurname.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Phone Number: ${comp.personTwo.phoneNumber.toString()}',
                    ),
                  ],
                ),
              ],
            ),
            Header(
              level: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[],
              ),
            ),
            Header(level: 2, text: 'Revenues'),
            Table.fromTextArray(context: context, data: revenues),
            SizedBox(height: 10.0),
            Text(
                'Total revenues from this company : ${pastRevenues.toString()} TL'),
            SizedBox(height: 10.0),
            Text(
                'Total amount to claim from this company : ${futureRevenues.toString()} TL'),
            SizedBox(height: 50.0),
            Header(level: 2, text: 'Payments'),
            Table.fromTextArray(context: context, data: payments),
            SizedBox(height: 10.0),
            Text(
                'Total payments to this company : ${pastPayments.toString()} TL'),
            SizedBox(height: 10.0),
            Text(
                'Total amount to pay to this company : ${futurePayments.toString()} TL'),
            SizedBox(height: 50.0),
            Text(
              'Total company balance : ${(futurePayments - futureRevenues).toString()} TL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ];
        },
      ),
    );

    List<int> list;

    final output = await getTemporaryDirectory();

    final file = File("${output.path}/exampleDr.pdf");
    await file.writeAsBytes(pdf.save());
    //await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
    list = pdf.save();

    return list;
  }

  Future<User> getUser() async {
    Firestore service = new Firestore();
    AuthService authService = new AuthService();

    FirebaseUser user = await authService.getCurrentUser();
    DocumentSnapshot ds =
        await service.collection('users').document(user.uid).get();

    User ourUser = new User(
      nameAndSurname: ds.data['properties']['nameAndSurname'],
      companyName: ds.data['properties']['companyName'],
      eMail: ds.data['properties']['eMail'],
      currCashBalance:
          double.parse(ds.data['properties']['currentCashBalance'].toString()),
      currTotalBalance: double.parse(
        ds.data['properties']['currentTotalBalance'].toString(),
      ),
    );

    return ourUser;
  }

  Future<List<int>> GenerateGeneralPDF() async {
    User currUser = await getUser();

    var myTheme = Theme.withFont(
      base: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-Regular.ttf")),
      bold:
          Font.ttf(await rootBundle.load("lib/assets/fonts/OpenSans-Bold.ttf")),
      italic: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("lib/assets/fonts/OpenSans-BoldItalic.ttf")),
    );

    final Document pdf = new Document();
    var formatter = new DateFormat("dd.MM.yyyy");

    List<List<String>> revenues = new List<List<String>>();
    revenues.add(<String>['Company', 'Details', 'Date', 'Amount', 'State']);
    List<List<String>> payments = new List<List<String>>();
    payments.add(<String>['Company', 'Details', 'Date', 'Amount', 'State']);
    double futureRevenues = 0.0;
    double futurePayments = 0.0;

    firebaseCrud.getAllTransactionsForUser().then((allTransactions) {
      Future.delayed(Duration(seconds: 3), () async {
        allTransactions[0].forEach((e) {
          if (!e.processed) {
            futureRevenues += e.amount;
          }
          revenues.add(<String>[
            e.from.split('%')[1],
            e.detail,
            formatter.format(e.date),
            e.amount.toString(),
            e.processed ? 'Processed' : 'Not Processed'
          ]);
          print('revenues[revenues.length -1].toString()');
          print(revenues[revenues.length - 1].toString());
        });

        allTransactions[1].forEach((e) {
          if (!e.processed) {
            futurePayments += e.amount;
          }
          payments.add(<String>[
            e.to.split('%')[1],
            e.detail,
            formatter.format(e.date),
            e.amount.toString(),
            e.processed ? 'Processed' : 'Not Processed'
          ]);
        });

        pdf.addPage(
          MultiPage(
            theme: myTheme,
            pageFormat: PdfPageFormat.letter
                .copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
            crossAxisAlignment: CrossAxisAlignment.start,
            header: (Context context) {
              if (context.pageNumber == 1) {
                return null;
              }
              return Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                decoration: const BoxDecoration(
                    border: BoxBorder(
                        bottom: true, width: 0.5, color: PdfColors.grey)),
                child: Text(
                  'CashBook Application',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
                ),
              );
            },
            footer: (Context context) {
              return Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
                ),
              );
            },
            build: (Context context) {
              return <Widget>[
                Header(
                  level: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Company Report', textScaleFactor: 2),
                      PdfLogo()
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Company Name: ${currUser.companyName.toString()}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Name and Surname: ${currUser.nameAndSurname}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'E-Mail : ${currUser.eMail}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Current Cash Balance: ${currUser.currentCashBalance}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Current Total Balance: ${currUser.currentTotalBalance}',
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '* total balance shows the balance when all the future revenues and payments are processed.',
                          style: TextStyle(
                            fontSize: 8.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Header(
                  level: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ),
                Header(level: 2, text: 'Revenues'),
                Table.fromTextArray(context: context, data: revenues),
                SizedBox(height: 10.0),
                Text('Total amount to claim : ${futureRevenues.toString()} TL'),
                SizedBox(height: 50.0),
                Header(level: 2, text: 'Payments'),
                Table.fromTextArray(context: context, data: payments),
                SizedBox(height: 10.0),
                Text('Total amount to pay : ${futurePayments.toString()} TL'),
                SizedBox(height: 10.0),
                Text(
                    'Total company expectation : ${(futureRevenues - futurePayments).toString()} TL'),
              ];
            },
          ),
        );

        List<int> list;

        final output = await getTemporaryDirectory();

        final file = File("${output.path}/exampleDr.pdf");
        await file.writeAsBytes(pdf.save());
        //await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
        list = pdf.save();

        return list;
      });
    });
  }
}
