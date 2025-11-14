import 'dart:convert';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';

/// Manages authentication tokens with automatic expiry checking and refresh
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final PreferenceHelper _prefHelper = PreferenceHelper();

  /// Get the current access token with automatic expiry check
  Future<String?> getValidToken() async {
    final token = await _prefHelper.getAccessToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    // Check if token is expired
    if (await isTokenExpired()) {
      print('Token expired, attempting refresh...');
      // Token is expired, try to refresh
      final newToken = await refreshToken();
      return newToken;
    }

    return 'Bearer $token';
  }

  /// Check if the current token is expired
  Future<bool> isTokenExpired() async {
    try {
      final loginResponse = await _prefHelper.getLoginResponse();
      if (loginResponse == null || loginResponse.isEmpty) {
        return true;
      }

      final Map<String, dynamic> loginData = json.decode(loginResponse);
      final LoginResponse response = LoginResponse.fromJson(loginData);

      if (response.data?.tokens == null || response.data!.tokens!.isEmpty) {
        return true;
      }

      // Get the first token's expiry date
      final String expiresAtStr = response.data!.tokens![0].expiresAt;

      if (expiresAtStr.isEmpty) {
        return false; // If no expiry date, assume it's valid
      }

      final DateTime expiresAt = DateTime.parse(expiresAtStr);
      final DateTime now = DateTime.now();

      // Check if token expires in the next 5 minutes (grace period)
      final bool isExpired = now.isAfter(expiresAt.subtract(const Duration(minutes: 5)));

      if (isExpired) {
        print('Token expired at: $expiresAt, current time: $now');
      }

      return isExpired;
    } catch (e) {
      print('Error checking token expiry: $e');
      return true; // On error, assume expired
    }
  }

  /// Get token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    try {
      final loginResponse = await _prefHelper.getLoginResponse();
      if (loginResponse == null || loginResponse.isEmpty) {
        return null;
      }

      final Map<String, dynamic> loginData = json.decode(loginResponse);
      final LoginResponse response = LoginResponse.fromJson(loginData);

      if (response.data?.tokens == null || response.data!.tokens!.isEmpty) {
        return null;
      }

      final String expiresAtStr = response.data!.tokens![0].expiresAt;
      if (expiresAtStr.isEmpty) {
        return null;
      }

      return DateTime.parse(expiresAtStr);
    } catch (e) {
      print('Error getting token expiry: $e');
      return null;
    }
  }

  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(String expiresAt) async {
    try {
      final loginResponse = await _prefHelper.getLoginResponse();
      if (loginResponse == null || loginResponse.isEmpty) {
        return;
      }

      final Map<String, dynamic> loginData = json.decode(loginResponse);

      // Update the expiry date in the stored response
      if (loginData['data'] != null &&
          loginData['data']['tokens'] != null &&
          (loginData['data']['tokens'] as List).isNotEmpty) {
        loginData['data']['tokens'][0]['expires_at'] = expiresAt;
        await _prefHelper.setLoginResponse(json.encode(loginData));
      }
    } catch (e) {
      print('Error saving token expiry: $e');
    }
  }

  /// Refresh the authentication token
  /// Note: This requires backend support for token refresh endpoint
  /// Currently returns null - needs to be implemented when backend adds refresh endpoint
  Future<String?> refreshToken() async {
    try {
      // TODO: Implement actual token refresh API call when backend supports it
      // For now, we'll return null to trigger re-login

      print('Token refresh not implemented - user needs to login again');

      // Clear expired token
      await clearTokenData();

      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }

  /// Clear all token and authentication data
  Future<void> clearTokenData() async {
    await _prefHelper.setAccessToken('');
    await _prefHelper.setLoginResponse('');
    await _prefHelper.setIsUserLogin(false);
    await _prefHelper.setUserId('');
    await _prefHelper.setEmailId('');
  }

  /// Force logout and clear all data
  Future<void> logout() async {
    await clearTokenData();
    await _prefHelper.setCurrencyId('');
    await _prefHelper.setCurrencyAmount('');
    print('User logged out - all data cleared');
  }

  /// Check if user is authenticated with valid token
  Future<bool> isAuthenticated() async {
    final isLogin = await _prefHelper.getIsUserLogin();
    if (isLogin != true) {
      return false;
    }

    final token = await _prefHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    // Check if token is expired
    final expired = await isTokenExpired();
    return !expired;
  }
}
