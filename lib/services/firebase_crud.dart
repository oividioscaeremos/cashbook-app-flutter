import 'dart:collection';
import 'dart:convert';

import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/classes/User.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_database/firebase_database.dart';

class FirebaseCrud {
  final Firestore _firestore = Firestore.instance;
  AuthService _authService = new AuthService();

  Stream<DocumentSnapshot> getCurrentCashBalance(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
  }

  Stream<DocumentSnapshot> getCurrentTotalBalance(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
  }

  String getCurrentUserId() {
    _authService.getCurrentUser().then((user) {
      print('getting user here = ${user.uid}');
      return user.uid;
    });
  }

  Future<FirebaseUser> getCurrentUserIdAsync() async {
    return await _authService.getCurrentUser();
  }

  Stream<DocumentSnapshot> getUserDetails(String userid) {
    return _firestore.collection('users').document(userid).get().asStream();
  }

  void updateUser(String userId, String data, bool isCompanyName) {
    if (isCompanyName) {
      _firestore
          .collection('users')
          .document(userId)
          .updateData({'properties.companyName': data});
    } else {
      _firestore
          .collection('users')
          .document(userId)
          .updateData({'properties.nameAndSurname': data});
    }
  }

  Future<String> createCompany(Company company) async {
    FirebaseUser currentUser = await _authService.getCurrentUser();

    Firestore.instance.runTransaction((Transaction transaction) async {
      await Firestore.instance.collection('companies').add({
        'belongsTo': currentUser.uid,
        'currentPaymentBalance': 0,
        'currentRevenueBalance': 0,
        'payments': [],
        'revenues': [],
        'properties': {
          'address': company.address,
          'companyName': company.companyName,
          'personOne': {
            'nameAndSurname': company.personOne.nameAndSurname,
            'phoneNumber': company.personOne.phoneNumber
          },
          'personTwo': {
            'nameAndSurname': company.personTwo != null
                ? company.personTwo.nameAndSurname
                : '',
            'phoneNumber':
                company.personTwo != null ? company.personTwo.phoneNumber : '',
          }
        }
      }).then((docRef) async {
        String docID = docRef.documentID;

        DocumentSnapshot userSnapshot = await Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .get();
        DocumentReference userRef =
            _firestore.collection('users').document(currentUser.uid);

        List partners = userSnapshot.data['partners'];
        if (!partners.contains(docID)) {
          userRef.updateData({
            'partners': FieldValue.arrayUnion([docID])
          });
        }

        return currentUser.uid;
      });
    });
  }

  Stream<QuerySnapshot> getCompanies(String id) {
    return _firestore
        .collection('companies')
        .where('belongsTo', isEqualTo: id)
        //.orderBy("properties.companyName", descending: true)
        .getDocuments()
        .asStream();
  }

  String getSingleCompanyNameFromID(String id) {
    _firestore.collection('companies').document(id).get().then((snapShot) {
      print('snapShot.data["properties"]["companyName"]');
      print(snapShot.data["properties"]["companyName"]);
      return snapShot.data["properties"]["companyName"];
    });
  }

  Future<String> getSingleCompanyNameFromIDasync(String id) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('companies').document(id).get();

    return documentSnapshot.data["properties"]["companyName"];
  }

  Future<Company> getSingleCompanyFromID(String id) async {
    DocumentSnapshot docSS =
        await _firestore.collection('companies').document(id).get();

    return new Company(
      uid: docSS.reference.documentID,
      companyName: docSS.data['properties']['companyName'],
      address: docSS.data['properties']['address'],
      paymentBalance:
          double.parse(docSS.data['currentPaymentBalance'].toString()),
      revenueBalance:
          double.parse(docSS.data['currentRevenueBalance'].toString()),
      personOne: new Person(
          phoneNumber: docSS.data['properties']['personOne']['phoneNumber'],
          nameAndSurname: docSS.data['properties']['personOne']
              ['nameAndSurname']),
      personTwo: new Person(
        phoneNumber: docSS.data['properties']['personTwo']['phoneNumber'],
        nameAndSurname: docSS.data['properties']['personTwo']['nameAndSurname'],
      ),
    );
  }

  Future<void> addTransaction(
      TransactionApp ourTransaction, bool isRevenue) async {
    FirebaseUser curruser = await _authService.getCurrentUser();

    if (isRevenue) {
      var user = _firestore.collection('users').document(curruser.uid);

      _firestore.collection('revenues').add({
        'from': ourTransaction.from,
        'to': ourTransaction.to,
        'date': ourTransaction.date,
        'amount': ourTransaction.amount,
        'isProcessed': ourTransaction.processed,
        'details': ourTransaction.detail
      }).then((docReferenceOfTheTransaction) async {
        docReferenceOfTheTransaction
            .updateData({"tID": docReferenceOfTheTransaction.documentID});

        DocumentSnapshot docSS =
            await _firestore.collection('users').document(curruser.uid).get();
        DocumentReference dbRefUser =
            _firestore.collection('users').document(curruser.uid);

        if (ourTransaction.processed) {
          double currentCashBalance = double.parse(
              docSS['properties']['currentCashBalance'].toString());

          print("currentCashBalance");
          print(currentCashBalance);

          dbRefUser.updateData({
            "properties.currentCashBalance":
                currentCashBalance + ourTransaction.amount
          });
        } else {
          DocumentSnapshot docSSPartner = await _firestore
              .collection("companies")
              .document(ourTransaction.from)
              .get();
          DocumentReference dbRefPartner = await _firestore
              .collection("companies")
              .document(ourTransaction.from);

          double partnerRevenueBalance =
              double.parse(docSSPartner['currentRevenueBalance'].toString());

          dbRefPartner.updateData({
            "currentRevenueBalance":
                partnerRevenueBalance + ourTransaction.amount
          });

          double currentTotalBalance = double.parse(
              docSS['properties']['currentTotalBalance'].toString());

          dbRefUser.updateData({
            "properties.currentTotalBalance":
                currentTotalBalance + ourTransaction.amount
          });
        }
      });
    } else {
      var user = _firestore.collection('users').document(curruser.uid);

      _firestore.collection('payments').add({
        'tID': "",
        'from': ourTransaction.from,
        'to': ourTransaction.to,
        'date': ourTransaction.date,
        'amount': ourTransaction.amount.toDouble(),
        'isProcessed': ourTransaction.processed,
        'details': ourTransaction.detail
      }).then((docReferenceOfTheTransaction) async {
        DocumentSnapshot docSS =
            await _firestore.collection('users').document(curruser.uid).get();
        DocumentReference dbRefUser =
            _firestore.collection('users').document(curruser.uid);

        docReferenceOfTheTransaction
            .updateData({"tID": docReferenceOfTheTransaction.documentID});

        if (ourTransaction.processed) {
          double currentCashBalance = double.parse(
              docSS['properties']['currentCashBalance'].toString());

          dbRefUser.updateData({
            "properties.currentCashBalance":
                FieldValue.increment(-ourTransaction.amount)
          });
        } else {
          DocumentSnapshot docSSPartner = await _firestore
              .collection("companies")
              .document(ourTransaction.to)
              .get();
          DocumentReference dbRefPartner = await _firestore
              .collection("companies")
              .document(ourTransaction.to);

          dbRefUser.updateData({
            "properties.currentTotalBalance":
                FieldValue.increment(-ourTransaction.amount.toDouble())
          });

          double partnerPaymentBalance =
              double.parse(docSSPartner['currentPaymentBalance'].toString());

          dbRefPartner.updateData({
            "currentPaymentBalance":
                FieldValue.increment(ourTransaction.amount.toDouble())
          });
        }
      });
    }
  }

  Stream<QuerySnapshot> getTransactions(
      String userID, String partnerID, bool isRevenue) {
    if (isRevenue) {
      return _firestore
          .collection('revenues')
          .where('from', isEqualTo: partnerID)
          .where('to', isEqualTo: userID)
          //.orderBy('properties.companyName', descending: false)
          .getDocuments()
          .asStream();
    } else {
      return _firestore
          .collection('payments')
          .where('from', isEqualTo: userID)
          .where('to', isEqualTo: partnerID)
          //.orderBy('properties.companyName', descending: false)
          .getDocuments()
          .asStream();
    }
  }

  Future<List<List<TransactionApp>>> getAllTransactionsForCompany(
      String companyID, String userID) async {
    List<TransactionApp> revenues = new List<TransactionApp>();
    List<TransactionApp> payments = new List<TransactionApp>();
    List<List<TransactionApp>> returnThis = new List<List<TransactionApp>>();

    QuerySnapshot qs = await _firestore // this is for revenues
        .collection('revenues')
        .where('from', isEqualTo: companyID)
        .where('to', isEqualTo: userID)
        .getDocuments();

    qs.documents.forEach((ds) {
      revenues.add(new TransactionApp(
        docID: ds.data["tID"],
        from: ds.data["from"],
        to: ds.data["to"],
        date: DateTime.fromMillisecondsSinceEpoch(
            ds.data["date"].millisecondsSinceEpoch),
        amount: double.parse(ds.data["amount"].toString()),
        processed: ds.data["isProcessed"],
        detail: ds.data["details"],
      ));
    });

    returnThis.add(revenues);

    QuerySnapshot qsTwo = await _firestore // this is for revenues
        .collection('payments')
        .where('from', isEqualTo: userID)
        .where('to', isEqualTo: companyID)
        .getDocuments();

    qsTwo.documents.forEach((ds) {
      payments.add(new TransactionApp(
          docID: ds.data["tID"],
          from: ds.data["from"],
          to: ds.data["to"],
          date: DateTime.fromMillisecondsSinceEpoch(
              ds.data["date"].millisecondsSinceEpoch),
          amount: double.parse(ds.data["amount"].toString()),
          processed: ds.data["isProcessed"],
          detail: ds.data["details"]));
    });

    print('payments.length');
    print(payments.length);

    returnThis.add(payments);

    return returnThis;
  }

  Future<List<List<TransactionApp>>> getAllTransactionsForUser() async {
    FirebaseUser currUser = await _authService.getCurrentUser();

    QuerySnapshot revSnapShot = await _firestore
        .collection('revenues')
        .where('to', isEqualTo: currUser.uid)
        .getDocuments();
    QuerySnapshot paySnapShot = await _firestore
        .collection('payments')
        .where('from', isEqualTo: currUser.uid)
        .getDocuments();

    List<TransactionApp> revList = new List<TransactionApp>();
    List<TransactionApp> payList = new List<TransactionApp>();

    revSnapShot.documents.forEach((ds) async {
      String compName = await getSingleCompanyNameFromIDasync(ds.data['from']);
      revList.add(new TransactionApp(
        docID: ds.data["tID"],
        from: '${ds.data["from"]}%$compName',
        to: ds.data["to"],
        date: DateTime.fromMillisecondsSinceEpoch(
            ds.data["date"].millisecondsSinceEpoch),
        amount: double.parse(ds.data["amount"].toString()),
        processed: ds.data["isProcessed"],
        detail: ds.data["details"],
      ));
    });

    paySnapShot.documents.forEach((ds) async {
      String compName = await getSingleCompanyNameFromIDasync(ds.data['to']);
      payList.add(new TransactionApp(
        docID: ds.data["tID"],
        from: ds.data["from"],
        to: '${ds.data["to"]}%$compName',
        date: DateTime.fromMillisecondsSinceEpoch(
            ds.data["date"].millisecondsSinceEpoch),
        amount: double.parse(ds.data["amount"].toString()),
        processed: ds.data["isProcessed"],
        detail: ds.data["details"],
      ));
    });

    revList.sort((a, b) => a.date.compareTo(b.date));
    payList.sort((a, b) => a.date.compareTo(b.date));

    List<List<TransactionApp>> returnList = new List<List<TransactionApp>>();

    returnList.add(revList);
    returnList.add(payList);

    return returnList;
  }

  Future<void> setTransactionToProcessed(
      TransactionApp transaction, bool isRevenue) {
    _authService.getCurrentUser().then((ourUser) {
      if (isRevenue) {
        _firestore
            .collection("revenues")
            .document(transaction.docID)
            .updateData({"isProcessed": true});

        _firestore
            .collection('users')
            .document(ourUser.uid)
            .get()
            .then((userSS) {
          DocumentReference dbRefUser =
              _firestore.collection('users').document(ourUser.uid);
          DocumentReference dbRefCompany =
              _firestore.collection("companies").document(transaction.from);

          var currentTotalBalance =
              userSS.data["properties"]["currentTotalBalance"];
          var currentCashBalance =
              userSS.data["properties"]["currentCashBalance"];

          // alacağımız vardı alacağımızı temin ettiğimizi belirtiyoruz.
          dbRefUser.updateData({
            "properties.currentTotalBalance":
                currentTotalBalance - transaction.amount,
            "properties.currentCashBalance":
                currentCashBalance + transaction.amount
          });
          print("dbRefCompany");
          print(dbRefCompany.documentID);
          dbRefCompany.updateData({
            "currentRevenueBalance": FieldValue.increment(-transaction.amount),
          });
        });
      } else {
        _firestore
            .collection("payments")
            .document(transaction.docID)
            .updateData({"isProcessed": true});

        _firestore
            .collection('users')
            .document(ourUser.uid)
            .get()
            .then((userSS) {
          DocumentReference dbRefUser =
              _firestore.collection('users').document(ourUser.uid);

          DocumentReference dbRefCompany =
              _firestore.collection("companies").document(transaction.to);

          var currentTotalBalance =
              userSS.data["properties"]["currentTotalBalance"];
          var currentCashBalance =
              userSS.data["properties"]["currentCashBalance"];

          dbRefUser.updateData({
            "properties.currentTotalBalance":
                FieldValue.increment(transaction.amount),
            "properties.currentCashBalance":
                FieldValue.increment(-transaction.amount)
          });

          dbRefCompany.updateData({
            "currentPaymentBalance": FieldValue.increment(-transaction.amount),
          });
        });
      }
    });
  }

  Future<void> changeTransactionData(TransactionApp transaction, String detail,
      double amount, bool isRevenue) {
    print(
        "Bilgiler: // detail: ${detail} & amount ${amount} & transactionID = ${transaction.docID}");
    if (isRevenue) {
      DocumentReference userRef =
          _firestore.collection("users").document(transaction.to);
      DocumentReference companyRef =
          _firestore.collection("companies").document(transaction.from);
      DocumentReference refRevenue =
          _firestore.collection("revenues").document(transaction.docID);
      //                 birinci değer - ikinci değer
      double diff =
          transaction.amount - (amount != null ? amount : transaction.amount);

      refRevenue.updateData({
        "details": detail != null ? detail : transaction.detail,
        "amount": amount != null ? amount : transaction.amount
      });

      if (diff != 0 || amount != null) {
        if (transaction.processed) {
          userRef.updateData({
            "properties.currentCashBalance":
                FieldValue.increment(diff < 0 ? diff.abs() : -diff.abs()),
          });
        } else {
          userRef.updateData({
            "properties.currentTotalBalance":
                FieldValue.increment(diff < 0 ? diff.abs() : -diff.abs()),
          });
          companyRef.updateData({
            "currentRevenueBalance":
                FieldValue.increment(diff < 0 ? diff.abs() : -diff.abs()),
          });
        }
      }
    } else {
      DocumentReference userRef =
          _firestore.collection("users").document(transaction.from);
      DocumentReference companyRef =
          _firestore.collection("companies").document(transaction.to);
      DocumentReference refRevenue =
          _firestore.collection("payments").document(transaction.docID);

      //                 birinci değer - ikinci değer
      double diff =
          transaction.amount - (amount != null ? amount : transaction.amount);

      refRevenue.updateData({
        "details": detail != null ? detail : transaction.detail,
        "amount": amount != null ? amount : transaction.amount
      }).then((onValue) {
        if (diff != 0 || amount != null) {
          if (transaction.processed) {
            userRef.updateData({
              "properties.currentCashBalance":
                  FieldValue.increment(diff < 0 ? diff.abs() : -diff.abs()),
            });
          } else {
            userRef.updateData({
              "properties.currentTotalBalance": FieldValue.increment(diff),
            });
            companyRef.updateData({
              "currentPaymentBalance":
                  FieldValue.increment(diff < 0 ? diff.abs() : -diff.abs()),
            });
          }
        }
      });
    }
  }
}
