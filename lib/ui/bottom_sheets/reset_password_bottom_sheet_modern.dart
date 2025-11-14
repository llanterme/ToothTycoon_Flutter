import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/encryptUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class ResetPasswordBottomSheetModern extends StatefulWidget {
  final Function loginFunction;
  final String email;

  const ResetPasswordBottomSheetModern({
    Key? key,
    required this.loginFunction,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPasswordBottomSheetModern> createState() => _ResetPasswordBottomSheetModernState();
}

class _ResetPasswordBottomSheetModernState extends State<ResetPasswordBottomSheetModern> {
  final APIService _apiService = APIService();

  final TextEditingController _validationEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();
  final TextEditingController _confirmPasswordEditController = TextEditingController();

  final FocusNode _validationCodeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _validationEditController.dispose();
    _passwordEditController.dispose();
    _confirmPasswordEditController.dispose();
    _validationCodeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      title: 'Reset Password',
      maxHeight: MediaQuery.of(context).size.height * 0.71,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Validation Code
          AppTextField(
            controller: _validationEditController,
            focusNode: _validationCodeFocusNode,
            hintText: 'Validation Code',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              Utils.fieldFocusChange(context, _validationCodeFocusNode, _passwordFocusNode);
            },
          ),
          SizedBox(height: Spacing.md),

          // Password
          AppTextField(
            controller: _passwordEditController,
            focusNode: _passwordFocusNode,
            hintText: 'Password',
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              Utils.fieldFocusChange(context, _passwordFocusNode, _confirmPasswordFocusNode);
            },
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Image.asset(
                _isPasswordVisible
                    ? 'assets/icons/ic_eye_close.png'
                    : 'assets/icons/ic_eye_open.png',
                color: colorScheme.onSurfaceVariant,
                height: 20,
                width: 20,
              ),
            ),
          ),
          SizedBox(height: Spacing.md),

          // Confirm Password
          AppTextField(
            controller: _confirmPasswordEditController,
            focusNode: _confirmPasswordFocusNode,
            hintText: 'Confirm Password',
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              icon: Image.asset(
                _isConfirmPasswordVisible
                    ? 'assets/icons/ic_eye_close.png'
                    : 'assets/icons/ic_eye_open.png',
                color: colorScheme.onSurfaceVariant,
                height: 20,
                width: 20,
              ),
            ),
          ),
          SizedBox(height: Spacing.xl),

          // Reset Password Button
          AppButton(
            text: 'Reset Password',
            onPressed: () => _validateForm() ? _resetPassword() : null,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    if (_validationEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(context, 'Please enter validation code');
      return false;
    } else if (_validationEditController.text.trim().length != 6) {
      Utils.showAlertDialog(context, 'Validation code should be 6 character long.');
      return false;
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

    if (_confirmPasswordEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(context, 'Please enter confirm password');
      return false;
    } else {
      String? message = Utils.validatePassword(
        _confirmPasswordEditController.text.trim(),
        isConfirmPassword: true,
      );
      if (message != null) {
        Utils.showAlertDialog(context, message);
        return false;
      }
    }

    if (_passwordEditController.text.trim() != _confirmPasswordEditController.text.trim()) {
      Utils.showAlertDialog(context, 'password and confirm password should be same.');
      return false;
    }

    return true;
  }

  void _resetPassword() async {
    setState(() => _isLoading = true);

    try {
      String validationCode = _validationEditController.text.trim();
      String email = await EncryptUtils.encryptText(widget.email);
      String password = await EncryptUtils.encryptText(_passwordEditController.text.trim());
      String confirmPassword = await EncryptUtils.encryptText(_confirmPasswordEditController.text.trim());

      // Reset password doesn't require authentication token
      Response response = await _apiService.resetPasswordApiCall(
        validationCode,
        email,
        password,
        confirmPassword,
      );

      dynamic responseData = json.decode(response.body);
      int statusCode = responseData[Constants.KEY_STATUS_CODE];
      String message = responseData[Constants.KEY_MESSAGE];

      setState(() => _isLoading = false);

      if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
        if (statusCode == 1) {
          AuthErrorHandler.showSuccess('Password reset successfully!');
          Navigator.pop(context);
          widget.loginFunction();
        } else {
          AuthErrorHandler.showError(message);
        }
      } else {
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }
}
