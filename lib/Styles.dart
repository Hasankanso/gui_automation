import 'package:flutter/cupertino.dart';

class Styles {
  static double iconSize(BuildContext context) {
    double max = 30;
    double current = MediaQuery.of(context).size.width * 0.06;
    if (current > max) {
      return max;
    }
    return current;
  }
}
