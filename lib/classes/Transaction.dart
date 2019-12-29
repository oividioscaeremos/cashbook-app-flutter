import 'Company.dart';

class Transaction {
  Company from;
  Company to;
  DateTime date;
  bool method; // true if cash; false if check;
  double amount;
  String currency;
  String type;
  bool processed;

  Transaction(
      {this.from,
      this.to,
      this.date,
      this.method,
      this.amount,
      this.type,
      this.currency,
      this.processed});
}
