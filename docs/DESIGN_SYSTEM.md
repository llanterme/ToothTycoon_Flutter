# Tooth Tycoon - Modern Design System

## Overview
This is the comprehensive design system for Tooth Tycoon, implementing Material 3 principles with 2025 UI/UX trends.

---

## Color System

### Primary Colors
```dart
// Light Mode
primary: #5a64b8 (Brand purple-blue)
onPrimary: #ffffff
primaryContainer: #e0e2ff
onPrimaryContainer: #00006e

// Dark Mode
primary: #bec2ff
onPrimary: #2830a1
primaryContainer: #414aa1
onPrimaryContainer: #e0e2ff
```

### Brand Colors (Preserved from Original)
```dart
brandPrimary: #727dc7  // Original purple-blue
brandYellow: #ffffea7d
brandGreen: #98FF95
brandBlue: #397BF3
brandRed: #eb5f59
```

### Surface Colors
```dart
// Light Mode
surface: #fbfbff (Clean white)
surfaceContainer: #efeef4
surfaceContainerHighest: #e3e2e9

// Dark Mode
surface: #131316 (Deep dark)
surfaceContainer: #1f1f23
surfaceContainerHighest: #343438
```

### Usage
```dart
// Access via Theme
final colorScheme = Theme.of(context).colorScheme;
Container(color: colorScheme.primary)

// Direct access to brand colors
import 'package:tooth_tycoon/ui/ui_exports.dart';
Container(color: AppColors.brandYellow)
```

---

## Typography

### Type Scale
```dart
// Display (Largest)
displayLarge: 57sp, Regular, Avenir
displayMedium: 45sp, Regular, Avenir
displaySmall: 36sp, Regular, Avenir

// Headline (High Emphasis)
headlineLarge: 32sp, SemiBold, Avenir
headlineMedium: 28sp, SemiBold, Avenir
headlineSmall: 24sp, SemiBold, Avenir

// Title (Medium Emphasis)
titleLarge: 22sp, SemiBold, Avenir
titleMedium: 16sp, SemiBold, Avenir
titleSmall: 14sp, SemiBold, Avenir

// Body (Default)
bodyLarge: 16sp, Regular, OpenSans
bodyMedium: 14sp, Regular, OpenSans
bodySmall: 12sp, Regular, OpenSans

// Label (Buttons/Forms)
labelLarge: 14sp, SemiBold, Avenir
labelMedium: 12sp, SemiBold, Avenir
labelSmall: 11sp, Medium, Avenir
```

### Usage
```dart
final textTheme = Theme.of(context).textTheme;

Text('Welcome', style: textTheme.headlineLarge)
Text('Subtitle', style: textTheme.bodyMedium)
Text('Button', style: textTheme.labelLarge)
```

---

## Spacing System

### Base Unit: 4dp

### Scale
```dart
xxxs: 4dp
xxs: 8dp
xs: 12dp
sm: 16dp
md: 20dp
lg: 24dp
xl: 28dp
xxl: 32dp
xxxl: 40dp
huge: 48dp
```

### Usage
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';

// Padding
Padding(padding: Spacing.paddingMd)  // All sides: 20dp
Padding(padding: Spacing.horizontalLg)  // Left/Right: 24dp

// Gaps
Column(
  children: [
    Widget1(),
    Spacing.gapVerticalMd,  // 20dp vertical gap
    Widget2(),
  ],
)

// Values
Container(margin: EdgeInsets.all(Spacing.lg))  // 24dp
```

### Border Radius
```dart
radiusXs: 4dp
radiusSm: 8dp
radiusMd: 12dp
radiusLg: 16dp
radiusXl: 20dp
radiusXxl: 24dp
radiusRound: 28dp
radiusPill: 999dp (Fully rounded)
```

---

## Components

### Buttons

#### AppButton Component
```dart
// Primary Button (Default)
AppButton(
  text: 'Sign Up',
  onPressed: () => _action(),
)

// With variants
AppButton(
  text: 'Login',
  variant: AppButtonVariant.outline,
  onPressed: () => _action(),
)

// With size
AppButton(
  text: 'Submit',
  size: AppButtonSize.large,  // small, medium, large
  onPressed: () => _action(),
)

// Full width with loading
AppButton(
  text: 'Processing...',
  isFullWidth: true,
  isLoading: _isSubmitting,
  onPressed: () => _action(),
)

// With icon
AppButton(
  text: 'Delete',
  icon: Icon(Icons.delete, size: 18),
  variant: AppButtonVariant.text,
  onPressed: () => _action(),
)

// Custom colors
AppButton(
  text: 'Custom',
  customColor: Colors.amber,
  customTextColor: Colors.black,
  onPressed: () => _action(),
)
```

#### Variants
- **primary**: Filled with primary color (default)
- **secondary**: Filled with secondary container
- **outline**: Outlined with border
- **text**: Text-only, no background

#### Sizes
- **small**: 40dp height
- **medium**: 50dp height (default)
- **large**: 56dp height

---

### Text Fields

#### AppTextField Component
```dart
// Basic
AppTextField(
  controller: _emailController,
  hintText: 'Email Address',
)

// With validation
AppTextField(
  controller: _passwordController,
  hintText: 'Password',
  obscureText: true,
  showPasswordToggle: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  },
)

// With icons
AppTextField(
  controller: _searchController,
  hintText: 'Search',
  prefixIcon: Icon(Icons.search),
  suffixIcon: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () => _searchController.clear(),
  ),
)

// With keyboard configuration
AppTextField(
  controller: _phoneController,
  hintText: 'Phone Number',
  keyboardType: TextInputType.phone,
  textInputAction: TextInputAction.done,
  maxLength: 10,
)

// Multi-line
AppTextField(
  controller: _notesController,
  hintText: 'Notes',
  maxLines: 4,
)
```

#### Features
- Auto password toggle
- Validation support
- Error/Helper text
- Prefix/Suffix icons
- Max length counter
- Focus management
- Input formatters

---

### Cards

#### AppCard Component
```dart
// Basic elevated card
AppCard(
  child: Text('Content'),
)

// With variants
AppCard(
  variant: AppCardVariant.filled,
  padding: Spacing.paddingLg,
  child: Column(children: [...]),
)

// With tap interaction
AppCard(
  onTap: () => _navigate(),
  showShadow: true,
  child: ListTile(
    title: Text('Item'),
    subtitle: Text('Description'),
  ),
)

// Gradient card
AppCard(
  variant: AppCardVariant.gradient,
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.blue],
  ),
  child: Text('Gradient Background'),
)

// Glass morphic card
AppCard(
  variant: AppCardVariant.glass,
  child: Text('Frosted Glass Effect'),
)
```

#### ActionCard (Specialized for Home Screen)
```dart
ActionCard(
  title: 'SET YOUR BUDGET',
  subtitle: "Let's decide how much a tooth is worth.",
  icon: Image.asset('assets/icons/ic_set_budget.png', height: 60),
  accentColor: AppColors.brandYellow,
  onTap: () => _openBudget(),
)
```

#### Variants
- **elevated**: Subtle shadow (default)
- **filled**: Filled background
- **outlined**: Border outline
- **gradient**: Gradient background
- **glass**: Glassmorphic effect

---

### Loading Indicators

#### LoadingIndicator
```dart
// Basic
LoadingIndicator()

// Custom
LoadingIndicator(
  color: Colors.white,
  size: 40,
  strokeWidth: 3,
)
```

#### LoadingOverlay (Full Screen)
```dart
if (_isLoading)
  LoadingOverlay(
    message: 'Processing...',
  )
```

#### InlineLoading
```dart
InlineLoading(
  text: 'Loading data...',
  size: 20,
)
```

---

## Layout Patterns

### Screen Template
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.screenPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Spacing.gapVerticalLg,
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Gradient Background
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colorScheme.primary,
        colorScheme.surface,
      ],
      stops: [0.0, 0.4],
    ),
  ),
  child: content,
)
```

### CustomScrollView with Sliver
```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: Header(),
    ),
    SliverPadding(
      padding: Spacing.horizontalMd,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ItemCard(index),
          childCount: items.length,
        ),
      ),
    ),
  ],
)
```

---

## Responsive Design

### Breakpoints
```dart
Mobile: < 600dp
Tablet: 600dp - 1200dp
Desktop: > 1200dp
```

### Usage
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';

// Check device type
if (Responsive.isMobile(context)) {
  return MobileLayout();
} else if (Responsive.isTablet(context)) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Responsive values
final padding = Responsive.valueByDevice(
  context: context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Percentage-based
final width = Responsive.widthPercent(context, 80);  // 80% of screen
```

---

## Animations

### Implicit Animations
```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  color: _isSelected ? colorScheme.primary : colorScheme.surface,
  child: content,
)
```

### Hero Animations
```dart
// Source screen
Hero(
  tag: 'image-$id',
  child: Image.asset(imagePath),
)

// Destination screen
Hero(
  tag: 'image-$id',
  child: Image.asset(imagePath),
)
```

### Page Transitions
```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
```

---

## Best Practices

### Performance
1. Use `const` constructors wherever possible
2. Avoid nested `setState` calls
3. Use `ListView.builder` for long lists
4. Implement lazy loading for images
5. Profile with DevTools regularly

### Accessibility
1. Provide semantic labels
2. Ensure 44x44dp touch targets
3. Use high contrast colors (WCAG AA)
4. Support text scaling
5. Test with screen readers

### Code Organization
```dart
// Group related widgets
Widget _buildHeader() { }
Widget _buildContent() { }
Widget _buildFooter() { }

// Extract complex widgets
class _ComplexCard extends StatelessWidget { }
```

### State Management
1. Keep state as local as possible
2. Use StatefulWidget for local state
3. Consider Provider/Riverpod for shared state
4. Separate UI from business logic

---

## Dark Mode

### Automatic Theme Switching
```dart
MaterialApp(
  theme: ui.AppTheme.lightTheme,
  darkTheme: ui.AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // Follows system preference
)
```

### Manual Theme Toggle
```dart
// In settings
ThemeMode _themeMode = ThemeMode.light;

void _toggleTheme() {
  setState(() {
    _themeMode = _themeMode == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
  });
}
```

### Theme-Aware Widgets
```dart
// Always use theme colors, never hardcoded
final colorScheme = Theme.of(context).colorScheme;
Container(color: colorScheme.primary)  // ✅ Good
Container(color: Colors.blue)  // ❌ Bad
```

---

## Migration Checklist

### From Old UI to New UI

- [ ] Replace hardcoded colors with `Theme.of(context).colorScheme`
- [ ] Replace hardcoded text styles with `Theme.of(context).textTheme`
- [ ] Replace hardcoded spacing with `Spacing` constants
- [ ] Replace custom buttons with `AppButton`
- [ ] Replace TextFormField with `AppTextField`
- [ ] Replace custom cards with `AppCard`
- [ ] Add proper border radius (`Spacing.radius*`)
- [ ] Use `const` constructors
- [ ] Test on both light and dark modes
- [ ] Verify accessibility (contrast, touch targets)

---

## Quick Reference

### Import
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';
```

This imports:
- `AppTheme`, `AppColors`, `AppTextStyles`
- `Spacing`, `Responsive`
- `AppButton`, `AppTextField`, `AppCard`, `LoadingIndicator`

### Common Patterns
```dart
// Full-width primary button
AppButton(
  text: 'Continue',
  isFullWidth: true,
  onPressed: () => _next(),
)

// Card with action
AppCard(
  onTap: () => _open(),
  showShadow: true,
  child: ListTile(...),
)

// Input field with validation
AppTextField(
  controller: _controller,
  hintText: 'Email',
  validator: (v) => _validate(v),
)

// Vertical spacing
Spacing.gapVerticalMd

// Horizontal padding
Padding(padding: Spacing.horizontalLg)
```

---

## Support & Resources

- **Documentation**: See `UI_MODERNIZATION.md`
- **Examples**: Check `/lib/ui/screens/` for modern implementations
- **Theme**: `/lib/ui/theme/`
- **Components**: `/lib/ui/widgets/common/`

---

**Design System Version**: 1.0.0
**Material Design Version**: Material 3
**Flutter Version**: 3.x+
**Last Updated**: 2025-01-07
