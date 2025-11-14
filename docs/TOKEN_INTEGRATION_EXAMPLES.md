# Token Management Integration Examples

Quick examples showing how to update existing screens to use the new token management system.

## 📱 Example 1: View Children Screen

### Before (Old Code):
```dart
Future<void> getChildListApiCall() async {
  String? authToken = await PreferenceHelper().getAccessToken();
  if (authToken != null && authToken.isNotEmpty) {
    authToken = 'Bearer $authToken';
    http.Response response = await APIService().childListApiCall(authToken);

    if (response.statusCode == 200) {
      // Handle success
    } else if (response.statusCode == 401) {
      // Show "Invalid Token" error
      BotToast.showText(text: "Invalid Token");
    }
  }
}
```

### After (New Code - Recommended):
```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> getChildListApiCall() async {
  final cancel = AuthErrorHandler.showLoading();

  try {
    final response = await ApiClient().post('/child');
    cancel();

    if (ApiClient().isSuccessResponse(response)) {
      // Parse and handle response
      final Map<String, dynamic> data = json.decode(response.body);
      // ... handle success
    } else {
      final errorMsg = ApiClient().getErrorMessage(response);
      AuthErrorHandler.showError(errorMsg);
    }
  } catch (e) {
    cancel();
    AuthErrorHandler.handleNetworkError();
  }
}
```

### After (Alternative - Using TokenManager):
```dart
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> getChildListApiCall() async {
  final token = await TokenManager().getValidToken();

  if (token == null) {
    await AuthErrorHandler.handleTokenExpiry();
    return;
  }

  final cancel = AuthErrorHandler.showLoading();

  try {
    http.Response response = await APIService().childListApiCall(token);
    cancel();

    if (response.statusCode == 200) {
      // Handle success
    } else if (response.statusCode == 401) {
      await AuthErrorHandler.handleInvalidToken();
    } else {
      AuthErrorHandler.showError('Failed to load children');
    }
  } catch (e) {
    cancel();
    AuthErrorHandler.handleNetworkError();
  }
}
```

---

## 📱 Example 2: Add Child Bottom Sheet

### Before:
```dart
Future<void> addChildApiCall() async {
  setState(() => _isLoading = true);

  String? authToken = await PreferenceHelper().getAccessToken();
  if (authToken != null && authToken.isNotEmpty) {
    authToken = 'Bearer $authToken';

    http.Response response = await APIService().addChildApiCall(
      addChildPostData,
      authToken,
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      // Success
    }
  }
}
```

### After:
```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> addChildApiCall() async {
  // Check auth before proceeding
  if (!await AuthErrorHandler.checkTokenBeforeAction()) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await ApiClient().postMultipart(
      '/child/add',
      fields: {
        'name': nameController.text,
        'age': ageController.text,
        // ... other fields
      },
      files: _imagePath != null ? {'img': _imagePath!} : null,
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      AuthErrorHandler.showSuccess('Child added successfully!');
      Navigator.pop(context);
      widget.addChildCallBack();
    } else {
      final errorMsg = ApiClient().getErrorMessage(response,
        defaultMessage: 'Failed to add child');
      AuthErrorHandler.showError(errorMsg);
    }
  } catch (e) {
    setState(() => _isLoading = false);
    AuthErrorHandler.handleNetworkError();
  }
}
```

---

## 📱 Example 3: Set Budget Bottom Sheet

### Before:
```dart
Future<void> setBudgetApiCall(String amount) async {
  String? authToken = await PreferenceHelper().getAccessToken();
  String? userId = await PreferenceHelper().getUserId();

  if (authToken != null && authToken.isNotEmpty) {
    authToken = 'Bearer $authToken';

    http.Response response = await APIService().setBudgetApiCall(
      authToken,
      userId!,
      _selCurrencyData!.id.toString(),
      amount,
    );

    if (response.statusCode == 200) {
      // Success
    } else if (response.statusCode == 401) {
      BotToast.showText(text: "Invalid Token");
    }
  }
}
```

### After:
```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> setBudgetApiCall(String amount) async {
  String? userId = await PreferenceHelper().getUserId();

  if (userId == null) {
    AuthErrorHandler.showError('User not found');
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await ApiClient().postForm(
      '/SetBudget',
      body: {
        'user_id': userId,
        'currency_id': _selCurrencyData!.id.toString(),
        'amount': amount,
      },
    );

    setState(() => _isLoading = false);

    if (ApiClient().isSuccessResponse(response)) {
      // Save budget locally
      Budget budget = Budget(
        currencyId: _selCurrencyData!.id.toString(),
        code: _selCurrencyData!.code,
        symbol: _selCurrencyData!.symbol,
        amount: amount,
      );
      CommonResponse.budget = budget;

      await PreferenceHelper().setCurrencyId(_selCurrencyData!.id.toString());
      await PreferenceHelper().setCurrencyAmount(amount);

      AuthErrorHandler.showSuccess('Budget set successfully!');
      Navigator.pop(context);
    } else {
      final errorMsg = ApiClient().getErrorMessage(response);
      AuthErrorHandler.showError(errorMsg);
    }
  } catch (e) {
    setState(() => _isLoading = false);
    AuthErrorHandler.handleNetworkError();
  }
}
```

---

## 📱 Example 4: Login Bottom Sheet

### Before:
```dart
Future<void> loginApiCall() async {
  http.Response response = await APIService().loginApiCall(loginPostData);

  if (response.statusCode == 200) {
    var data = JSON.jsonDecode(response.body);
    LoginResponse loginResponse = LoginResponse.fromJson(data);

    // Save token
    await PreferenceHelper().setAccessToken(loginResponse.data!.accessToken);
    await PreferenceHelper().setIsUserLogin(true);

    // Navigate to home
  } else {
    BotToast.showText(text: "Login failed");
  }
}
```

### After:
```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> loginApiCall() async {
  final cancel = AuthErrorHandler.showLoading();

  try {
    final response = await ApiClient().postForm(
      '/login',
      body: loginPostData.toJson(),
      requiresAuth: false, // Login doesn't require auth
    );

    cancel();

    if (response.statusCode == 200) {
      var data = JSON.jsonDecode(response.body);
      LoginResponse loginResponse = LoginResponse.fromJson(data);

      // Save login data
      await PreferenceHelper().setLoginResponse(response.body);
      await PreferenceHelper().setAccessToken(loginResponse.data!.accessToken);
      await PreferenceHelper().setIsUserLogin(true);
      await PreferenceHelper().setUserId(loginResponse.data!.id.toString());
      await PreferenceHelper().setEmailId(loginResponse.data!.email);

      // Save token expiry if available
      if (loginResponse.data!.tokens != null &&
          loginResponse.data!.tokens!.isNotEmpty) {
        await TokenManager().saveTokenExpiry(
          loginResponse.data!.tokens![0].expiresAt
        );
      }

      AuthErrorHandler.showSuccess('Welcome back!');

      // Navigate to home
      NavigationService.instance.navigateToReplacementNamed(
        Constants.KEY_ROUTE_HOME
      );
    } else {
      final errorMsg = ApiClient().getErrorMessage(response,
        defaultMessage: 'Login failed. Please check your credentials.');
      AuthErrorHandler.showError(errorMsg);
    }
  } catch (e) {
    cancel();
    AuthErrorHandler.handleNetworkError();
  }
}
```

---

## 📱 Example 5: Pull Tooth Screen

### Before:
```dart
Future<void> pullToothApiCall() async {
  String? authToken = await PreferenceHelper().getAccessToken();

  if (authToken != null && authToken.isNotEmpty) {
    authToken = 'Bearer $authToken';

    http.Response response = await APIService().pullToothApiCall(
      authToken,
      childId,
      teethNumber,
      imagePath,
    );

    if (response.statusCode == 200) {
      // Success
    }
  }
}
```

### After:
```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

Future<void> pullToothApiCall() async {
  // Verify token before important action
  if (!await AuthErrorHandler.checkTokenBeforeAction()) {
    return;
  }

  final cancel = AuthErrorHandler.showLoading();

  try {
    final response = await ApiClient().postMultipart(
      '/child/teeth/pull',
      fields: {
        'child_id': childId,
        'teeth_number': teethNumber,
      },
      files: imagePath != null ? {'picture': imagePath!} : null,
    );

    cancel();

    if (ApiClient().isSuccessResponse(response)) {
      var data = JSON.jsonDecode(response.body);
      // Parse response...

      AuthErrorHandler.showSuccess('Tooth pulled successfully!');

      // Navigate to next screen
      NavigationService.instance.navigateToPushNamed(
        Constants.KEY_ROUTE_QUESTION_ANSWER
      );
    } else {
      final errorMsg = ApiClient().getErrorMessage(response);
      AuthErrorHandler.showError(errorMsg);
    }
  } catch (e) {
    cancel();
    AuthErrorHandler.handleNetworkError();
  }
}
```

---

## 🔄 Quick Migration Checklist

For each API call in your app:

- [ ] Replace `PreferenceHelper().getAccessToken()` with `TokenManager().getValidToken()` or use `ApiClient()`
- [ ] Remove manual "Bearer" prefix concatenation (handled automatically)
- [ ] Replace `BotToast.showText()` with `AuthErrorHandler.showError()`
- [ ] Add `AuthErrorHandler.checkTokenBeforeAction()` before important operations
- [ ] Handle 401 errors with `AuthErrorHandler.handleInvalidToken()`
- [ ] Use `AuthErrorHandler.showLoading()` for loading indicators
- [ ] Show success messages with `AuthErrorHandler.showSuccess()`

---

## 🎯 Benefits You'll See

✅ Users will see "Your session has expired. Please login again." instead of "Invalid Token"
✅ Automatic redirect to login screen when token expires
✅ Token expiry is checked BEFORE making API calls (prevents failed requests)
✅ Consistent loading indicators across the app
✅ Better error messages that users can understand
✅ Reduced code duplication in every screen

---

## 🆘 Need Help?

If you're unsure how to migrate a specific API call, refer to:
1. `TOKEN_MANAGEMENT_GUIDE.md` - Complete documentation
2. These examples above - Real-world migration patterns
3. `lib/services/api_client.dart` - See all available methods
4. `lib/utils/auth_error_handler.dart` - See all helper functions
