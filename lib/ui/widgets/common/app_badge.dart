import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/utils/spacing.dart';

/// Modern badge component for displaying notification counts or status
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final AppBadgeSize size;
  final bool showDot;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.size = AppBadgeSize.medium,
    this.showDot = false,
  });

  /// Dot-only badge (no text)
  const AppBadge.dot({
    super.key,
    this.backgroundColor,
    this.size = AppBadgeSize.small,
  })  : text = '',
        textColor = null,
        showDot = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = backgroundColor ?? colorScheme.error;
    final fgColor = textColor ?? colorScheme.onError;

    if (showDot || text.isEmpty) {
      return Container(
        width: _getDotSize(),
        height: _getDotSize(),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
      ),
      constraints: BoxConstraints(
        minWidth: _getMinWidth(),
        minHeight: _getHeight(),
      ),
      child: Center(
        child: Text(
          text,
          style: _getTextStyle(textTheme)?.copyWith(color: fgColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  double _getDotSize() {
    switch (size) {
      case AppBadgeSize.small:
        return 8;
      case AppBadgeSize.medium:
        return 10;
      case AppBadgeSize.large:
        return 12;
    }
  }

  double _getMinWidth() {
    switch (size) {
      case AppBadgeSize.small:
        return 16;
      case AppBadgeSize.medium:
        return 20;
      case AppBadgeSize.large:
        return 24;
    }
  }

  double _getHeight() {
    switch (size) {
      case AppBadgeSize.small:
        return 16;
      case AppBadgeSize.medium:
        return 20;
      case AppBadgeSize.large:
        return 24;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case AppBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
      case AppBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
    }
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    switch (size) {
      case AppBadgeSize.small:
        return textTheme.labelSmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );
      case AppBadgeSize.medium:
        return textTheme.labelMedium?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        );
      case AppBadgeSize.large:
        return textTheme.labelLarge?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
    }
  }
}

enum AppBadgeSize {
  small,
  medium,
  large,
}
