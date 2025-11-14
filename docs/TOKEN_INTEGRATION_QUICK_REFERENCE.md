# Token Management - Quick Reference Card

## 🚀 **Quick Start**

Replace old API patterns with new token management system.

---

## 📥 **Imports**

```dart
// Add these imports
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

// Remove these imports
// import 'package:tooth_tycoon/services/apiService.dart';  // Remove
// import 'package:tooth_tycoon/helper/prefrenceHelper.dart';  // Remove for API calls
```

---

## 🔄 **Before & After Examples**

### GET Request

**❌ OLD WAY:**
```dart
String? token = await PreferenceHelper().getAccessToken();
String authToken = 'Bearer $token';
Response response = await _apiService.getCurrencyApiCall(authToken);

if (response.statusCode == 200) {
  // Success
} else if (response.statusCode == 401) {
  BotToast.showText(text: "Invalid Token");
}
```

**✅ NEW WAY:**
```dart
Response response = await ApiClient().get('/currency/get');

if (ApiClient().isSuccessResponse(response)) {
  // Success
  AuthErrorHandler.showSuccess('Loaded successfully');
} else if (response.statusCode == 401) {
  return; // Auto-handled by ApiClient
}
```

---

### POST with Form Data

**❌ OLD WAY:**
```dart
String? token = await PreferenceHelper().getAccessToken();
String authToken = 'Bearer $token';
Response response = await _apiService.setBudgetApiCall(amount, authToken, currencyId);
```

**✅ NEW WAY:**
```dart
Response response = await ApiClient().postForm(
  '/SetBudget',
  body: {
    'amount': amount,
    'currency_id': currencyId,
  },
);
```

---

### Multipart File Upload

**❌ OLD WAY:**
```dart
String? token = await PreferenceHelper().getAccessToken();
String authToken = 'Bearer $token';
AddChildPostData data = AddChildPostData();
data.name = name;
data.imagePath = imagePath;
Response response = await _apiService.addChildApiCall(data, authToken);
```

**✅ NEW WAY:**
```dart
Response response = await ApiClient().postMultipart(
  '/child/add',
  fields: {
    'name': name,
    'date_of_birth': dateOfBirth,
  },
  files: {
    'img': imagePath,
  },
);
```

---

## 🔒 **Token Validation Before Action**

For important operations (financial transactions, etc.):

```dart
void _submitImportantAction() async {
  // Check token before action
  if (!await AuthErrorHandler.checkTokenBeforeAction()) {
    return; // Token expired, user will be redirected
  }

  setState(() => _isLoading = true);

  try {
    // Perform API call
    Response response = await ApiClient().postForm('/endpoint', body: {...});

    if (ApiClient().isSuccessResponse(response)) {
      AuthErrorHandler.showSuccess('Success!');
    }
  } catch (e) {
    AuthErrorHandler.handleNetworkError();
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## 💬 **Error Handling**

**❌ OLD WAY:**
```dart
BotToast.showText(text: "Error message");
Utils.showToast(message: message, durationInSecond: 3);
```

**✅ NEW WAY:**
```dart
AuthErrorHandler.showError('Error message');
AuthErrorHandler.showSuccess('Success message');
AuthErrorHandler.showWarning('Warning message');
AuthErrorHandler.handleNetworkError(); // For network errors
```

---

## 🚪 **Logout**

**❌ OLD WAY:**
```dart
await PreferenceHelper().setLoginResponse('');
await PreferenceHelper().setIsUserLogin(false);
await PreferenceHelper().setAccessToken('');
await PreferenceHelper().setUserId('');
// ... more clearing
```

**✅ NEW WAY:**
```dart
await TokenManager().logout(); // Clears everything
AuthErrorHandler.showSuccess('Logged out successfully');
```

---

## 🎫 **Save Token Expiry (Login/Signup Only)**

**After successful login:**
```dart
if (response.statusCode == 200) {
  LoginResponse loginResponse = LoginResponse.fromJson(responseData);

  // Save to preferences
  await PreferenceHelper().setAccessToken(loginResponse.data!.accessToken);
  await PreferenceHelper().setUserId(loginResponse.data!.id.toString());

  // Save token expiry if available
  if (loginResponse.data!.tokens != null &&
      loginResponse.data!.tokens!.isNotEmpty) {
    await TokenManager().saveTokenExpiry(
      loginResponse.data!.tokens![0].expiresAt
    );
  }
}
```

**Note:** SignupResponse doesn't include tokens field

---

## 🔧 **Complete Example**

```dart
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

class MyScreen extends StatefulWidget {
  // ...
}

class _MyScreenState extends State<MyScreen> {
  bool _isLoading = false;

  void _performAction() async {
    // 1. Check token (optional but recommended for important actions)
    if (!await AuthErrorHandler.checkTokenBeforeAction()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Make API call with automatic token handling
      Response response = await ApiClient().post(
        '/endpoint',
        body: {'key': 'value'},
      );

      setState(() => _isLoading = false);

      // 3. Handle response
      if (ApiClient().isSuccessResponse(response)) {
        // Parse response
        var data = json.decode(response.body);

        // Show success
        AuthErrorHandler.showSuccess('Action completed!');

        // Navigate or update UI
        Navigator.pop(context);
      } else {
        // 4. Handle errors (401 is auto-handled)
        if (response.statusCode == 401) {
          return; // ApiClient already handled logout/redirect
        }

        String message = ApiClient().getErrorMessage(
          response,
          defaultMessage: 'Action failed'
        );
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }
}
```

---

## 🎯 **When to Use What**

| Scenario | Method | requiresAuth |
|----------|--------|--------------|
| Login | `ApiClient().post()` | `false` |
| Signup | `ApiClient().post()` | `false` |
| Forgot Password | `ApiClient().post()` | `false` |
| Reset Password | `ApiClient().post()` | `false` |
| Get Data | `ApiClient().get()` | `true` (default) |
| Submit Form | `ApiClient().postForm()` | `true` |
| Upload File | `ApiClient().postMultipart()` | `true` |
| Financial Transaction | `ApiClient().postForm()` + token check | `true` |

---

## ⚠️ **Common Mistakes to Avoid**

1. ❌ Don't manually add `Bearer` prefix - ApiClient does this
2. ❌ Don't use `PreferenceHelper().getAccessToken()` for API calls
3. ❌ Don't manually handle 401 errors - ApiClient does this
4. ❌ Don't use `BotToast.showText()` - use `AuthErrorHandler`
5. ❌ Don't forget to add token validation before important actions
6. ❌ Don't try to save token expiry on signup (SignupResponse doesn't have it)

---

## ✅ **Checklist for New API Integration**

- [ ] Import `ApiClient` and `AuthErrorHandler`
- [ ] Remove old `APIService` and manual token handling
- [ ] Use appropriate `ApiClient` method (get, post, postForm, postMultipart)
- [ ] Add token validation for important actions
- [ ] Replace BotToast with AuthErrorHandler methods
- [ ] Handle 401 errors by returning (auto-handled)
- [ ] Test with expired token scenario

---

## 📚 **Full Documentation**

See `TOKEN_INTEGRATION_SUMMARY.md` for complete details.

---

**Last Updated:** 2025-11-07
