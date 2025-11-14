import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/constants/constants.dart';

/// Handles authentication errors and provides user feedback
class AuthErrorHandler {
  static final TokenManager _tokenManager = TokenManager();

  /// Show error message to user
  static void showError(String message, {Duration? duration}) {
    BotToast.showText(
      text: message,
      duration: duration ?? const Duration(seconds: 3),
      contentColor: Colors.red,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  /// Show success message to user
  static void showSuccess(String message, {Duration? duration}) {
    BotToast.showText(
      text: message,
      duration: duration ?? const Duration(seconds: 2),
      contentColor: Colors.green,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  /// Show warning message to user
  static void showWarning(String message, {Duration? duration}) {
    BotToast.showText(
      text: message,
      duration: duration ?? const Duration(seconds: 3),
      contentColor: Colors.orange,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  /// Handle token expiry - show message and redirect to login
  static Future<void> handleTokenExpiry({String? customMessage}) async {
    // Clear all auth data
    await _tokenManager.logout();

    // Show message to user
    showError(
      customMessage ?? 'Your session has expired. Please login again.',
      duration: const Duration(seconds: 4),
    );

    // Navigate to welcome/login screen
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        NavigationService.instance.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Constants.KEY_ROUTE_WELCOME,
          (route) => false,
        );
      } catch (e) {
        print('Error navigating to login: $e');
      }
    });
  }

  /// Handle invalid token error
  static Future<void> handleInvalidToken() async {
    await handleTokenExpiry(
      customMessage: 'Invalid authentication token. Please login again.',
    );
  }

  /// Handle network errors
  static void handleNetworkError() {
    showError('Network error. Please check your internet connection.');
  }

  /// Handle general API errors
  static void handleApiError(String message) {
    showError(message);
  }

  /// Check if error is authentication-related
  static bool isAuthError(int statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  /// Parse and display error from response
  static void handleResponseError(String responseBody, int statusCode) {
    try {
      if (isAuthError(statusCode)) {
        handleInvalidToken();
      } else {
        // Try to parse error message
        showError('Error: $responseBody');
      }
    } catch (e) {
      showError('An unexpected error occurred');
    }
  }

  /// Show loading indicator
  static CancelFunc showLoading({String? message}) {
    return BotToast.showLoading(
      clickClose: false,
      allowClick: false,
      crossPage: true,
      backButtonBehavior: BackButtonBehavior.ignore,
    );
  }

  /// Check token validity before making important actions
  static Future<bool> checkTokenBeforeAction() async {
    final isAuth = await _tokenManager.isAuthenticated();

    if (!isAuth) {
      showWarning('Please login to continue');
      await handleTokenExpiry();
      return false;
    }

    return true;
  }
}
