import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';

/// Modern bottom sheet wrapper with consistent styling
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showDragHandle;
  final double? maxHeight;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? mediaQuery.size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (showDragHandle) ...[
            Spacing.gapVerticalSm,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Spacing.gapVerticalSm,
          ],

          // Title
          if (title != null) ...[
            Padding(
              padding: Spacing.horizontalMd,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            Divider(color: colorScheme.outlineVariant),
          ],

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: Spacing.paddingMd,
              child: child,
            ),
          ),

          // Actions
          if (actions != null && actions!.isNotEmpty) ...[
            Divider(color: colorScheme.outlineVariant),
            Padding(
              padding: Spacing.paddingMd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper to show modern bottom sheet
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  List<Widget>? actions,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AppBottomSheet(
        title: title,
        child: child,
        actions: actions,
      ),
    ),
  );
}
