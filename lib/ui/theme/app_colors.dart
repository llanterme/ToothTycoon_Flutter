import 'package:flutter/material.dart';

/// Modern Material 3 color schemes for Tooth Tycoon
/// Based on the existing brand colors with enhanced Material 3 color roles
class AppColors {
  AppColors._();

  // Brand Colors (from existing constants/colors.dart)
  static const Color brandPrimary = Color(0xff727dc7); // Original primary purple-blue
  static const Color brandYellow = Color(0xffffea7d);
  static const Color brandGreen = Color(0xff98FF95);
  static const Color brandBlue = Color(0xff397BF3);
  static const Color brandRed = Color(0xffeb5f59);

  /// Light Color Scheme - Modern Material 3
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary colors - Based on brand purple-blue
    primary: Color(0xff5a64b8), // Slightly darker for better contrast
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffe0e2ff),
    onPrimaryContainer: Color(0xff00006e),

    // Secondary colors - Complementary warm tone
    secondary: Color(0xff5c5d72),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffe1e0f9),
    onSecondaryContainer: Color(0xff18192b),

    // Tertiary colors - Accent yellow from brand
    tertiary: Color(0xff77600a),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffffe085),
    onTertiaryContainer: Color(0xff251a00),

    // Error colors
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),

    // Surface colors - Clean white base
    surface: Color(0xfffbfbff),
    onSurface: Color(0xff1b1b1f),
    surfaceDim: Color(0xffdbd9e0),
    surfaceBright: Color(0xfffbfbff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff5f3fa),
    surfaceContainer: Color(0xffefeef4),
    surfaceContainerHigh: Color(0xffe9e7ef),
    surfaceContainerHighest: Color(0xffe3e2e9),
    onSurfaceVariant: Color(0xff45464e),

    // Outline colors
    outline: Color(0xff76767f),
    outlineVariant: Color(0xffc6c5d0),

    // Shadow and scrim
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),

    // Inverse colors
    inverseSurface: Color(0xff303034),
    onInverseSurface: Color(0xfff2f0f7),
    inversePrimary: Color(0xffbec2ff),
  );

  /// Dark Color Scheme - Modern Material 3
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary colors
    primary: Color(0xffbec2ff),
    onPrimary: Color(0xff2830a1),
    primaryContainer: Color(0xff414aa1),
    onPrimaryContainer: Color(0xffe0e2ff),

    // Secondary colors
    secondary: Color(0xffc4c4dd),
    onSecondary: Color(0xff2d2e41),
    secondaryContainer: Color(0xff444558),
    onSecondaryContainer: Color(0xffe1e0f9),

    // Tertiary colors
    tertiary: Color(0xffe7c46b),
    onTertiary: Color(0xff3f2e00),
    tertiaryContainer: Color(0xff5a4500),
    onTertiaryContainer: Color(0xffffe085),

    // Error colors
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),

    // Surface colors - Dark with depth
    surface: Color(0xff131316),
    onSurface: Color(0xffe3e2e9),
    surfaceDim: Color(0xff131316),
    surfaceBright: Color(0xff39393c),
    surfaceContainerLowest: Color(0xff0e0e11),
    surfaceContainerLow: Color(0xff1b1b1f),
    surfaceContainer: Color(0xff1f1f23),
    surfaceContainerHigh: Color(0xff2a292d),
    surfaceContainerHighest: Color(0xff343438),
    onSurfaceVariant: Color(0xffc6c5d0),

    // Outline colors
    outline: Color(0xff8f9099),
    outlineVariant: Color(0xff45464e),

    // Shadow and scrim
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),

    // Inverse colors
    inverseSurface: Color(0xffe3e2e9),
    onInverseSurface: Color(0xff303034),
    inversePrimary: Color(0xff5a64b8),
  );

  // Semantic colors for specific use cases
  static const Color success = Color(0xff98FF95);
  static const Color warning = Color(0xffffea7d);
  static const Color info = Color(0xff397BF3);

  // Gradient colors for modern effects
  static const List<Color> primaryGradient = [
    Color(0xff5a64b8),
    Color(0xff727dc7),
  ];

  static const List<Color> accentGradient = [
    Color(0xffffea7d),
    Color(0xffffe085),
  ];

  // Glassmorphic overlay colors
  static Color glassLight = Colors.white.withValues(alpha: 0.7);
  static Color glassDark = Colors.black.withValues(alpha: 0.3);
}
