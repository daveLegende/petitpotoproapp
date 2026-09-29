import 'package:flutter/material.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';


class AppTheme {
  // ═══════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════

  static final lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    fontFamily: 'ABeeZee',

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,

      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,

      surface: AppColors.white,
      onSurface: AppColors.neutral,

      error: AppColors.error,
      onError: AppColors.white,
    ),

    // ─────────────────────────────────────────────
    // AppBar
    // ─────────────────────────────────────────────

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.neutral,
      elevation: 0,
      centerTitle: false,
    ),

    // ─────────────────────────────────────────────
    // Icons
    // ─────────────────────────────────────────────

    iconTheme: const IconThemeData(
      color: AppColors.darkGrey,
    ),

    // ─────────────────────────────────────────────
    // Elevated Buttons
    // ─────────────────────────────────────────────

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,

        minimumSize: const Size(double.infinity, 52),

        elevation: 0,

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // Outlined Buttons
    // ─────────────────────────────────────────────

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,

        side: const BorderSide(
          color: AppColors.primary,
        ),

        minimumSize: const Size(double.infinity, 52),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // Text Buttons
    // ─────────────────────────────────────────────

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,

        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // Input Fields
    // ─────────────────────────────────────────────

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),

      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
    ),

    // ─────────────────────────────────────────────
    // Cards
    // ─────────────────────────────────────────────

    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ─────────────────────────────────────────────
    // Divider
    // ─────────────────────────────────────────────

    dividerTheme: const DividerThemeData(
      color: AppColors.lightBackground,
      thickness: 1,
    ),

    // ─────────────────────────────────────────────
    // Checkbox
    // ─────────────────────────────────────────────

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }

        return AppColors.grey;
      }),
    ),

    // ─────────────────────────────────────────────
    // Switch
    // ─────────────────────────────────────────────

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }

        return AppColors.grey;
      }),
    ),
  );

  // ═══════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════

  static final darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    fontFamily: 'ABeeZee',

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.white,

      secondary: AppColors.secondary,
      onSecondary: AppColors.white,

      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,

      surface: Color(0xFF1E293B),
      onSurface: AppColors.white,

      error: AppColors.error,
      onError: AppColors.white,
    ),

    // ─────────────────────────────────────────────
    // AppBar
    // ─────────────────────────────────────────────

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
    ),

    // ─────────────────────────────────────────────
    // Icons
    // ─────────────────────────────────────────────

    iconTheme: const IconThemeData(
      color: AppColors.grey,
    ),

    // ─────────────────────────────────────────────
    // Elevated Buttons
    // ─────────────────────────────────────────────

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,

        minimumSize: const Size(double.infinity, 52),

        elevation: 0,

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // Outlined Buttons
    // ─────────────────────────────────────────────

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,

        side: const BorderSide(
          color: AppColors.primary,
        ),

        minimumSize: const Size(double.infinity, 52),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // Input Fields
    // ─────────────────────────────────────────────

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
    ),

    // ─────────────────────────────────────────────
    // Cards
    // ─────────────────────────────────────────────

    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 0,
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ─────────────────────────────────────────────
    // Divider
    // ─────────────────────────────────────────────

    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
    ),
  );
}