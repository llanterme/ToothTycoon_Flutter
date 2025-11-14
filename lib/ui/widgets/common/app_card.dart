import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/utils/spacing.dart';

/// Modern card component with multiple variants
/// Supports elevated, filled, and outlined styles with glassmorphic effects
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final Gradient? gradient;
  final Widget? badge;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.showShadow = false,
    this.gradient,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultBorderRadius = borderRadius ?? Spacing.borderRadiusXl;

    Widget cardContent = Container(
      padding: padding ?? Spacing.paddingMd,
      child: child,
    );

    // Add badge overlay if provided
    if (badge != null) {
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: [
          cardContent,
          Positioned(
            top: -8,
            right: -8,
            child: badge!,
          ),
        ],
      );
    }

    Widget card = _buildCardByVariant(
      context: context,
      colorScheme: colorScheme,
      borderRadius: defaultBorderRadius,
      child: cardContent,
    );

    // Add shadow effect if requested
    if (showShadow) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: defaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: card,
      );
    }

    // Add tap functionality
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCardByVariant({
    required BuildContext context,
    required ColorScheme colorScheme,
    required BorderRadius borderRadius,
    required Widget child,
  }) {
    switch (variant) {
      case AppCardVariant.elevated:
        return Card(
          elevation: elevation ?? 0,
          color: backgroundColor ?? colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          clipBehavior: Clip.antiAlias,
          child: child,
        );

      case AppCardVariant.filled:
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surfaceContainerHighest,
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );

      case AppCardVariant.outlined:
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surface,
            border: Border.all(
              color: borderColor ?? colorScheme.outlineVariant,
              width: 1,
            ),
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );

      case AppCardVariant.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );

      case AppCardVariant.glass:
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.7),
            borderRadius: borderRadius,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ColorFilter.mode(
              colorScheme.surface.withValues(alpha: 0.1),
              BlendMode.srcOver,
            ),
            child: child,
          ),
        );
    }
  }
}

enum AppCardVariant {
  elevated,
  filled,
  outlined,
  gradient,
  glass,
}

/// Specialized card for action items (like home screen cards)
class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback? onTap;
  final Color accentColor;
  final bool showAccentBar;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    required this.accentColor,
    this.showAccentBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      showShadow: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Card content
          Padding(
            padding: Spacing.paddingMd,
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(Spacing.xs),
                  child: icon,
                ),
                Spacing.gapHorizontalMd,
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Spacing.gapVerticalXxs,
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Accent bar at bottom
          if (showAccentBar)
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Spacing.radiusXl),
                  bottomRight: Radius.circular(Spacing.radiusXl),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
