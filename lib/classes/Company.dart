import 'package:cash_book_app/classes/Person.dart';
import 'package:cash_book_app/classes/Transaction.dart';

class Company {
  String companyName;
  String address;
  Person personOne;
  Person personTwo;
  List<TransactionApp> payments;
  List<TransactionApp> revenues;

  Company({companyName, address, personOne, personTwo}) {
    this.companyName = companyName;
    this.address = address;
    this.personOne = personOne;
    if (this.personTwo != null) {
      this.personTwo = personTwo;
    }
  }
}
