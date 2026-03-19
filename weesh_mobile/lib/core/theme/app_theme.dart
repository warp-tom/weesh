import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.background,

  // Typography
  textTheme: TextTheme(
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 32.0,
      fontWeight: FontWeight.w800, // ExtraBold to anchor layout
      color: AppColors.deepCharcoal,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w800, // Bolder hierarchy
      color: AppColors.textBody,
    ),
    headlineSmall: GoogleFonts.plusJakartaSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textBody,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textBody,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textBody,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
  ),

  // Component Themes
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.terracotta,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.neutral200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.neutral200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    labelStyle: GoogleFonts.plusJakartaSans(color: AppColors.textBody),
    hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.warmGrey),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.cardBorder, width: 1),
      borderRadius: AppRadius.cardRadius,
    ),
    margin: EdgeInsets.zero,
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.secondary,
    labelTextStyle: WidgetStateProperty.all(
      GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.deepCharcoal,
    ),
    iconTheme: const IconThemeData(color: AppColors.deepCharcoal),
  ),
);
