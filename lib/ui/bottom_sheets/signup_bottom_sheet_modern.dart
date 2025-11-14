import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/signupPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/socialLoginPostData.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/models/responseModel/signupResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class SignupBottomSheetModern extends StatefulWidget {
  final Function loginFunction;

  const SignupBottomSheetModern({
    Key? key,
    required this.loginFunction,
  }) : super(key: key);

  @override
  State<SignupBottomSheetModern> createState() => _SignupBottomSheetModernState();
}

class _SignupBottomSheetModernState extends State<SignupBottomSheetModern> {
  final APIService _apiService = APIService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;

  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailEditController.dispose();
    _passwordEditController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      title: 'Sign Up',
      maxHeight: Platform.isIOS ? 500 : 410,
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
          SizedBox(height: Spacing.lg),
          AppButton(
            text: 'Sign Up',
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
            text: 'Sign up with Facebook',
            onPressed: _faceBookSignIn,
            isLoading: _isFacebookLoading,
            isFullWidth: true,
            variant: AppButtonVariant.secondary,
            icon: Image.asset('assets/icons/ic_facebook.png', height: 24, width: 24),
          ),
          if (Platform.isIOS) ...[
            SizedBox(height: Spacing.md),
            AppButton(
              text: 'Sign up with Apple',
              onPressed: _appleSignIn,
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
                widget.loginFunction();
              },
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(text: 'Already have an account? ', style: TextStyle(color: colorScheme.onSurface)),
                    TextSpan(text: 'Login', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
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
          final String givenName = credential.givenName ?? 'User';
          final String email = credential.email ?? '';
          final String userId = credential.userIdentifier ?? '';
          _socialLogin(givenName, email, userId, 'apple');
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

      SignupPostData signupPostData = SignupPostData();
      signupPostData.email = email;
      signupPostData.name = email.split('@')[0];
      signupPostData.password = password;
      signupPostData.confirmPassword = password;

      Response response = await _apiService.signupApiCall(signupPostData);
      dynamic responseData = json.decode(response.body);

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_USER_CREATED) {
        SignupResponse signupResponse = SignupResponse.fromJson(responseData);

        // Save authentication data
        await PreferenceHelper().setAccessToken(signupResponse.data!.accessToken);
        await PreferenceHelper().setUserId(signupResponse.data!.id.toString());
        await PreferenceHelper().setEmailId(signupResponse.data!.email);
        await PreferenceHelper().setLoginResponse(response.body);
        await PreferenceHelper().setIsUserLogin(true);

        // Note: SignupResponse doesn't include token expiry, so we skip saving it
        // Token expiry will be managed on subsequent authenticated requests

        setState(() => _isLoading = false);
        AuthErrorHandler.showSuccess('Account created successfully!');
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
      } else {
        setState(() => _isLoading = false);
        String message = responseData['message'] ?? responseData[Constants.KEY_MESSAGE] ?? 'Signup failed';
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
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

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_USER_CREATED ||
          response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
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
