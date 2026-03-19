import 'package:flutter/material.dart';

class AppColors {
  // Legacy Brand Colors (Keep for reference if needed elsewhere)
  static const Color legacyJungleGreen = Color(0xFF006C4C);
  static const Color legacyTricycleYellow = Color(0xFFFFB300);
  
  // Primary (Hyper-Clean System)
  static const Color primary = Color(0xFFCB6051); // Terracotta
  static const Color secondary = Color(0xFFFFB300); // Tricycle Yellow
  static const Color tertiary = Color(0xFF7B1FA2); // Mystic Purple
  // Background: Stark White
  static const Color background = Color(0xFFFFFFFF);
  // Surface: White
  static const Color surface = Color(0xFFFFFFFF);

  // Neutral Tints (Cool-shifted High Contrast)
  static const Color neutral100 = Color(0xFFF3F4F6); // Gray 100
  static const Color neutral200 = Color(0xFFE5E7EB); // Gray 200
  static const Color neutral500 = Color(0xFF6B7280); // Gray 500
  static const Color neutral900 = Color(0xFF111827); // Gray 900
  static const Color textBody = Color(0xFF111827);   // True Black

  // Feedback
  static const Color error = Color(0xFFEF4444);      // High-impact Red
  static const Color success = Color(0xFF10B981);    // High-impact Green

  // Brand Accents
  static const Color terracotta = Color(0xFFCB6051);
  static const Color sageGreen = Color(0xFFE0EFEB);
  static const Color lavender = Color(0xFFE8E0F0);
  static const Color heroBanner = Color(0xFFF5EDE4);
  static const Color deepCharcoal = Color(0xFF111827); // Very Dark Black
  static const Color warmGrey = Color(0xFF6B7280);     // Cool Gray
  static const Color cardBorder = Color(0xFFE5E7EB);
}

class AppPadding {
  static const double horizontal = 16.0;
  static const double section = 24.0;
  static const double item = 12.0;
}

class AppRadius {
  static const double card = 16.0;
  static const double button = 12.0;
  static const double input = 12.0;

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
  /// Very soft, wide blur drop shadow for creating spatial depth on white backgrounds
  static final soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
