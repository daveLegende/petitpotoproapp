import 'package:flutter/material.dart';

class AppSpacing {
  // Vertical Spacing
  static const SizedBox v5 = SizedBox(height: 5);
  static const SizedBox v10 = SizedBox(height: 10);
  static const SizedBox v15 = SizedBox(height: 15);
  static const SizedBox v20 = SizedBox(height: 20);
  static const SizedBox v30 = SizedBox(height: 30);
  static const SizedBox v40 = SizedBox(height: 40);
  static const SizedBox v50 = SizedBox(height: 50);
  static const SizedBox v100 = SizedBox(height: 100);

  // Horizontal Spacing
  static const SizedBox h5 = SizedBox(width: 5);
  static const SizedBox h10 = SizedBox(width: 10);
  static const SizedBox h15 = SizedBox(width: 15);
  static const SizedBox h20 = SizedBox(width: 20);
  static const SizedBox h30 = SizedBox(width: 30);
}

class UIHelpers {
  static double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  static double responsiveWidth(BuildContext context, double factor) => getWidth(context) * factor;
  static double responsiveHeight(BuildContext context, double factor) => getHeight(context) * factor;
}
