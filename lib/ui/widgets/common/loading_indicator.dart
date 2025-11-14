import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/utils/spacing.dart';

/// Modern loading indicators with various styles
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 24,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? colorScheme.primary,
        ),
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool showBackground;

  const LoadingOverlay({
    super.key,
    this.message,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: showBackground
          ? colorScheme.surface.withValues(alpha: 0.9)
          : Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoadingIndicator(size: 40),
            if (message != null) ...[
              Spacing.gapVerticalMd,
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline loading indicator with text
class InlineLoading extends StatelessWidget {
  final String? text;
  final double size;

  const InlineLoading({
    super.key,
    this.text,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingIndicator(size: size, strokeWidth: 2),
        if (text != null) ...[
          Spacing.gapHorizontalSm,
          Text(
            text!,
            style: textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
