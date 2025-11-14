import 'package:flutter/material.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';

/// Design System Showcase - Demo screen showing all UI components
/// This screen can be used during development to preview components
class DesignSystemShowcase extends StatefulWidget {
  const DesignSystemShowcase({super.key});

  @override
  State<DesignSystemShowcase> createState() => _DesignSystemShowcaseState();
}

class _DesignSystemShowcaseState extends State<DesignSystemShowcase> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Showcase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // Toggle theme (would need theme provider in real app)
            },
          ),
        ],
      ),
      body: ListView(
        padding: Spacing.paddingMd,
        children: [
          // Typography Section
          _buildSection(
            title: 'Typography',
            children: [
              Text('Display Large', style: textTheme.displayLarge),
              Text('Headline Large', style: textTheme.headlineLarge),
              Text('Title Medium', style: textTheme.titleMedium),
              Text('Body Large', style: textTheme.bodyLarge),
              Text('Label Large', style: textTheme.labelLarge),
            ],
          ),

          // Colors Section
          _buildSection(
            title: 'Colors',
            children: [
              Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                children: [
                  _colorChip('Primary', colorScheme.primary, colorScheme.onPrimary),
                  _colorChip('Secondary', colorScheme.secondary, colorScheme.onSecondary),
                  _colorChip('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
                  _colorChip('Error', colorScheme.error, colorScheme.onError),
                  _colorChip('Surface', colorScheme.surface, colorScheme.onSurface),
                ],
              ),
            ],
          ),

          // Buttons Section
          _buildSection(
            title: 'Buttons',
            children: [
              AppButton(
                text: 'Primary Button',
                onPressed: () {},
              ),
              Spacing.gapVerticalSm,
              AppButton(
                text: 'Secondary Button',
                onPressed: () {},
                variant: AppButtonVariant.secondary,
              ),
              Spacing.gapVerticalSm,
              AppButton(
                text: 'Outline Button',
                onPressed: () {},
                variant: AppButtonVariant.outline,
              ),
              Spacing.gapVerticalSm,
              AppButton(
                text: 'Text Button',
                onPressed: () {},
                variant: AppButtonVariant.text,
              ),
              Spacing.gapVerticalSm,
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Small',
                      onPressed: () {},
                      size: AppButtonSize.small,
                    ),
                  ),
                  Spacing.gapHorizontalSm,
                  Expanded(
                    child: AppButton(
                      text: 'Medium',
                      onPressed: () {},
                      size: AppButtonSize.medium,
                    ),
                  ),
                  Spacing.gapHorizontalSm,
                  Expanded(
                    child: AppButton(
                      text: 'Large',
                      onPressed: () {},
                      size: AppButtonSize.large,
                    ),
                  ),
                ],
              ),
              Spacing.gapVerticalSm,
              AppButton(
                text: 'Loading Button',
                onPressed: () {},
                isLoading: true,
              ),
            ],
          ),

          // Text Fields Section
          _buildSection(
            title: 'Text Fields',
            children: [
              AppTextField(
                hintText: 'Enter text',
                labelText: 'Label',
              ),
              Spacing.gapVerticalSm,
              AppTextField(
                hintText: 'With prefix icon',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              Spacing.gapVerticalSm,
              AppTextField(
                hintText: 'Password',
                obscureText: true,
                showPasswordToggle: true,
              ),
            ],
          ),

          // Cards Section
          _buildSection(
            title: 'Cards',
            children: [
              AppCard(
                variant: AppCardVariant.elevated,
                child: Text('Elevated Card', style: textTheme.titleMedium),
              ),
              Spacing.gapVerticalSm,
              AppCard(
                variant: AppCardVariant.filled,
                child: Text('Filled Card', style: textTheme.titleMedium),
              ),
              Spacing.gapVerticalSm,
              AppCard(
                variant: AppCardVariant.outlined,
                child: Text('Outlined Card', style: textTheme.titleMedium),
              ),
              Spacing.gapVerticalSm,
              AppCard(
                variant: AppCardVariant.gradient,
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                child: Text(
                  'Gradient Card',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              Spacing.gapVerticalSm,
              ActionCard(
                title: 'ACTION CARD',
                subtitle: 'This is a specialized action card',
                icon: const Icon(Icons.star, size: 48, color: Colors.amber),
                accentColor: Colors.amber,
                onTap: () {},
              ),
            ],
          ),

          // Badges Section
          _buildSection(
            title: 'Badges',
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications, size: 32),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: AppBadge(text: '5'),
                      ),
                    ],
                  ),
                  Spacing.gapHorizontalLg,
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.mail, size: 32),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: AppBadge(text: '99+'),
                      ),
                    ],
                  ),
                  Spacing.gapHorizontalLg,
                  AppBadge.dot(
                    backgroundColor: Colors.green,
                    size: AppBadgeSize.medium,
                  ),
                ],
              ),
            ],
          ),

          // Avatars Section
          _buildSection(
            title: 'Avatars',
            children: [
              Row(
                children: [
                  AppAvatar(
                    initials: 'JD',
                    size: 40,
                  ),
                  Spacing.gapHorizontalMd,
                  AppAvatar(
                    initials: 'AB',
                    size: 48,
                    showBorder: true,
                  ),
                  Spacing.gapHorizontalMd,
                  AppAvatar(
                    initials: 'XY',
                    size: 56,
                    badge: AppBadge.dot(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ],
          ),

          // Loading Indicators Section
          _buildSection(
            title: 'Loading Indicators',
            children: [
              Row(
                children: [
                  LoadingIndicator(size: 24),
                  Spacing.gapHorizontalLg,
                  LoadingIndicator(size: 32, color: colorScheme.error),
                  Spacing.gapHorizontalLg,
                  LoadingIndicator(size: 40, color: colorScheme.tertiary),
                ],
              ),
              Spacing.gapVerticalMd,
              InlineLoading(text: 'Loading data...'),
            ],
          ),

          // Animated Counter Section
          _buildSection(
            title: 'Animated Counter',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Count', style: textTheme.bodySmall),
                      AnimatedCounter(
                        value: _counter.toDouble(),
                        style: textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _counter++),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() => _counter = (_counter - 1).clamp(0, 999)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Empty State Section
          _buildSection(
            title: 'Empty State',
            children: [
              AppCard(
                child: EmptyState(
                  title: 'No items found',
                  description: 'Try adding some items to get started',
                  actionText: 'Add Item',
                  onActionPressed: () {},
                ),
              ),
            ],
          ),

          // Spacing Examples
          _buildSection(
            title: 'Spacing Scale',
            children: [
              _spacingExample('XXXS', Spacing.xxxs),
              _spacingExample('XXS', Spacing.xxs),
              _spacingExample('XS', Spacing.xs),
              _spacingExample('SM', Spacing.sm),
              _spacingExample('MD', Spacing.md),
              _spacingExample('LG', Spacing.lg),
              _spacingExample('XL', Spacing.xl),
              _spacingExample('XXL', Spacing.xxl),
            ],
          ),

          Spacing.gapVerticalXxl,
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBottomSheetDemo(),
        icon: const Icon(Icons.preview),
        label: const Text('Show Bottom Sheet'),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.gapVerticalXl,
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.gapVerticalSm,
        ...children,
      ],
    );
  }

  Widget _colorChip(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _spacingExample(String label, double value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${value.toInt()}dp',
            style: TextStyle(fontSize: 12),
          ),
          Spacing.gapHorizontalMd,
          Container(
            width: value,
            height: 20,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheetDemo() {
    showAppBottomSheet(
      context: context,
      title: 'Bottom Sheet Demo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This is a modern bottom sheet with consistent styling.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacing.gapVerticalMd,
          AppButton(
            text: 'Primary Action',
            onPressed: () => Navigator.pop(context),
            isFullWidth: true,
          ),
          Spacing.gapVerticalSm,
          AppButton(
            text: 'Secondary Action',
            onPressed: () => Navigator.pop(context),
            variant: AppButtonVariant.outline,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
