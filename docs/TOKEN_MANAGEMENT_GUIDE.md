# Token Management System - Implementation Guide

## Overview

This guide explains the new token management system that automatically handles token expiry and invalid token errors throughout the Tooth Tycoon app.

## 🎯 Problem Solved

**Before:** Users frequently saw "Invalid Token" errors throughout the app, requiring manual logout and login.

**After:** Automatic token expiry detection with graceful error handling and user-friendly messages.

---

## 📁 New Files Created

### 1. `/lib/services/token_manager.dart`
Handles all token-related operations:
- ✅ Check if token is expired (with 5-minute grace period)
- ✅ Get valid token (automatically checks expiry)
- ✅ Token refresh logic (placeholder for when backend supports it)
- ✅ Logout and clear all auth data
- ✅ Check authentication status

### 2. `/lib/services/api_client.dart`
Enhanced HTTP client with automatic token management:
- ✅ Automatically adds Bearer token to requests
- ✅ Detects 401 errors and handles them gracefully
- ✅ Redirects to login when token is invalid
- ✅ Supports GET, POST, POST with form data, and multipart requests

### 3. `/lib/utils/auth_error_handler.dart`
User-friendly error handling utilities:
- ✅ Show error/success/warning messages
- ✅ Handle token expiry with user feedback
- ✅ Loading indicators
- ✅ Pre-action token validation

---

## 🚀 How It Works

### Token Expiry Detection

The system checks token expiry in two ways:

1. **Proactive Check:** Before each API call, `TokenManager.getValidToken()` checks if the token expires in the next 5 minutes
2. **Reactive Check:** If API returns 401, the system attempts to refresh the token or logs the user out

```dart
// Token expiry check logic
final DateTime expiresAt = DateTime.parse(expiresAtStr);
final DateTime now = DateTime.now();
final bool isExpired = now.isAfter(expiresAt.subtract(const Duration(minutes: 5)));
```

### Automatic Token Handling

```
User makes API call
       ↓
TokenManager checks token expiry
       ↓
   Expired?
    ↙    ↘
  Yes     No
   ↓       ↓
Try to   Use token
refresh   ↓
   ↓    Make API call
Logout     ↓
   ↓    401 Error?
Redirect   ↓
to login  Yes → Logout & Redirect
           ↓
          No → Return response
```

---

## 💡 Usage Examples

### Option 1: Use ApiClient (Recommended)

The `ApiClient` automatically handles tokens:

```dart
import 'package:tooth_tycoon/services/api_client.dart';

final apiClient = ApiClient();

// GET request
final response = await apiClient.get('/child');

// POST request with JSON body
final response = await apiClient.post(
  '/child/add',
  body: {'name': 'John', 'age': 8},
);

// POST request with form data
final response = await apiClient.postForm(
  '/login',
  body: {'email': 'test@example.com', 'password': 'password'},
  requiresAuth: false, // Login doesn't need auth
);

// Multipart request (for file uploads)
final response = await apiClient.postMultipart(
  '/child/teeth/pull',
  fields: {'teeth_number': '1', 'child_id': '5'},
  files: {'picture': '/path/to/image.jpg'},
);
```

### Option 2: Use TokenManager Directly

If you want to use the existing `APIService` class:

```dart
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/services/apiService.dart';

final tokenManager = TokenManager();
final apiService = APIService();

// Get valid token before API call
final token = await tokenManager.getValidToken();

if (token != null) {
  // Make API call with token
  final response = await apiService.childListApiCall(token);

  // Check for 401 error
  if (response.statusCode == 401) {
    await AuthErrorHandler.handleInvalidToken();
    return;
  }
} else {
  // Token expired and couldn't refresh
  await AuthErrorHandler.handleTokenExpiry();
}
```

### Option 3: Check Token Before Important Actions

```dart
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

// Before performing important action
if (!await AuthErrorHandler.checkTokenBeforeAction()) {
  return; // User will be redirected to login
}

// Proceed with action
await performImportantAction();
```

---

## 🔧 Error Handling Examples

### Show Error Messages

```dart
import 'package:tooth_tycoon/utils/auth_error_handler.dart';

// Show error
AuthErrorHandler.showError('Failed to load data');

// Show success
AuthErrorHandler.showSuccess('Child added successfully!');

// Show warning
AuthErrorHandler.showWarning('Please set a budget first');

// Show loading indicator
final cancel = AuthErrorHandler.showLoading();
// ... do work
cancel(); // Hide loading
```

### Handle Specific Errors

```dart
try {
  final response = await apiClient.post('/some-endpoint');

  if (apiClient.isSuccessResponse(response)) {
    AuthErrorHandler.showSuccess('Success!');
  } else {
    final errorMessage = apiClient.getErrorMessage(response);
    AuthErrorHandler.showError(errorMessage);
  }
} catch (e) {
  AuthErrorHandler.handleNetworkError();
}
```

---

## 🔒 Security Features

1. **5-Minute Grace Period:** Token is considered expired 5 minutes before actual expiry
2. **Automatic Logout:** Invalid tokens trigger automatic logout and data clearing
3. **Single Retry:** API calls are retried only once to prevent infinite loops
4. **Secure Redirect:** Users are redirected to login without exposing sensitive data

---

## 🛠️ Migrating Existing Code

### Before (Old Way):
```dart
String? authToken = await PreferenceHelper().getAccessToken();
if (authToken != null && authToken.isNotEmpty) {
  authToken = 'Bearer $authToken';
  final response = await APIService().childListApiCall(authToken);
  // Handle response
}
```

### After (New Way - Option 1: ApiClient):
```dart
final response = await ApiClient().post('/child');
if (ApiClient().isSuccessResponse(response)) {
  // Handle success
} else {
  // Errors automatically handled
}
```

### After (New Way - Option 2: TokenManager):
```dart
final token = await TokenManager().getValidToken();
if (token != null) {
  final response = await APIService().childListApiCall(token);
  if (response.statusCode == 401) {
    await AuthErrorHandler.handleInvalidToken();
  }
}
```

---

## ⚙️ Configuration

### Update Token Expiry Grace Period

In `token_manager.dart`, line 53:

```dart
// Check if token expires in the next 5 minutes (grace period)
final bool isExpired = now.isAfter(expiresAt.subtract(const Duration(minutes: 5)));
```

Change `minutes: 5` to your preferred grace period.

### Customize Error Messages

In `auth_error_handler.dart`, update messages:

```dart
static Future<void> handleTokenExpiry({String? customMessage}) async {
  showError(
    customMessage ?? 'Your session has expired. Please login again.', // Edit this
    duration: const Duration(seconds: 4),
  );
}
```

---

## 🧪 Testing

### Test Token Expiry

```dart
// Manually test token expiry
final tokenManager = TokenManager();

// Check if token is expired
final isExpired = await tokenManager.isTokenExpired();
print('Token expired: $isExpired');

// Get token expiry time
final expiry = await tokenManager.getTokenExpiry();
print('Token expires at: $expiry');

// Force logout
await tokenManager.logout();
```

### Test API Error Handling

```dart
// Test 401 error handling
try {
  final response = await ApiClient().get('/protected-endpoint');
  // If token is invalid, user will automatically be redirected to login
} catch (e) {
  print('Error: $e');
}
```

---

## 📝 Backend Requirements

### Current Implementation

The app currently uses the `expires_at` field from the login response:

```json
{
  "data": {
    "accessToken": "Bearer token...",
    "tokens": [
      {
        "expires_at": "2024-12-31T23:59:59.000000Z"
      }
    ]
  }
}
```

### Future Enhancement: Token Refresh Endpoint

To enable automatic token refresh, the backend should provide a refresh endpoint:

**Endpoint:** `POST /api/token/refresh`

**Request Headers:**
```
Authorization: Bearer {old_token}
```

**Response:**
```json
{
  "status": 200,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "Bearer new_token...",
    "expiresAt": "2024-12-31T23:59:59.000000Z"
  }
}
```

Once this endpoint is available, update `token_manager.dart` line 125:

```dart
Future<String?> refreshToken() async {
  try {
    final oldToken = await _prefHelper.getAccessToken();

    final response = await http.post(
      Uri.parse('${APIService().baseUrl}/token/refresh'),
      headers: {'Authorization': 'Bearer $oldToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newToken = data['data']['accessToken'];
      final expiresAt = data['data']['expiresAt'];

      await _prefHelper.setAccessToken(newToken);
      await saveTokenExpiry(expiresAt);

      return 'Bearer $newToken';
    }

    return null;
  } catch (e) {
    print('Error refreshing token: $e');
    return null;
  }
}
```

---

## 🎯 Benefits

✅ **Better User Experience:** No more confusing "Invalid Token" errors
✅ **Automatic Handling:** Token expiry is detected and handled automatically
✅ **Graceful Degradation:** Users are smoothly redirected to login when needed
✅ **Consistent Error Messages:** All errors are displayed in a user-friendly way
✅ **Reduced Code Duplication:** Single place to handle authentication
✅ **Future-Proof:** Ready for token refresh when backend supports it

---

## 📞 Support

If you encounter any issues with token management:

1. Check if token expiry is detected: `await TokenManager().isTokenExpired()`
2. Verify token format: Should be "Bearer {token}"
3. Check backend response for `expires_at` field
4. Look for error messages in console logs

For backend integration questions, refer to the "Backend Requirements" section above.
