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
    revenues.add(<String>['Açıklama', 'Tarih', 'Tutar', 'Durum']);
    List<List<String>> payments = new List<List<String>>();
    payments.add(<String>['Açıklama', 'Tarih', 'Tutar', 'Durum']);
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
        e.processed ? 'İşlendi' : 'İşlenmedi'
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
        e.processed ? 'İşlendi' : 'İşlenmedi'
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
              'PDF',
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
              'Sayfa ${context.pageNumber} / ${context.pagesCount}',
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
                  Text('Partner Raporu', textScaleFactor: 2),
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
                      'Şirket Adı: ${comp.companyName.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Adres: ${comp.address.toString()}',
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Kişi 1: ${comp.personOne.nameAndSurname.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Telefon Numarası: ${comp.personOne.phoneNumber.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Kişi 2: ${comp.personTwo.nameAndSurname.toString()}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Telefon Numarası: ${comp.personTwo.phoneNumber.toString()}',
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
            Header(level: 2, text: 'Gelirler'),
            Table.fromTextArray(context: context, data: revenues),
            SizedBox(height: 10.0),
            Text(
                'Partnerden alınmış toplam tutar : ${pastRevenues.toString()} TL'),
            SizedBox(height: 10.0),
            Text(
                'Partnerden alınması gereken tutar : ${futureRevenues.toString()} TL'),
            SizedBox(height: 50.0),
            Header(level: 2, text: 'Giderler'),
            Table.fromTextArray(context: context, data: payments),
            SizedBox(height: 10.0),
            Text(
                'Partnere ödenmiş toplam tutar : ${pastPayments.toString()} TL'),
            SizedBox(height: 10.0),
            Text(
                'Partnere ödenmesi gereken tutar : ${futurePayments.toString()} TL'),
            SizedBox(height: 50.0),
            Text(
              'Toplam partner bakiyesi : ${(futurePayments - futureRevenues).toString()} TL',
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
    revenues.add(<String>['Şirket', 'Açıklama', 'Tarih', 'Tutar', 'Durum']);
    List<List<String>> payments = new List<List<String>>();
    payments.add(<String>['Şirket', 'Açıklama', 'Tarih', 'Tutar', 'Durum']);
    double futureRevenues = 0.0;
    double futurePayments = 0.0;

    await firebaseCrud.getAllTransactionsForUser().then((allTransactions) {
      Future.delayed(Duration(seconds: 4), () async {
        allTransactions[0].forEach((e) {
          if (!e.processed) {
            futureRevenues += e.amount;
          }
          revenues.add(<String>[
            e.from.split('%')[1],
            e.detail,
            formatter.format(e.date),
            e.amount.toString(),
            e.processed ? 'İşlendi' : 'İşlenmedi'
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
            e.processed ? 'İşlendi' : 'İşlenmedi'
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
                  'CashBook App',
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
                  'Sayfa ${context.pageNumber} / ${context.pagesCount}',
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
                      Text('Şirket Raporu', textScaleFactor: 2),
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
                          'Şirket Adı: ${currUser.companyName.toString()}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'İsim Soyisim: ${currUser.nameAndSurname}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'E-Mail : ${currUser.eMail}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Anlık Nakit Bakiye: ${currUser.currentCashBalance}',
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Toplam Bakiye: ${currUser.currentTotalBalance}',
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '* toplam bakiye gelecekteki tüm gelir ve giderlerin eklendiği varsayımıyla hesaplanmaktadırç.',
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
                Text('Toplam alacak : ${futureRevenues.toString()} TL'),
                SizedBox(height: 50.0),
                Header(level: 2, text: 'Payments'),
                Table.fromTextArray(context: context, data: payments),
                SizedBox(height: 10.0),
                Text('Toplam ödenecek : ${futurePayments.toString()} TL'),
                SizedBox(height: 10.0),
                Text(
                    'Toplam beklenen : ${(futureRevenues - futurePayments).toString()} TL'),
              ];
            },
          ),
        );

        List<int> list;

        final output = await getTemporaryDirectory();

        final file = File("${output.path}/latestoo.pdf");
        await file.writeAsBytes(pdf.save());
        //await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
        //list = pdf.save();

        return await file.readAsBytes();
      });
    });
  }
}
