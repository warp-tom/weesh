import 'package:flutter/material.dart';

class AppColors {
  // ─── Legacy References (Keep for compatibility if strictly needed) ───
  static const Color legacyJungleGreen = Color(0xFF006C4C);
  static const Color legacyTricycleYellow = Color(0xFFFFB300);
  
  // ─── Zen Primary Palette ───
  static const Color primary = Color(0xFF2D4A3E);    // Deep Matcha (Forest Green)
  static const Color secondary = Color(0xFFC4956A);  // Warm Ochre
  static const Color tertiary = Color(0xFF8B4F65);   // Muted Plum
  
  // ─── Surfaces & Backgrounds (The 'Ma' Whitespace) ───
  static const Color background = Color(0xFFF9F8F6); // Warm Rice Paper
  static const Color surface = Color(0xFFFFFFFF);    // Pure White (Cards)
  static const Color surfaceDim = Color(0xFFF2F0EC); // Tatami (Subtle secondary bg)

  // ─── Neutrals & Ink (Text) ───
  static const Color neutral100 = Color(0xFFF5F5F5); 
  static const Color neutral200 = Color(0xFFE5E5E5); 
  static const Color neutral500 = Color(0xFF737373); 
  static const Color neutral900 = Color(0xFF171717); 
  static const Color textBody = Color(0xFF1A1A1A);     // Sumi Ink (Main text)
  static const Color textLight = Color(0xFF6B6B6B);    // Light Ink (Secondary text)

  // ─── Feedback & Accents ───
  static const Color error = Color(0xFFB44B3A);        // Torii Red (Errors, Destructive)
  static const Color success = Color(0xFF2D4A3E);      // Deep Matcha
  
  // ─── specific naming aliases for migration ───
  static const Color terracotta = Color(0xFFB44B3A);   // Replaced with Torii Red for accent
  static const Color sageGreen = Color(0xFFE8ECEB);    // Very light matcha tint
  static const Color lavender = Color(0xFFEFE8EB);     // Very light plum tint
  static const Color heroBanner = Color(0xFFF9F4EE);   // Warm tint
  static const Color deepCharcoal = Color(0xFF1A1A1A); // Sumi Ink
  static const Color warmGrey = Color(0xFF6B6B6B);     // Light Ink
  static const Color cardBorder = Color(0xFFE0DDD8);   // Stone (Subtle border)
  static const Color gcashBlue = Color(0xFF007DFE);    // GCash brand color
}

class AppPadding {
  static const double horizontal = 24.0; // Increased for more whitespace (Ma)
  static const double section = 32.0;    // Increased breathing room
  static const double item = 16.0;
}

class AppRadius {
  static const double card = 12.0;       // Sharper, more geometric
  static const double button = 8.0;      // Sharper corners
  static const double input = 8.0;

  static final BorderRadius cardRadius = BorderRadius.circular(card);
  static final BorderRadius buttonRadius = BorderRadius.circular(button);
  static final BorderRadius inputRadius = BorderRadius.circular(input);
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration stagger = Duration(milliseconds: 80);
  static const Duration pageTransition = Duration(milliseconds: 350);
}

class AppShadows {
  /// Extremely subtle, almost imperceptible shadow. 
  /// The Japanese minimalist approach prefers borders (`AppColors.cardBorder`) over shadows.
  static final soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];
}
