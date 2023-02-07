import 'dart:math';

import 'package:flutter/material.dart';

const List<Color> _BLUEISH_GREY_COLORS = [
  Color.fromARGB(255, 80, 123, 145),
  Color.fromARGB(255, 68, 106, 126),
  Color.fromARGB(255, 97, 138, 159),
  Color.fromARGB(255, 77, 128, 155),
  Color.fromARGB(255, 63, 103, 124),
  Color.fromARGB(255, 90, 138, 162),
];

class ThemeColors {
  static const primary = Color.fromRGBO(215, 106, 27, 1.0);
  static const secondary = Color.fromRGBO(234, 124, 46, 1.0);
  static const secondaryDarker = Color.fromRGBO(115, 64, 36, 1.0);
  static const white = Color.fromRGBO(245, 245, 245, 1.0);
  static const tertiary = Color.fromRGBO(31, 224, 242, 1.0);
  static const error = Color.fromRGBO(225, 63, 63, 1.0);
  static const green = Color.fromARGB(255, 108, 227, 81);
  static const red = Color.fromARGB(255, 236, 74, 74);

  static Color get dynamicBlueColor {
    return _BLUEISH_GREY_COLORS[Random().nextInt(_BLUEISH_GREY_COLORS.length)];
  }
}
