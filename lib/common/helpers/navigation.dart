import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation {
  void goTo({required BuildContext context, required Widget page}) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  // remove until
  void goToAndRemoveUntil(
      {required BuildContext context, required Widget page}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
      (route) => false,
    );
  }


  // 
  
}