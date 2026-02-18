import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  static const double smallPhoneWidth = 360.0;
  static const double largePhoneWidth = 414.0;
  static const double tabletWidth = 768.0;

  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width <= smallPhoneWidth;
  }

  static bool isLargePhone(BuildContext context) {
    return MediaQuery.of(context).size.width > smallPhoneWidth &&
        MediaQuery.of(context).size.width <= largePhoneWidth;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > largePhoneWidth;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
