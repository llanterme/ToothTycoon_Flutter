# Before & After Code Examples

This document shows side-by-side comparisons of code before and after the modernization.

---

## Example 1: Button Implementation

### BEFORE
```dart
// Old welcome screen button
Widget _signupBtn() {
  return SingleChildScrollView(
    child: InkWell(
      onTap: () => _openSignupBottomSheet(),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 60),
        decoration: BoxDecoration(
          color: AppColors.COLOR_BTN_BLUE,  // Hardcoded color
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(  // Hardcoded style
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    ),
  );
}
```

### AFTER
```dart
// Modern welcome screen button
Widget _buildSignupButton(ColorScheme colorScheme) {
  return Padding(
    padding: Spacing.horizontalXl,  // Design token
    child: AppButton(  // Reusable component
      text: 'Sign Up',
      onPressed: _openSignupBottomSheet,
      isFullWidth: true,
      customColor: Colors.white,
      customTextColor: colorScheme.primary,  // Theme color
      size: AppButtonSize.large,  // Predefined size
    ),
  );
}
```

**Benefits**:
- ✅ 60% less code
- ✅ Reusable component
- ✅ Theme-based colors
- ✅ Consistent sizing
- ✅ Loading state support
- ✅ Better maintainability

---

## Example 2: Text Field Implementation

### BEFORE
```dart
// Old login text field
Widget _email() {
  return Container(
    margin: EdgeInsets.only(
      left: 30,
      right: 30,
    ),
    child: TextFormField(
      controller: _emailEditController,
      focusNode: _emailFocusNode,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String value) {
        Utils.fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
      style: TextStyle(
        color: AppColors.COLOR_TEXT_BLACK,  // Hardcoded
        fontFamily: 'Avenir',  // Hardcoded
        fontSize: 14,  // Hardcoded
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.COLOR_LIGHT_GREY,  // Hardcoded
        isDense: true,
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(30),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: 'Email Address',
        hintStyle: TextStyle(
          color: AppColors.COLOR_TEXT_BLACK,  // Hardcoded
          fontFamily: 'Avenir',  // Hardcoded
          fontSize: 14,  // Hardcoded
        ),
        prefix: SizedBox(width: 10),
        suffix: SizedBox(width: 10),
      ),
    ),
  );
}
```

### AFTER
```dart
// Modern login text field
Widget _buildEmailField() {
  return AppTextField(  // Reusable component
    controller: _emailController,
    focusNode: _emailFocusNode,
    hintText: 'Email Address',
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    onSubmitted: (value) {
      Utils.fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
    },
    prefixIcon: Icon(Icons.email_outlined),  // Optional icon
    validator: (value) => _validateEmail(value),  // Built-in validation
  );
}
```

**Benefits**:
- ✅ 70% less code
- ✅ Automatic theming
- ✅ Built-in validation
- ✅ Icon support
- ✅ Focus management
- ✅ Consistent styling

---

## Example 3: Card Implementation

### BEFORE
```dart
// Old home screen card
Widget _setBudgetCard() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Container(
          height: 15,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ),
        Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 0),
          child: InkWell(
            onTap: () async {
              _openSetBudgetBottomSheet();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _setBudgetIcon(),
                        _setBudgetText(),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.COLOR_LIGHT_YELLOW,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _setBudgetIcon() {
  return Container(
    child: Image.asset(
      'assets/icons/ic_set_budget.png',
      height: MediaQuery.of(context).size.width * 0.25,
      width: MediaQuery.of(context).size.width * 0.25,
    ),
  );
}

Widget _setBudgetText() {
  return Container(
    height: MediaQuery.of(context).size.height * 0.10,
    margin: EdgeInsets.only(left: 20),
    width: MediaQuery.of(context).size.width * 0.50,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SET YOUR BUDGET',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            fontFamily: 'Avenir',
          ),
        ),
        SizedBox(height: 5),
        Flexible(
          child: Text(
            "Let's decide how much a tooth is worth.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
              fontStyle: FontStyle.normal,
              fontFamily: 'Avenir',
            ),
          ),
        )
      ],
    ),
  );
}
```

### AFTER
```dart
// Modern home screen card
Widget _buildSetBudgetCard() {
  return ActionCard(  // Specialized component
    title: 'SET YOUR BUDGET',
    subtitle: "Let's decide how much a tooth is worth.",
    icon: Image.asset(
      'assets/icons/ic_set_budget.png',
      height: 60,
      width: 60,
      fit: BoxFit.contain,
    ),
    accentColor: AppColors.brandYellow,  // Brand color
    onTap: _openSetBudgetBottomSheet,
  );
}
```

**Benefits**:
- ✅ 90% less code
- ✅ Consistent card design
- ✅ Automatic accent bar
- ✅ Better responsive layout
- ✅ Theme-aware colors
- ✅ Easier to maintain

---

## Example 4: Screen Background

### BEFORE
```dart
// Old home screen background
Scaffold(
  backgroundColor: AppColors.COLOR_PRIMARY,  // Solid color
  body: SafeArea(
    child: _isLoading
        ? _loadingPage()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _welcomeText(),
                _screenDescription(),
                SizedBox(height: 10),
                _setBudgetCard(),
                // ...
              ],
            ),
          ),
  ),
)
```

### AFTER
```dart
// Modern home screen background
Scaffold(
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(  // Modern gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorScheme.primary,
          colorScheme.surface,
        ],
        stops: const [0.0, 0.4],
      ),
    ),
    child: SafeArea(
      child: _isLoading ? _buildLoadingPage() : _buildContent(),
    ),
  ),
)

Widget _buildContent() {
  return CustomScrollView(  // Performance optimization
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: Spacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Spacing.gapVerticalLg,
              _buildTitle(),
              Spacing.gapVerticalXxl,
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: Spacing.horizontalMd,
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _buildSetBudgetCard(),
            Spacing.gapVerticalMd,
            _buildAddChildCard(),
            Spacing.gapVerticalMd,
            _buildViewChildrenCard(),
          ]),
        ),
      ),
    ],
  );
}
```

**Benefits**:
- ✅ Modern gradient background
- ✅ Better scroll performance (Slivers)
- ✅ Theme-based colors
- ✅ Consistent spacing
- ✅ Better organization
- ✅ More visually appealing

---

## Example 5: Loading States

### BEFORE
```dart
// Old loading indicator
Widget _loadingPage() {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: AppColors.COLOR_PRIMARY,  // Hardcoded
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ),
  );
}

// Old button loading
Widget _loginBtn() {
  return InkWell(
    onTap: () => _validateForm() ? _submit() : null,
    child: Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30, right: 30, top: 10),
      decoration: BoxDecoration(
        color: AppColors.COLOR_BTN_BLUE,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: _isLoading
            ? _loader()  // Custom loader widget
            : Text('Login', style: TextStyle(...)),
      ),
    ),
  );
}

Widget _loader() {
  return Container(
    width: 30,
    height: 30,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  );
}
```

### AFTER
```dart
// Modern loading indicator
Widget _buildLoadingPage() {
  return const Center(
    child: LoadingIndicator(  // Reusable component
      color: Colors.white,
      size: 40,
    ),
  );
}

// Modern button with built-in loading
Widget _buildLoginButton() {
  return AppButton(
    text: 'Login',
    onPressed: _validateForm() ? _submit : null,
    isLoading: _isLoading,  // Built-in loading state
    isFullWidth: true,
  );
}
```

**Benefits**:
- ✅ 70% less code
- ✅ Built-in loading states
- ✅ Consistent indicators
- ✅ Automatic color handling
- ✅ No manual loader widgets

---

## Example 6: Typography

### BEFORE
```dart
// Old text styling
Text(
  "Let's get started",
  style: TextStyle(  // Hardcoded style
    fontSize: 33,
    color: Colors.white,
    fontFamily: 'Avenir',
  ),
)

Text(
  'SET YOUR BUDGET',
  style: TextStyle(  // Hardcoded style
    fontSize: 15,
    fontWeight: FontWeight.w900,
    fontFamily: 'Avenir',
  ),
)

Text(
  "Let's decide how much a tooth is worth.",
  style: TextStyle(  // Hardcoded style
    fontSize: 13,
    fontWeight: FontWeight.w100,
    fontStyle: FontStyle.normal,
    fontFamily: 'Avenir',
  ),
)
```

### AFTER
```dart
// Modern text styling
final textTheme = Theme.of(context).textTheme;

Text(
  "Let's get started",
  style: textTheme.headlineLarge?.copyWith(  // Theme-based
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
)

Text(
  'SET YOUR BUDGET',
  style: textTheme.titleMedium?.copyWith(  // Theme-based
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  ),
)

Text(
  "Let's decide how much a tooth is worth.",
  style: textTheme.bodySmall?.copyWith(  // Theme-based
    color: colorScheme.onSurfaceVariant,
  ),
)
```

**Benefits**:
- ✅ Consistent typography
- ✅ Theme-aware
- ✅ Dark mode support
- ✅ Scalable
- ✅ Material 3 compliant

---

## Example 7: Spacing

### BEFORE
```dart
// Old spacing (hardcoded values)
Container(
  margin: EdgeInsets.only(
    left: 20,
    right: 20,
    top: 20,
  ),
  child: Column(
    children: [
      Widget1(),
      SizedBox(height: 10),
      Widget2(),
      SizedBox(height: 5),
      Widget3(),
    ],
  ),
)

Padding(
  padding: EdgeInsets.only(left: 30, right: 30, top: 60),
  child: Widget(),
)

Container(
  margin: EdgeInsets.symmetric(horizontal: 20),
  child: Widget(),
)
```

### AFTER
```dart
// Modern spacing (design tokens)
Padding(
  padding: Spacing.paddingMd,  // 20dp all sides
  child: Column(
    children: [
      Widget1(),
      Spacing.gapVerticalSm,  // 16dp gap
      Widget2(),
      Spacing.gapVerticalXxs,  // 8dp gap
      Widget3(),
    ],
  ),
)

Padding(
  padding: Spacing.horizontalXl,  // Semantic spacing
  child: Widget(),
)

Padding(
  padding: Spacing.screenPaddingHorizontal,  // Screen-specific
  child: Widget(),
)
```

**Benefits**:
- ✅ Consistent spacing
- ✅ Semantic naming
- ✅ Easy to adjust globally
- ✅ Better readability
- ✅ Follows 4dp grid

---

## Example 8: Colors

### BEFORE
```dart
// Old color usage (hardcoded)
Container(
  color: Color(0xff727dc7),  // Magic number
  child: Text(
    'Welcome',
    style: TextStyle(color: Color(0xffffffff)),
  ),
)

Container(
  decoration: BoxDecoration(
    color: AppColors.COLOR_BTN_BLUE,  // Old constant
    borderRadius: BorderRadius.circular(30),
  ),
)

CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
)
```

### AFTER
```dart
// Modern color usage (theme-based)
final colorScheme = Theme.of(context).colorScheme;

Container(
  color: colorScheme.primary,  // Semantic color
  child: Text(
    'Welcome',
    style: TextStyle(color: colorScheme.onPrimary),  // Correct contrast
  ),
)

Container(
  decoration: BoxDecoration(
    color: colorScheme.primaryContainer,  // Material 3 role
    borderRadius: BorderRadius.circular(Spacing.radiusPill),
  ),
)

LoadingIndicator(
  color: colorScheme.onSurface,  // Automatic theming
)
```

**Benefits**:
- ✅ Automatic dark mode
- ✅ Correct contrast ratios
- ✅ Semantic color roles
- ✅ Theme consistency
- ✅ Easy to customize

---

## Example 9: Bottom Sheet Styling

### BEFORE
```dart
// Old bottom sheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  enableDrag: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  ),
  builder: (BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SignupBottomSheet(loginFunction: _openLoginBottomSheet),
  ),
);

// Bottom sheet widget
Container(
  height: Platform.isIOS ? 550 : 470,
  width: MediaQuery.of(context).size.width,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  ),
  child: Column(
    children: [
      _textTitle(),
      _email(),
      _password(),
      _loginBtn(),
    ],
  ),
)
```

### AFTER
```dart
// Modern bottom sheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  enableDrag: true,
  backgroundColor: Colors.transparent,  // For rounded corners
  builder: (BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SignupBottomSheet(loginFunction: _openLoginBottomSheet),
  ),
);

// Modern bottom sheet widget (automatically themed)
Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,  // Theme-aware
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(28),  // Larger radius
    ),
  ),
  padding: Spacing.paddingMd,
  child: Column(
    children: [
      _buildTitle(),
      Spacing.gapVerticalMd,
      _buildEmailField(),
      Spacing.gapVerticalMd,
      _buildPasswordField(),
      Spacing.gapVerticalLg,
      _buildLoginButton(),
    ],
  ),
)
```

**Benefits**:
- ✅ Automatic dark mode
- ✅ Consistent spacing
- ✅ Larger corner radius
- ✅ Theme-based colors
- ✅ Better organization

---

## Summary of Improvements

### Code Reduction
- **Buttons**: 60% less code
- **Text Fields**: 70% less code
- **Cards**: 90% less code
- **Overall**: 50-70% reduction per widget

### Consistency
- ✅ All colors from theme
- ✅ All spacing from tokens
- ✅ All typography from theme
- ✅ All components reusable

### Features Added
- ✅ Dark mode support
- ✅ Loading states
- ✅ Validation support
- ✅ Icon support
- ✅ Responsive design
- ✅ Accessibility improvements

### Developer Experience
- ✅ Less code to write
- ✅ Easier to maintain
- ✅ Consistent APIs
- ✅ Better documentation
- ✅ Reusable components

---

**Note**: All "Before" examples still work and are not broken. The "After" examples are available as opt-in improvements that can be adopted gradually.
