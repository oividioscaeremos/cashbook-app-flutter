import 'Company.dart';

class TransactionApp {
  Company from;
  Company to;
  DateTime date;
  bool method; // true if cash; false if check;
  double amount;
  String type;
  bool processed;

  TransactionApp(
      {this.from,
      this.to,
      this.date,
      this.method,
      this.amount,
      this.type,
      this.processed});
}
