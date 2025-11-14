import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';

/// Enhanced API client with automatic token management and 401 error handling
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final TokenManager _tokenManager = TokenManager();
  final String baseUrl = 'https://toothtycoon-production.up.railway.app/api';

  /// Make an authenticated GET request with automatic token handling
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? additionalHeaders,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _buildHeaders(requiresAuth, additionalHeaders);

    try {
      final response = await http.get(url, headers: headers);
      return await _handleResponse(response, () => get(endpoint, additionalHeaders: additionalHeaders, requiresAuth: requiresAuth));
    } catch (e) {
      print('GET $endpoint error: $e');
      rethrow;
    }
  }

  /// Make an authenticated POST request with automatic token handling
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _buildHeaders(requiresAuth, additionalHeaders);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return await _handleResponse(response, () => post(endpoint, body: body, additionalHeaders: additionalHeaders, requiresAuth: requiresAuth));
    } catch (e) {
      print('POST $endpoint error: $e');
      rethrow;
    }
  }

  /// Make an authenticated POST request with form data
  Future<http.Response> postForm(
    String endpoint, {
    Map<String, String>? body,
    Map<String, String>? additionalHeaders,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await _buildHeaders(requiresAuth, additionalHeaders, isJson: false);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      return await _handleResponse(response, () => postForm(endpoint, body: body, additionalHeaders: additionalHeaders, requiresAuth: requiresAuth));
    } catch (e) {
      print('POST FORM $endpoint error: $e');
      rethrow;
    }
  }

  /// Make an authenticated multipart request
  Future<http.Response> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, String>? files,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final request = http.MultipartRequest('POST', url);

      // Add authentication header
      if (requiresAuth) {
        final token = await _tokenManager.getValidToken();
        if (token != null) {
          request.headers['Authorization'] = token;
        }
      }

      // Add fields
      request.fields.addAll(fields);

      // Add files if provided
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return await _handleResponse(response, () => postMultipart(endpoint, fields: fields, files: files, requiresAuth: requiresAuth));
    } catch (e) {
      print('POST MULTIPART $endpoint error: $e');
      rethrow;
    }
  }

  /// Build headers with authentication token
  Future<Map<String, String>> _buildHeaders(
    bool requiresAuth,
    Map<String, String>? additionalHeaders, {
    bool isJson = true,
  }) async {
    final headers = <String, String>{
      if (isJson) 'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _tokenManager.getValidToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle response and check for authentication errors
  Future<http.Response> _handleResponse(
    http.Response response,
    Future<http.Response> Function() retryFunction, {
    bool hasRetried = false,
  }) async {
    // Check for 401 Unauthorized
    if (response.statusCode == 401) {
      print('⚠️ 401 Unauthorized - Token invalid or expired');

      // Try to parse the error message
      try {
        final Map<String, dynamic> body = json.decode(response.body);
        final String message = body['message'] ?? 'Invalid token';
        print('Error message: $message');

        // If we haven't retried yet, try to get a fresh token
        if (!hasRetried && message.toLowerCase().contains('invalid token')) {
          print('Attempting to refresh token...');

          // Clear the expired token
          await _tokenManager.clearTokenData();

          // Check if token can be refreshed
          final newToken = await _tokenManager.refreshToken();

          if (newToken != null) {
            // Retry the request with new token
            print('✓ Token refreshed, retrying request...');
            return await retryFunction();
          }
        }
      } catch (e) {
        print('Error parsing 401 response: $e');
      }

      // Token refresh failed or not available - navigate to login
      print('❌ Token refresh failed - redirecting to login');
      await _tokenManager.logout();
      _redirectToLogin();

      // Return the 401 response
      return response;
    }

    // For other status codes, return the response
    return response;
  }

  /// Redirect user to login screen
  void _redirectToLogin() {
    // Use a delay to ensure any dialogs are closed first
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

  /// Check if response indicates success
  bool isSuccessResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Parse error message from response
  String getErrorMessage(http.Response response, {String defaultMessage = 'An error occurred'}) {
    try {
      final Map<String, dynamic> body = json.decode(response.body);
      return body['message'] ?? defaultMessage;
    } catch (e) {
      return defaultMessage;
    }
  }
}
