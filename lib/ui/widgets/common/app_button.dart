import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/utils/spacing.dart';

/// Modern button component with multiple variants
/// Supports primary, secondary, outline, and text styles
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Color? customColor;
  final Color? customTextColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.customColor,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Button dimensions based on size
    final height = _getHeight();
    final padding = _getPadding();
    final textStyle = _getTextStyle(textTheme);

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(colorScheme),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                Spacing.gapHorizontalXs,
              ],
              Flexible(
                child: Text(
                  text,
                  style: textStyle?.copyWith(
                    color: customTextColor ?? _getTextColor(colorScheme),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    Widget button = _buildButton(
      context: context,
      colorScheme: colorScheme,
      height: height,
      padding: padding,
      child: buttonChild,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton({
    required BuildContext context,
    required ColorScheme colorScheme,
    required double height,
    required EdgeInsets padding,
    required Widget child,
  }) {
    final isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? colorScheme.primary,
            foregroundColor: customTextColor ?? colorScheme.onPrimary,
            minimumSize: Size(0, height),
            padding: padding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          ),
          child: child,
        );

      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? colorScheme.secondaryContainer,
            foregroundColor: customTextColor ?? colorScheme.onSecondaryContainer,
            minimumSize: Size(0, height),
            padding: padding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          ),
          child: child,
        );

      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: customTextColor ?? colorScheme.primary,
            minimumSize: Size(0, height),
            padding: padding,
            side: BorderSide(
              color: customColor ?? colorScheme.outline,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          ),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: customTextColor ?? colorScheme.primary,
            minimumSize: Size(0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
            ),
          ),
          child: child,
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 50;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 14);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 16);
    }
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    switch (size) {
      case AppButtonSize.small:
        return textTheme.labelMedium;
      case AppButtonSize.medium:
        return textTheme.labelLarge;
      case AppButtonSize.large:
        return textTheme.titleMedium;
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return colorScheme.primary;
    }
  }

  Color _getLoadingColor(ColorScheme colorScheme) {
    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.onSecondaryContainer;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return colorScheme.primary;
    }
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
