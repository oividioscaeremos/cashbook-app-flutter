import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:cash_book_app/classes/User.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // Email & password Sign Up
  // ignore: missing_return
  Future<String> createUser(String email, String password, String companyName,
      String nameAndSurname) async {
    try {
      final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Update the UserName
      var userUpdate = UserUpdateInfo();
      userUpdate.displayName = companyName;

      await currentUser.user.updateProfile(userUpdate);

      await currentUser.user.reload();

      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection('users')
            .document(currentUser.user.uid)
            .setData({
          "properties": {
            "companyName": companyName,
            "nameAndSurname": nameAndSurname,
            "eMail": email,
            "currentCashBalance": 0.0,
            "currentTotalBalance": 0.0,
          },
          "partners": [],
          "revenues": [],
          "payments": []
        });
      });

      return currentUser.user.uid;
    } catch (err) {
      if (err is PlatformException) {
        if (err.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          return "ERROR_EMAIL_ALREADY_IN_USE";
        } else {
          return err.code;
        }
      }
    }
  }

  // Email & password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Get Current User
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    Firestore fs = Firestore.instance;

    DocumentReference docRef = fs.collection('users').document(user.uid);
    print('docRef');
    print(docRef.documentID);

    return user;
  }
}
