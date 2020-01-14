import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color color;
  final Function onTap;
  final Widget cardChild;

  static const double edgeInsets = 15.0;
  static const double borderRadius = 10.0;

  ReusableCard({this.color, this.onTap, this.cardChild});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(edgeInsets),
          child: cardChild,
        ),
        margin: EdgeInsets.all(edgeInsets),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
      ),
    );
  }
}
