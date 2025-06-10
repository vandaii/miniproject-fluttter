import 'package:flutter/widgets.dart';

class Responsive {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }
}
