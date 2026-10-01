import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';

class StyleText {
  StyleText({bool isDark = false})
    : _textColor = isDark ? AppColors.white : AppColors.neutral;

  final Color _textColor;

  // ═══════════════════════════════════════════════
  // TITRES
  // ═══════════════════════════════════════════════

  late final TextStyle title = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle titleWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  late final TextStyle subtitle = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle subtitleWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // CORPS DE TEXTE
  // ═══════════════════════════════════════════════

  late final TextStyle body = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 15,
    letterSpacing: -1,
  );

  late final TextStyle bodyBold = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle bodyWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 15,
    letterSpacing: -1,
  );

  TextStyle bodyWhiteBold = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // DESCRIPTION / TEXTE SECONDAIRE
  // ═══════════════════════════════════════════════

  TextStyle desc = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 14,
    letterSpacing: -1,
  );

  TextStyle descItalic = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // PETITS TEXTES / LABELS / BADGES
  // ═══════════════════════════════════════════════

  TextStyle caption = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 12,
    letterSpacing: -1,
  );

  late final TextStyle captionBold = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle tab = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 12,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // BOUTONS / ACTIONS
  // ═══════════════════════════════════════════════

  TextStyle button = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle link = GoogleFonts.aBeeZee(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // EN-TÊTES DE SECTION
  // ═══════════════════════════════════════════════

  late final TextStyle headBlack = GoogleFonts.aBeeZee(
    color: _textColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle headWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextTheme get materialTextTheme => TextTheme(
    displayLarge: title,
    displayMedium: title,
    displaySmall: title,
    headlineLarge: headBlack,
    headlineMedium: title,
    headlineSmall: subtitle,
    titleLarge: title,
    titleMedium: subtitle,
    titleSmall: bodyBold,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: desc,
    labelLarge: captionBold,
    labelMedium: caption,
    labelSmall: caption,
  );
}
