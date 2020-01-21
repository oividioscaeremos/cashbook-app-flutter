import 'package:cash_book_app/classes/Company.dart';
import 'package:cash_book_app/classes/Transaction.dart';
import 'package:flutter/cupertino.dart';

class User {
  String nameAndSurname;
  String companyName;
  String eMail;
  double currentCashBalance;
  double currentTotalBalance;
  List<TransactionApp> payments;
  List<TransactionApp> revenues;
  List<Company> partners;

  User(
      {@required companyName,
      @required nameAndSurname,
      @required eMail,
      @required currCashBalance,
      @required currTotalBalance}) {
    this.companyName = companyName;
    this.nameAndSurname = nameAndSurname;
    this.eMail = eMail;
    this.currentCashBalance = currCashBalance;
    this.currentTotalBalance = currTotalBalance;
  }
}
