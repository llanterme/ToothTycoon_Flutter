import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';

/// Empty state component for displaying when there's no content
class EmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showIllustration;

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.showIllustration = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: Spacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or illustration
            if (showIllustration) ...[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: icon ??
                      Icon(
                        Icons.inbox_outlined,
                        size: 60,
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              Spacing.gapVerticalLg,
            ],

            // Title
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              Spacing.gapVerticalSm,
              Text(
                description!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionText != null && onActionPressed != null) ...[
              Spacing.gapVerticalLg,
              AppButton(
                text: actionText!,
                onPressed: onActionPressed,
                variant: AppButtonVariant.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
