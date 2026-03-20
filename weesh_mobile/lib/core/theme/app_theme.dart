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
  
  // Font fallback ensures ₱ renders correctly if primary font lacks glyph
  fontFamilyFallback: const ['Roboto', 'sans-serif'],

  // Typography - Noto Sans JP for display, Inter for body (Japanese minimal)
  textTheme: TextTheme(
    displayLarge: GoogleFonts.notoSansJp(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: AppColors.deepCharcoal,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.notoSansJp(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: AppColors.textBody,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.notoSansJp(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textBody,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.textBody,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: AppColors.textLight,
      height: 1.5,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
  ),

  // Component Themes
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary, // Matcha green CTA
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      elevation: 0, // Flat design
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius, // Sharper 8px
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textBody, // Sumi ink
      side: const BorderSide(color: AppColors.cardBorder, width: 1.0), // Thin stone border
      minimumSize: const Size.fromHeight(56),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface, // Clean white
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputRadius,
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5), // Subtle focus
    ),
    labelStyle: GoogleFonts.inter(color: AppColors.textLight),
    hintStyle: GoogleFonts.inter(color: AppColors.neutral500),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.cardBorder, width: 1), // Crisp 1px border
      borderRadius: AppRadius.cardRadius,
    ),
    margin: EdgeInsets.zero,
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.primary.withValues(alpha: 0.1), // Gentle matcha indicator
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary);
      }
      return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight);
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: AppColors.primary);
      }
      return const IconThemeData(color: AppColors.neutral500);
    }),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background, // Rice paper
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    centerTitle: true, // Classic minimalist centering
    titleTextStyle: GoogleFonts.notoSansJp(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.deepCharcoal,
      letterSpacing: -0.3,
    ),
    iconTheme: const IconThemeData(color: AppColors.deepCharcoal),
  ),
);
