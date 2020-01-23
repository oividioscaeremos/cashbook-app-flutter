import 'package:cash_book_app/classes/Destination.dart';
import 'package:flutter/material.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.destination.color,
      body: Container(
        alignment: Alignment.center,
        child: Container(child: widget.destination.child),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
