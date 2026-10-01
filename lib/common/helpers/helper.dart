import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';

class Helpers {
  // format
  String formatMontant(double montant) {
    var somme = NumberFormat.currency(
      locale: 'fr-fr',
      decimalDigits: 0,
      name: 'cfa',
    ).format(montant).toString();
    return somme.trim();
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      final double abbreviated = number / 1000.0;
      const String suffix = 'k';
      return '${abbreviated.toStringAsFixed(1)}$suffix';
    } else {
      return number.toString();
    }
  }

  String afficherHeureMinute(DateTime dateTime) {
    String heureMinute = DateFormat.Hm().format(dateTime);
    return heureMinute;
  }

  String formatDate(DateTime dateTime) {
    final dt = DateFormat('dd.MM.yy HH:mm').format(dateTime);
    return dt;
  }

  String formatDate2(DateTime dateTime) {
    final dt = DateFormat('dd/MM/yy').format(dateTime);
    return dt;
  }

  String dateEcole(DateTime dateTime) {
    String formattedDate = DateFormat(
      'EEEE dd MMMM yyyy',
      'fr_FR',
    ).format(dateTime);
    return formattedDate[0].toUpperCase() + formattedDate.substring(1);
  }

  String birthDate(DateTime dateTime) {
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
        .format(dateTime);
    return formattedDate;
  }

  /// Vérifie si l'appareil est physique ou non
  bool isPhysicalDevice() {
    // Pour l'exemple, on pourrait implémenter une fonction de vérification pour l'émulateur
    // Vous pouvez améliorer cette vérification avec d'autres méthodes si nécessaire
    return !Platform.environment.containsKey('ANDROID_EMULATOR');
  }

  // String getUserName(UserEntity user) {
  //   return "${user.firstname} ${user.lastname}";
  // }

  // snackbar
  // void toast({
  //   required String message,
  //   Color color = AppColors.primary,
  // }) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.SNACKBAR,
  //     timeInSecForIosWeb: 3,
  //     backgroundColor: color,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackbar({
    required BuildContext context,
    required String message,
    Color color = AppColors.primary,
  }) {
    var snackbar = SnackBar(
      content: Text(message, style: StyleText().bodyWhite),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
