# Tooth Tycoon Modern UI Design System

## Overview

This directory contains the modern Material 3-based design system for Tooth Tycoon. All UI components follow 2025 design trends including glassmorphism, smooth animations, and adaptive layouts.

## 📁 Directory Structure

```
lib/ui/
├── theme/                    # Theme configuration
│   ├── app_theme.dart       # Light & dark themes
│   ├── app_colors.dart      # Material 3 color schemes
│   └── app_text_styles.dart # Typography system
├── utils/                    # Utility classes
│   ├── spacing.dart         # Spacing tokens & constants
│   └── responsive.dart      # Responsive utilities
├── widgets/
│   └── common/              # Reusable UI components
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_card.dart
│       ├── app_badge.dart
│       ├── app_avatar.dart
│       ├── app_bottom_sheet.dart
│       ├── empty_state.dart
│       ├── loading_indicator.dart
│       └── animated_counter.dart
├── screens/                  # Modern screen implementations
│   ├── welcome_screen_modern.dart
│   └── home_screen_modern.dart
└── ui_exports.dart          # Barrel export file
```

## 🎨 Theme System

### Using Themes

Import the theme system:
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';
```

Apply to MaterialApp:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.light, // or .dark or .system
)
```

### Color Scheme

Access colors through Theme.of(context):
```dart
final colorScheme = Theme.of(context).colorScheme;

// Primary colors
colorScheme.primary
colorScheme.onPrimary
colorScheme.primaryContainer
colorScheme.onPrimaryContainer

// Surface colors
colorScheme.surface
colorScheme.onSurface
colorScheme.surfaceContainerLow
colorScheme.surfaceContainerHighest

// Semantic colors
colorScheme.error
colorScheme.outline
```

Brand colors available:
```dart
AppColors.brandPrimary    // Original purple-blue
AppColors.brandYellow     // #ffe7d
AppColors.brandGreen      // #98FF95
AppColors.brandBlue       // #397BF3
AppColors.brandRed        // #eb5f59
```

### Typography

Access text styles through Theme.of(context):
```dart
final textTheme = Theme.of(context).textTheme;

textTheme.displayLarge    // 57sp - Largest display
textTheme.headlineLarge   // 32sp - Section headers
textTheme.titleMedium     // 16sp - Card titles
textTheme.bodyLarge       // 16sp - Body text
textTheme.labelLarge      // 14sp - Button labels
```

Custom styles:
```dart
AppTextStyles.welcomeTitle
AppTextStyles.cardTitle
AppTextStyles.buttonText
AppTextStyles.bottomSheetTitle
```

## 📏 Spacing System

Based on 4dp base unit:

### Spacing Values
```dart
Spacing.xxxs  // 4dp
Spacing.xxs   // 8dp
Spacing.xs    // 12dp
Spacing.sm    // 16dp
Spacing.md    // 20dp
Spacing.lg    // 24dp
Spacing.xl    // 28dp
Spacing.xxl   // 32dp
Spacing.xxxl  // 40dp
Spacing.huge  // 48dp
```

### Usage Examples

Padding:
```dart
Padding(
  padding: Spacing.paddingMd,  // EdgeInsets.all(20)
  child: Text('Hello'),
)

// Or horizontal/vertical
padding: Spacing.horizontalLg  // EdgeInsets.symmetric(horizontal: 24)
padding: Spacing.verticalSm    // EdgeInsets.symmetric(vertical: 16)
```

Gaps:
```dart
Column(
  children: [
    Text('Title'),
    Spacing.gapVerticalMd,  // SizedBox(height: 20)
    Text('Content'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    Spacing.gapHorizontalSm,  // SizedBox(width: 16)
    Text('Label'),
  ],
)
```

Border Radius:
```dart
BorderRadius borderRadius = Spacing.borderRadiusXl;  // 20dp
double radius = Spacing.radiusPill;  // Fully rounded (999)
```

## 🧩 UI Components

### AppButton

Modern button with 4 variants and 3 sizes.

```dart
// Primary button
AppButton(
  text: 'Sign Up',
  onPressed: () {},
  variant: AppButtonVariant.primary,  // default
  size: AppButtonSize.medium,         // default
)

// Outline button
AppButton(
  text: 'Cancel',
  onPressed: () {},
  variant: AppButtonVariant.outline,
)

// With icon
AppButton(
  text: 'Continue',
  onPressed: () {},
  icon: Icon(Icons.arrow_forward, size: 18),
)

// Loading state
AppButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: true,
)

// Full width
AppButton(
  text: 'Get Started',
  onPressed: () {},
  isFullWidth: true,
)
```

Variants: `primary`, `secondary`, `outline`, `text`
Sizes: `small` (40px), `medium` (50px), `large` (56px)

### AppTextField

Material 3 text input with validation support.

```dart
AppTextField(
  controller: _controller,
  hintText: 'Enter your email',
  labelText: 'Email',
  prefixIcon: Icon(Icons.email_outlined),
  keyboardType: TextInputType.emailAddress,
)

// Password field with toggle
AppTextField(
  controller: _passwordController,
  hintText: 'Enter password',
  obscureText: true,
  showPasswordToggle: true,
)

// With validation
AppTextField(
  controller: _controller,
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    }
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
)
```

### AppCard

5 card variants with modern styling.

```dart
// Elevated card (default)
AppCard(
  child: Text('Content'),
  onTap: () {},
  showShadow: true,
)

// Gradient card
AppCard(
  variant: AppCardVariant.gradient,
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.blue],
  ),
  child: Text('Content'),
)

// Glass morphic card
AppCard(
  variant: AppCardVariant.glass,
  child: Text('Content'),
)
```

Variants: `elevated`, `filled`, `outlined`, `gradient`, `glass`

### ActionCard

Specialized card for action items (like home screen).

```dart
ActionCard(
  title: 'SET YOUR BUDGET',
  subtitle: "Let's decide how much a tooth is worth.",
  icon: Image.asset('assets/icons/ic_set_budget.png', height: 60),
  accentColor: AppColors.brandYellow,
  onTap: () {},
)
```

### AppBadge

Notification badges and status indicators.

```dart
// Count badge
AppBadge(
  text: '5',
  backgroundColor: colorScheme.error,
)

// Dot badge
AppBadge.dot(
  backgroundColor: colorScheme.primary,
  size: AppBadgeSize.small,
)

// Usage with icon
Stack(
  clipBehavior: Clip.none,
  children: [
    Icon(Icons.notifications),
    Positioned(
      right: -4,
      top: -4,
      child: AppBadge(text: '12'),
    ),
  ],
)
```

### AppAvatar

User avatars with multiple sources.

```dart
// Network image
AppAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 48,
)

// Local asset
AppAvatar(
  imagePath: 'assets/images/avatar.png',
  size: 64,
  showBorder: true,
)

// Initials
AppAvatar(
  initials: 'JD',
  size: 40,
  backgroundColor: colorScheme.primaryContainer,
)

// With badge
AppAvatar(
  imageUrl: user.avatar,
  badge: AppBadge.dot(backgroundColor: Colors.green),
  onTap: () => showProfile(),
)
```

### EmptyState

Display when no content is available.

```dart
EmptyState(
  title: 'No children added yet',
  description: 'Add your first child to start tracking teeth!',
  icon: Icon(Icons.child_care, size: 60),
  actionText: 'Add Child',
  onActionPressed: () => _addChild(),
)
```

### LoadingIndicator

Modern loading states.

```dart
// Simple spinner
LoadingIndicator()

// With custom color and size
LoadingIndicator(
  color: Colors.white,
  size: 40,
)

// Full screen overlay
LoadingOverlay(
  message: 'Please wait...',
)

// Inline with text
InlineLoading(
  text: 'Loading data...',
)
```

### AppBottomSheet

Consistent bottom sheet styling.

```dart
// Using wrapper
showAppBottomSheet(
  context: context,
  title: 'Select Option',
  child: Column(
    children: [
      ListTile(title: Text('Option 1')),
      ListTile(title: Text('Option 2')),
    ],
  ),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel'),
    ),
  ],
);

// Or use directly
AppBottomSheet(
  title: 'Settings',
  child: YourContent(),
  showDragHandle: true,
)
```

### AnimatedCounter

Smooth number transitions.

```dart
AnimatedCounter(
  value: _count.toDouble(),
  style: textTheme.headlineLarge,
  prefix: '\$',
  duration: Duration(milliseconds: 800),
)

// With decimals
AnimatedCounter(
  value: balance,
  prefix: '\$',
  decimalPlaces: 2,
)
```

## 📱 Responsive Utilities

Check device type:
```dart
if (Responsive.isMobile(context)) {
  // Mobile layout
} else if (Responsive.isTablet(context)) {
  // Tablet layout
}
```

Get responsive values:
```dart
double width = Responsive.widthPercent(context, 80);  // 80% of screen

T value = Responsive.valueByDevice<T>(
  context: context,
  mobile: 16.0,
  tablet: 20.0,
  desktop: 24.0,
);
```

Responsive sizing:
```dart
final responsive = ResponsiveSize(context);
double fontSize = responsive.fontSize(16);
double padding = responsive.padding(20);
```

## 🎯 Migration Guide

### Converting Old Screens to Modern

1. **Import the UI system:**
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';
```

2. **Replace hardcoded colors:**
```dart
// Before
backgroundColor: AppColors.COLOR_PRIMARY

// After
backgroundColor: Theme.of(context).colorScheme.primary
```

3. **Use spacing tokens:**
```dart
// Before
SizedBox(height: 20)
EdgeInsets.only(left: 20, right: 20)

// After
Spacing.gapVerticalMd
Spacing.horizontalMd
```

4. **Replace custom widgets:**
```dart
// Before
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
  ),
  child: InkWell(onTap: () {}),
)

// After
AppCard(
  child: YourContent(),
  onTap: () {},
)
```

5. **Use text theme:**
```dart
// Before
Text(
  'Title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

// After
Text(
  'Title',
  style: Theme.of(context).textTheme.headlineSmall,
)
```

### Example: Modernizing a Screen

**Before:**
```dart
class OldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_PRIMARY,
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text('Hello'),
          ),
        ],
      ),
    );
  }
}
```

**After:**
```dart
class ModernScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Spacing.gapVerticalMd,
              Padding(
                padding: Spacing.horizontalMd,
                child: AppCard(
                  child: Text(
                    'Hello',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🎨 Design Principles

1. **Material 3 First** - Use Material 3 components and patterns
2. **Consistent Spacing** - Always use Spacing tokens
3. **Theme-Aware** - Access colors through Theme.of(context)
4. **Responsive** - Consider different screen sizes
5. **Accessible** - Include semantic labels and proper contrast
6. **Performant** - Use const constructors where possible
7. **60fps Smooth** - Optimize animations and rebuilds

## 📝 Best Practices

1. **Always import ui_exports.dart** instead of individual files
2. **Use colorScheme** over hardcoded colors
3. **Use textTheme** for all text styling
4. **Apply Spacing tokens** consistently
5. **Test in both light and dark modes**
6. **Add loading states** for async operations
7. **Include empty states** when showing lists
8. **Use const constructors** for static widgets
9. **Avoid rebuilding** entire widgets unnecessarily
10. **Keep business logic separate** from UI code

## 🚀 Next Steps

To complete the UI modernization:

1. ✅ Theme system created
2. ✅ Common components built
3. ✅ Welcome and Home screens modernized
4. 🔲 Modernize bottom sheets
5. 🔲 Create modern versions of remaining screens
6. 🔲 Update navigation routes
7. 🔲 Test all user flows

## 📚 Resources

- [Material 3 Design Guidelines](https://m3.material.io/)
- [Flutter Material 3 Documentation](https://docs.flutter.dev/ui/design/material)
- [Color Scheme Documentation](https://api.flutter.dev/flutter/material/ColorScheme-class.html)
- [Typography Scale](https://m3.material.io/styles/typography/type-scale-tokens)

## 💡 Tips

- Use `Theme.of(context).colorScheme` for colors
- Use `Theme.of(context).textTheme` for text styles
- Use `Spacing.*` for all spacing values
- Use `Responsive.*` for adaptive layouts
- Always test on real devices
- Profile performance with DevTools
- Check accessibility with screen readers

---

**Remember:** All functionality must remain unchanged. Only UI/UX layer changes are allowed.
