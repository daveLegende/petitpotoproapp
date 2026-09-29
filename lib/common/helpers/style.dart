import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';

class StyleText {
  // ═══════════════════════════════════════════════
  // TITRES
  // ═══════════════════════════════════════════════

  TextStyle title = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle titleWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle subtitle = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
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

  TextStyle body = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 10,
    letterSpacing: -1,
  );

  TextStyle bodyBold = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle bodyWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 10,
    letterSpacing: -1,
  );

  TextStyle bodyWhiteBold = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // DESCRIPTION / TEXTE SECONDAIRE
  // ═══════════════════════════════════════════════

  TextStyle desc = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 10,
    letterSpacing: -1,
  );

  TextStyle descItalic = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 10,
    fontStyle: FontStyle.italic,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // PETITS TEXTES / LABELS / BADGES
  // ═══════════════════════════════════════════════

  TextStyle caption = GoogleFonts.aBeeZee(
    color: AppColors.grey,
    fontSize: 10,
    letterSpacing: -1,
  );

  TextStyle captionBold = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle tab = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 10,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // BOUTONS / ACTIONS
  // ═══════════════════════════════════════════════

  TextStyle button = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle link = GoogleFonts.aBeeZee(
    color: AppColors.primary,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  // ═══════════════════════════════════════════════
  // EN-TÊTES DE SECTION
  // ═══════════════════════════════════════════════

  TextStyle headBlack = GoogleFonts.aBeeZee(
    color: AppColors.neutral,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  TextStyle headWhite = GoogleFonts.aBeeZee(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );
}