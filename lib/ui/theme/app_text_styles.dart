import 'package:flutter/material.dart';

/// Modern Typography system for Tooth Tycoon
/// Implements Material 3 type scale with custom fonts (Avenir, OpenSans)
class AppTextStyles {
  AppTextStyles._();

  // Base font families (existing in project)
  static const String fontFamilyAvenir = 'Avenir';
  static const String fontFamilyOpenSans = 'OpenSans';

  /// Material 3 Text Theme
  static const TextTheme textTheme = TextTheme(
    // Display styles - Largest text
    displayLarge: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline styles - High emphasis text
    headlineLarge: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title styles - Medium emphasis text
    titleLarge: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Label styles - Button and form labels
    labelLarge: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamilyAvenir,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),

    // Body styles - Default text
    bodyLarge: TextStyle(
      fontFamily: fontFamilyOpenSans,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamilyOpenSans,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamilyOpenSans,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
  );

  // Custom text styles for specific use cases
  static const TextStyle welcomeTitle = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 33,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.2,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 15,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const TextStyle bottomSheetTitle = TextStyle(
    fontFamily: fontFamilyAvenir,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.2,
  );
}
