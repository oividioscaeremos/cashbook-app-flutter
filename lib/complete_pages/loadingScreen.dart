import 'package:flutter/material.dart';

import '../styles/color_palette.dart';
import '../styles/color_palette.dart';

class LoadingScreen extends StatelessWidget {
  ColorPalette colorPalette = new ColorPalette();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: colorPalette.darkGrey,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
