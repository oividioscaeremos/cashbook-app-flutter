import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/classes/Transaction.dart';

class Company {
  String uid;
  String companyName;
  String address;
  Person personOne;
  Person personTwo;
  List<TransactionApp> payments;
  List<TransactionApp> revenues;
  int paymentBalance;
  int revenueBalance;

  Company(
      {uid,
      companyName,
      address,
      personOne,
      personTwo,
      paymentBalance,
      revenueBalance}) {
    this.companyName = companyName;
    this.address = address;
    this.personOne = personOne;
    this.personTwo = personTwo;
    this.paymentBalance = paymentBalance;
    this.revenueBalance = revenueBalance;
    this.uid = uid;
  }
}
