import 'dart:collection';
import 'dart:convert';

import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/screens/home_page.dart';
import 'package:cash_book_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

class FirebaseCrud {
  final Firestore _firestore = Firestore.instance;
  AuthService _authService = new AuthService();

  Stream<DocumentSnapshot> getCurrentCashBalance(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
  }

  Stream<DocumentSnapshot> getCurrentTotalBalance(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
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
        print(partners.toString());
        if (!partners.contains(docID)) {
          userRef.updateData({
            'partners': FieldValue.arrayUnion([docID])
          });
        }

        return currentUser.uid;
      });
    });
  }

  Future<List<Company>> getCompanies() async {
    FirebaseUser curruser = await _authService.getCurrentUser();

    DocumentSnapshot userSnapshot = await Firestore.instance
        .collection('users')
        .document(curruser.uid)
        .get();

    List partners = userSnapshot.data['partners'];

    QuerySnapshot usersComp = await _firestore
        .collection('companies')
        .where('belongsTo', isEqualTo: curruser.uid)
        //.orderBy('properties.companyName', descending: false)
        .getDocuments();

    List<Company> companies = new List<Company>();

    usersComp.documents.forEach((f) {
      int indexOfthis = usersComp.documents.indexOf(f);

      companies.add(new Company(
        uid: partners[indexOfthis],
        companyName: f.data['properties']['companyName'],
        address: f.data['properties']['address'],
        paymentBalance: f.data['currentPaymentBalance'],
        revenueBalance: f.data['currentRevenueBalance'],
        personOne: new Person(
            phoneNumber: f.data['properties']['personOne']['phoneNumber'],
            nameAndSurname: f.data['properties']['personOne']
                ['nameAndSurname']),
        personTwo: new Person(
            phoneNumber: f.data['properties']['personTwo']['phoneNumber'],
            nameAndSurname: f.data['properties']['personTwo']
                ['nameAndSurname']),
      ));

      print('companies[companies.length - 1].companyName');
      print(f.data['properties']['personTwo'].toString());
    });

    return companies;
  }

  /*Future<List<Transaction>> getTransaction(
      String partnerID, bool isRevenue) async {
    int mahmtu = 0;
    if (isRevenue) {
      DocumentSnapshot snapshot =
          await _firestore.collection('revenues').document(uid).get();
    } else {}
  }*/

  Future<String> addTransaction(
      TransactionApp ourTransaction, bool isRevenue) async {
    FirebaseUser curruser = await _authService.getCurrentUser();

    if (isRevenue) {
      var user = _firestore
          .collection('users')
          .document(curruser.uid);
      
      _firestore.collection('revenues').add({
        'from': curruser.uid,
        'to': ourTransaction.to.uid,
        'date': ourTransaction.date,
        'type': ourTransaction.type,
        'amount': ourTransaction.amount,
        'isProcessed': ourTransaction.processed
      }).then((docReferenceOfTheTransaction) {
        if (ourTransaction.processed) {
          _firestore
              .collection('users')
              .document(curruser.uid)
          .setData({'currentCashBalance': user.get().then(onValue)})
              .updateData({'currentCashBalance': cu})
              .then((userSnapshot) {
            double currentCashBalance = userSnapshot.data['properties']
                    ['currentCashbalance']
                .toDouble();
            currentCashBalance += ourTransaction.amount;
            userSnapshot.data.update('currentCashBalance', currentCashBalance})
          });
        }
      });
    }
  }
}
