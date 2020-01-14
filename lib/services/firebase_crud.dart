import 'package:cash_book_app/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

class FirebaseCrud {
  final Firestore _firestore = Firestore.instance;

  Future<double> getCurrentCashBalance(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').document(uid).get();
    if (snapshot != null) {
      return snapshot.data["properties"]["currentCashBalance"].toDouble();
    }
  }

  Future<int> getCurrentTotalBalance(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').document(uid).get();
    print("snapshot DATA HERE 5555555555555555555555555555555555555555555555");
    print(snapshot.data);
    if (snapshot != null) {
      return snapshot.data["properties"]["currentTotalBalance"].toDouble();
    }
  }
}
