import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color, this.child);
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
}
