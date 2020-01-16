import 'Company.dart';

class TransactionApp {
  String docID;
  String from;
  String to;
  DateTime date;
  double amount;
  bool processed;
  String detail;

  TransactionApp(
      {this.docID,
      this.from,
      this.to,
      this.date,
      this.amount,
      this.processed,
      this.detail});
}
