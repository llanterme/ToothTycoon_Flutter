# Quick Start Guide - Modern UI System

Get up and running with the new modern UI system in 5 minutes.

---

## 1. Import the UI System

Add this single import to your screen:

```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';
```

This gives you access to:
- Theme system (AppTheme, AppColors, AppTextStyles)
- Spacing utilities (Spacing)
- Responsive utilities (Responsive)
- All modern components (AppButton, AppTextField, AppCard, etc.)

---

## 2. Access Theme Colors and Styles

At the top of your `build` method, grab these:

```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  // Now use them throughout your widget
  return Scaffold(
    backgroundColor: colorScheme.surface,
    body: Text(
      'Hello',
      style: textTheme.headlineLarge,
    ),
  );
}
```

---

## 3. Use Modern Components

### Buttons
```dart
// Primary button
AppButton(
  text: 'Click Me',
  onPressed: () => _handleClick(),
)

// Full-width button
AppButton(
  text: 'Submit',
  isFullWidth: true,
  onPressed: () => _submit(),
)

// Button with loading
AppButton(
  text: 'Processing',
  isLoading: _isLoading,
  onPressed: () => _process(),
)

// Outline button
AppButton(
  text: 'Cancel',
  variant: AppButtonVariant.outline,
  onPressed: () => _cancel(),
)
```

### Text Fields
```dart
// Basic input
AppTextField(
  controller: _controller,
  hintText: 'Enter your name',
)

// Email input
AppTextField(
  controller: _emailController,
  hintText: 'Email Address',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icon(Icons.email_outlined),
)

// Password input
AppTextField(
  controller: _passwordController,
  hintText: 'Password',
  obscureText: true,
  showPasswordToggle: true,
)
```

### Cards
```dart
// Basic card
AppCard(
  child: ListTile(
    title: Text('Item'),
    subtitle: Text('Description'),
  ),
)

// Action card (for home screen style)
ActionCard(
  title: 'TITLE',
  subtitle: 'Description text',
  icon: Image.asset('assets/icon.png', height: 60),
  accentColor: AppColors.brandYellow,
  onTap: () => _action(),
)
```

---

## 4. Use Spacing Tokens

Replace hardcoded values with semantic spacing:

```dart
// Instead of: EdgeInsets.all(20)
Padding(padding: Spacing.paddingMd)

// Instead of: SizedBox(height: 16)
Spacing.gapVerticalSm

// Instead of: EdgeInsets.symmetric(horizontal: 24)
Padding(padding: Spacing.horizontalLg)

// Instead of: BorderRadius.circular(30)
BorderRadius.circular(Spacing.radiusPill)
```

### Common Spacing
```dart
Spacing.paddingXs     // 12dp
Spacing.paddingSm     // 16dp
Spacing.paddingMd     // 20dp (most common)
Spacing.paddingLg     // 24dp
Spacing.paddingXl     // 28dp

Spacing.gapVerticalMd // Vertical gap of 20dp
Spacing.gapHorizontalLg // Horizontal gap of 24dp
```

---

## 5. Replace Hardcoded Colors

### Don't Do This ❌
```dart
color: Color(0xff727dc7)
color: Colors.blue
color: AppColors.COLOR_PRIMARY  // Old constant
```

### Do This ✅
```dart
color: colorScheme.primary
color: colorScheme.primaryContainer
color: AppColors.brandYellow  // For brand colors
```

### Common Color Roles
```dart
colorScheme.primary          // Main brand color
colorScheme.onPrimary        // Text on primary
colorScheme.secondary        // Secondary color
colorScheme.surface          // Background surface
colorScheme.onSurface        // Text on surface
colorScheme.error            // Error color
colorScheme.outline          // Border color
```

---

## 6. Replace Hardcoded Text Styles

### Don't Do This ❌
```dart
TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
)
```

### Do This ✅
```dart
textTheme.headlineSmall?.copyWith(
  fontWeight: FontWeight.bold,
)
```

### Common Text Styles
```dart
textTheme.displayLarge       // 57sp - Largest
textTheme.headlineLarge      // 32sp - Big titles
textTheme.headlineMedium     // 28sp - Section headers
textTheme.titleLarge         // 22sp - Card titles
textTheme.titleMedium        // 16sp - List item titles
textTheme.bodyLarge          // 16sp - Body text
textTheme.bodyMedium         // 14sp - Default text
textTheme.labelLarge         // 14sp - Button text
```

---

## 7. Common Patterns

### Screen Template
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Screen Title',
                style: textTheme.headlineLarge,
              ),
              Spacing.gapVerticalMd,
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return AppCard(
      child: Text('Content here'),
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
      colors: [colorScheme.primary, colorScheme.surface],
      stops: [0.0, 0.4],
    ),
  ),
  child: content,
)
```

### Loading State
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: LoadingIndicator())
          : _buildContent(),
    );
  }
}
```

### Button with Loading
```dart
bool _isSubmitting = false;

AppButton(
  text: 'Submit',
  isLoading: _isSubmitting,
  onPressed: () async {
    setState(() => _isSubmitting = true);
    await _submitData();
    setState(() => _isSubmitting = false);
  },
)
```

---

## 8. Migration Checklist

When modernizing a screen, check off these items:

- [ ] Import `package:tooth_tycoon/ui/ui_exports.dart`
- [ ] Add `colorScheme` and `textTheme` variables
- [ ] Replace all `Color(0x...)` with theme colors
- [ ] Replace all hardcoded `TextStyle` with theme styles
- [ ] Replace all hardcoded spacing with `Spacing` tokens
- [ ] Replace custom buttons with `AppButton`
- [ ] Replace `TextFormField` with `AppTextField`
- [ ] Replace custom cards with `AppCard`
- [ ] Use `const` constructors where possible
- [ ] Test in both light and dark mode
- [ ] Verify all functionality works

---

## 9. Testing Your Changes

### Visual Test
1. Run the app: `flutter run`
2. Navigate to your screen
3. Check that it looks good
4. Toggle dark mode (if available)
5. Check that dark mode looks good

### Functional Test
1. Click all buttons - verify they work
2. Fill out all forms - verify they work
3. Navigate between screens - verify it works
4. Check loading states - verify they appear

### Code Review
1. No hardcoded colors (`Color(0x...)`)
2. No hardcoded text styles (inline `TextStyle`)
3. No hardcoded spacing (magic numbers)
4. Using modern components
5. Using `const` constructors

---

## 10. Common Mistakes to Avoid

### ❌ Don't Do This
```dart
// Hardcoded values
Container(
  color: Color(0xff727dc7),
  padding: EdgeInsets.all(20),
  child: Text(
    'Title',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
)
```

### ✅ Do This
```dart
// Theme-based values
Container(
  color: colorScheme.primary,
  padding: Spacing.paddingMd,
  child: Text(
    'Title',
    style: textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### ❌ Don't Do This
```dart
// Custom button implementation
InkWell(
  onTap: _submit,
  child: Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Center(child: Text('Submit')),
  ),
)
```

### ✅ Do This
```dart
// Use component
AppButton(
  text: 'Submit',
  onPressed: _submit,
)
```

---

## 11. Need Help?

### Documentation
- `DESIGN_SYSTEM.md` - Complete design system reference
- `UI_MODERNIZATION.md` - Full modernization guide
- `BEFORE_AFTER_EXAMPLES.md` - Code comparison examples
- `MODERNIZATION_SUMMARY.md` - Overview and summary

### Examples
- `/lib/ui/screens/welcome_screen_modern.dart` - Modern welcome screen
- `/lib/ui/screens/home_screen_modern.dart` - Modern home screen
- `/lib/ui/widgets/common/` - Component implementations

### Quick Reference

**Import:**
```dart
import 'package:tooth_tycoon/ui/ui_exports.dart';
```

**Get Theme:**
```dart
final colorScheme = Theme.of(context).colorScheme;
final textTheme = Theme.of(context).textTheme;
```

**Common Components:**
```dart
AppButton(text: 'Click', onPressed: () {})
AppTextField(hintText: 'Enter text')
AppCard(child: widget)
LoadingIndicator()
Spacing.gapVerticalMd
```

---

## 12. Next Steps

1. **Start Small**: Pick one simple screen to modernize
2. **Use Examples**: Reference the modern screens in `/lib/ui/screens/`
3. **Test Often**: Run the app frequently to see your changes
4. **Ask Questions**: Check the documentation if stuck
5. **Iterate**: Improve based on what you learn

---

## Quick Example: Modernize a Button

### Before (20 lines)
```dart
Widget _submitBtn() {
  return InkWell(
    onTap: () => _submit(),
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      decoration: BoxDecoration(
        color: Color(0xff4769B0),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    ),
  );
}
```

### After (5 lines)
```dart
Widget _submitBtn() {
  return AppButton(
    text: 'Submit',
    onPressed: () => _submit(),
    isFullWidth: true,
  );
}
```

**Result**: 75% less code, better functionality, automatic theming, loading state support!

---

**You're ready to start! Pick a screen and begin modernizing. Happy coding! 🚀**
