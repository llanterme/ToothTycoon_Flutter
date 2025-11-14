import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/loginPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/socialLoginPostData.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class LoginBottomSheetModern extends StatefulWidget {
  final Function signupFunction;
  final Function loginFunction;
  final Function resetPasswordFunction;

  const LoginBottomSheetModern({
    Key? key,
    required this.signupFunction,
    required this.loginFunction,
    required this.resetPasswordFunction,
  }) : super(key: key);

  @override
  State<LoginBottomSheetModern> createState() => _LoginBottomSheetModernState();
}

class _LoginBottomSheetModernState extends State<LoginBottomSheetModern> {
  final APIService _apiService = APIService();

  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isForgotPassword = false;
  bool _isForgotPasswordLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailEditController.dispose();
    _passwordEditController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    bool? rememberMe = await PreferenceHelper().getRememberMe();

    if (rememberMe == true) {
      String? savedEmail = await PreferenceHelper().getSavedEmail();
      String? savedPassword = await PreferenceHelper().getSavedPassword();

      setState(() {
        _rememberMe = true;
        if (savedEmail != null) _emailEditController.text = savedEmail;
        if (savedPassword != null) _passwordEditController.text = savedPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      title: 'Login',
      maxHeight: Platform.isIOS ? 550 : 470,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _emailEditController,
            focusNode: _emailFocusNode,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              Utils.fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
            },
          ),
          SizedBox(height: Spacing.md),
          AppTextField(
            controller: _passwordEditController,
            focusNode: _passwordFocusNode,
            hintText: 'Password',
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Image.asset(
                _isPasswordVisible ? 'assets/icons/ic_eye_close.png' : 'assets/icons/ic_eye_open.png',
                color: colorScheme.onSurfaceVariant,
                height: 20,
                width: 20,
              ),
            ),
          ),
          SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: colorScheme.primary,
                  ),
                  Text('Remember Me', style: theme.textTheme.bodyMedium),
                ],
              ),
              if (_isForgotPasswordLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    _isForgotPassword = true;
                    if (_validateForm()) {
                      _forgotPassword(_emailEditController.text.trim());
                    }
                  },
                  child: Text(
                    'Forgot Password',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: Spacing.md),
          AppButton(
            text: 'Login',
            onPressed: () => _validateForm() ? _submit() : null,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
          SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.md),
                child: Text('Or', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),
          SizedBox(height: Spacing.lg),
          AppButton(
            text: 'Login with Facebook',
            onPressed: !_isFacebookLoading ? _faceBookSignIn : null,
            isLoading: _isFacebookLoading,
            isFullWidth: true,
            variant: AppButtonVariant.secondary,
            icon: Image.asset('assets/icons/ic_facebook.png', height: 24, width: 24),
          ),
          if (Platform.isIOS) ...[
            SizedBox(height: Spacing.md),
            AppButton(
              text: 'Sign in with Apple',
              onPressed: !_isAppleLoading ? _appleSignIn : null,
              isLoading: _isAppleLoading,
              isFullWidth: true,
              customColor: Colors.black,
              icon: Image.asset('assets/icons/ic_apple.png', height: 24, width: 24),
            ),
          ],
          SizedBox(height: Spacing.lg),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.signupFunction();
              },
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(text: "Don't have an account? ", style: TextStyle(color: colorScheme.onSurface)),
                    TextSpan(text: 'Sign Up', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    if (_emailEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(context, 'Please enter email id');
      return false;
    } else {
      String? message = Utils.validateEmailId(_emailEditController.text.trim());
      if (message != null) {
        Utils.showAlertDialog(context, message);
        return false;
      }
    }
    if (!_isForgotPassword) {
      if (_passwordEditController.text.trim().isEmpty) {
        Utils.showAlertDialog(context, 'Please enter password');
        return false;
      } else {
        String? message = Utils.validatePassword(_passwordEditController.text.trim());
        if (message != null) {
          Utils.showAlertDialog(context, message);
          return false;
        }
      }
    }
    return true;
  }

  void _faceBookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken != null) {
          final userData = await FacebookAuth.instance.getUserData();
          _socialLogin(userData['name'], userData['email'], userData['id'], 'facebook');
          _isFacebookLoading = false;
        }
      } else if (result.status == LoginStatus.cancelled) {
        _isFacebookLoading = false;
        Utils.showAlertDialog(context, 'You cancelled the login request.');
      } else {
        _isFacebookLoading = false;
        Utils.showAlertDialog(context, 'An error has occured. Please try again!');
      }
    } catch (e) {
      _isFacebookLoading = false;
      Utils.showAlertDialog(context, 'An error has occured. Please try again!');
    }
  }

  void _appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      if (credential.identityToken != null) {
        try {
          NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
        } catch (e) {
          print("error");
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        Utils.showToast(message: "You cancelled te request.");
      } else {
        Utils.showToast(message: "Something went wrong!");
      }
    } catch (error) {
      Utils.showToast(message: "Something went wrong!");
    }
  }

  void _submit() async {
    setState(() => _isLoading = true);

    try {
      String email = _emailEditController.text.trim();
      String password = _passwordEditController.text.trim();
      List<String> deviceInfoList = await Utils.getDeviceDetails();
      String deviceId = deviceInfoList[2];

      LoginPostData loginPostData = LoginPostData(
        email: email,
        password: password,
        fcmToken: '1234567890',
        deviceId: deviceId
      );

      Response response = await _apiService.loginApiCall(loginPostData);
      dynamic responseData = json.decode(response.body);

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
        LoginResponse loginResponse = LoginResponse.fromJson(responseData);

        // Save authentication data
        await PreferenceHelper().setAccessToken(loginResponse.data!.accessToken);
        await PreferenceHelper().setUserId(loginResponse.data!.id.toString());
        await PreferenceHelper().setEmailId(loginResponse.data!.email);
        await PreferenceHelper().setLoginResponse(response.body);
        await PreferenceHelper().setIsUserLogin(true);

        // Save token expiry if available
        if (loginResponse.data!.tokens != null && loginResponse.data!.tokens!.isNotEmpty) {
          await TokenManager().saveTokenExpiry(loginResponse.data!.tokens![0].expiresAt);
        }

        // Save budget if available
        if (loginResponse.data!.budget != null) {
          await PreferenceHelper().setCurrencyId(loginResponse.data!.budget!.currencyId);
          await PreferenceHelper().setCurrencyAmount(loginResponse.data!.budget!.amount);
        }

        // Handle remember me
        if (_rememberMe) {
          await PreferenceHelper().setRememberMe(true);
          await PreferenceHelper().setSavedEmail(email);
          await PreferenceHelper().setSavedPassword(password);
        } else {
          await PreferenceHelper().clearRememberMeData();
        }

        CommonResponse.budget = loginResponse.data!.budget;

        setState(() => _isLoading = false);
        AuthErrorHandler.showSuccess('Login successful!');
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
      } else {
        setState(() => _isLoading = false);
        String message = responseData['message'] ?? responseData[Constants.KEY_MESSAGE] ?? 'Login failed';
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }

  void _forgotPassword(String email) async {
    setState(() => _isForgotPasswordLoading = true);

    try {
      Response response = await _apiService.forgotPasswordApiCall(_emailEditController.text.trim());
      dynamic responseData = json.decode(response.body);

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
        setState(() => _isForgotPasswordLoading = false);
        AuthErrorHandler.showSuccess('Verification Code has been sent to your email');
        widget.resetPasswordFunction(email);
      } else {
        setState(() => _isForgotPasswordLoading = false);
        String message = responseData['message'] ?? responseData[Constants.KEY_MESSAGE] ?? 'Failed to send verification code';
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isForgotPasswordLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }

  void _socialLogin(String displayName, String email, String socialId, String socialName) async {
    try {
      List<String> deviceInfoList = await Utils.getDeviceDetails();
      String deviceId = deviceInfoList[2];

      SocialLoginPostData socialLoginPostData = SocialLoginPostData();
      socialLoginPostData.name = displayName;
      socialLoginPostData.email = email;
      socialLoginPostData.socialId = socialId;
      socialLoginPostData.socialName = socialName;
      socialLoginPostData.fcmToken = 'ABCDABCDABCDABCDABCDABCD';
      socialLoginPostData.deviceId = deviceId;

      Response response = await _apiService.socialLoginApiCall(socialLoginPostData);
      dynamic responseData = json.decode(response.body);

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
        LoginResponse loginResponse = LoginResponse.fromJson(responseData);

        // Save authentication data
        await PreferenceHelper().setAccessToken(loginResponse.data!.accessToken);
        await PreferenceHelper().setUserId(loginResponse.data!.id.toString());
        await PreferenceHelper().setEmailId(loginResponse.data!.email);
        await PreferenceHelper().setLoginResponse(response.body);
        await PreferenceHelper().setIsUserLogin(true);

        // Save token expiry if available
        if (loginResponse.data!.tokens != null && loginResponse.data!.tokens!.isNotEmpty) {
          await TokenManager().saveTokenExpiry(loginResponse.data!.tokens![0].expiresAt);
        }

        // Save budget if available
        if (loginResponse.data!.budget != null) {
          await PreferenceHelper().setCurrencyId(loginResponse.data!.budget!.currencyId);
          await PreferenceHelper().setCurrencyAmount(loginResponse.data!.budget!.amount);
        }

        CommonResponse.budget = loginResponse.data!.budget;

        setState(() {
          if (socialName == 'facebook') {
            _isFacebookLoading = false;
          } else {
            _isAppleLoading = false;
          }
        });

        AuthErrorHandler.showSuccess('Login successful!');
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
      } else {
        setState(() {
          if (socialName == 'facebook') {
            _isFacebookLoading = false;
          } else {
            _isAppleLoading = false;
          }
        });

        String message = responseData['message'] ?? responseData[Constants.KEY_MESSAGE] ?? 'Social login failed';
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() {
        if (socialName == 'facebook') {
          _isFacebookLoading = false;
        } else {
          _isAppleLoading = false;
        }
      });
      AuthErrorHandler.handleNetworkError();
    }
  }
}
