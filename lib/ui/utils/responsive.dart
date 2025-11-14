import 'package:flutter/material.dart';

/// Responsive utilities for adaptive layouts
/// Handles different screen sizes and provides breakpoint utilities
class Responsive {
  Responsive._();

  // Breakpoints (based on Material Design guidelines)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive width based on percentage
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }

  /// Get responsive height based on percentage
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }

  /// Get responsive value based on screen size
  static T valueByDevice<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get text scale factor with limit
  static double textScaleFactor(BuildContext context, {double maxScale = 1.3}) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    return textScale > maxScale ? maxScale : textScale;
  }

  /// Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get keyboard height
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }
}

/// Responsive sizing helper
class ResponsiveSize {
  final BuildContext context;

  ResponsiveSize(this.context);

  /// Get responsive font size
  double fontSize(double baseSize) {
    if (Responsive.isDesktop(context)) {
      return baseSize * 1.2;
    } else if (Responsive.isTablet(context)) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  /// Get responsive padding
  double padding(double basePadding) {
    if (Responsive.isDesktop(context)) {
      return basePadding * 1.5;
    } else if (Responsive.isTablet(context)) {
      return basePadding * 1.2;
    }
    return basePadding;
  }

  /// Get responsive icon size
  double iconSize(double baseSize) {
    if (Responsive.isDesktop(context)) {
      return baseSize * 1.3;
    } else if (Responsive.isTablet(context)) {
      return baseSize * 1.15;
    }
    return baseSize;
  }
}
