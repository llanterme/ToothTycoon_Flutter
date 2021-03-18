import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/loginPostDataModel.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/encryptUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class ResetPasswordBottomSheet extends StatefulWidget {
  final Function loginFunction;
  final String email;

  ResetPasswordBottomSheet({
    @required this.loginFunction,
    @required this.email,
  });

  @override
  _ResetPasswordBottomSheetState createState() =>
      _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  APIService _apiService = APIService();

  TextEditingController _validationEditController = TextEditingController();
  TextEditingController _passwordEditController = TextEditingController();
  TextEditingController _confirmPasswordEditController =
      TextEditingController();

  FocusNode _validationCodeFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.71,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textTitle(),
          Spacer(),
          _validationCode(),
          _password(),
          _confirmPassword(),
          _resetPasswordBtn(),
          Spacer(),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Reset Password',
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _validationCode() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      child: TextFormField(
        controller: _validationEditController,
        focusNode: _validationCodeFocusNode,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(
            color: AppColors.COLOR_TEXT_BLACK,
            fontFamily: 'Avenir',
            fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.COLOR_LIGHT_GREY,
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
          hintText: 'Validation Code',
          hintStyle: TextStyle(
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontSize: 14),
          prefix: SizedBox(
            width: 10,
          ),
        ),
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      child: TextFormField(
        controller: _passwordEditController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        style: TextStyle(
            color: AppColors.COLOR_TEXT_BLACK,
            fontFamily: 'Avenir',
            fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.COLOR_LIGHT_GREY,
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
          hintText: 'Password',
          hintStyle: TextStyle(
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontSize: 14),
          prefix: SizedBox(
            width: 10,
          ),
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
              color: Colors.black,
              height: 15,
              width: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmPassword() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      child: TextFormField(
        controller: _confirmPasswordEditController,
        focusNode: _confirmPasswordFocusNode,
        obscureText: !_isConfirmPasswordVisible,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        style: TextStyle(
            color: AppColors.COLOR_TEXT_BLACK,
            fontFamily: 'Avenir',
            fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.COLOR_LIGHT_GREY,
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
          hintText: 'Confirm Password',
          hintStyle: TextStyle(
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontSize: 14),
          prefix: SizedBox(
            width: 10,
          ),
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
              color: Colors.black,
              height: 15,
              width: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resetPasswordBtn() {
    return InkWell(
      onTap: () => _validateForm() ? _resetPassword() : null,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 30),
        decoration: BoxDecoration(
          color: AppColors.COLOR_BTN_BLUE,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: _isLoading
              ? _loader()
              : Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Avenir',
                  ),
                ),
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

  bool _validateForm() {
    if (_validationEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(
        context,
        'Please enter validation code',
      );
      return false;
    } else if (_validationEditController.text.trim().length < 6 ||
        _validationEditController.text.trim().length > 6) {
      Utils.showAlertDialog(
        context,
        'Validation code should be 6 character long.',
      );
      return false;
    }

    if (_passwordEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(
        context,
        'Please enter password',
      );
      return false;
    } else {
      String message =
          Utils.validatePassword(_passwordEditController.text.trim());
      if (message != null) {
        Utils.showAlertDialog(context, message);
        return false;
      }
    }

    if (_confirmPasswordEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(
        context,
        'Please enter confirm password',
      );
      return false;
    } else {
      String message = Utils.validatePassword(
          _confirmPasswordEditController.text.trim(),
          isConfirmPassword: true);
      if (message != null) {
        Utils.showAlertDialog(context, message);
        return false;
      }
    }

    if (_passwordEditController.text.trim() !=
        _confirmPasswordEditController.text.trim()) {
      Utils.showAlertDialog(
        context,
        'password and confirm password should be same.',
      );
      return false;
    }

    return true;
  }

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    String validationCode = _validationEditController.text.trim();
    String email = await EncryptUtils.encryptText(widget.email);
    String password =
        await EncryptUtils.encryptText(_passwordEditController.text.trim());
    String confirmPassword = await EncryptUtils.encryptText(
        _confirmPasswordEditController.text.trim());

    Response response = await _apiService.resetPasswordApiCall(
        validationCode, email, password, confirmPassword);
    dynamic responseData = json.decode(response.body);
    int statusCode = responseData[Constants.KEY_STATUS_CODE];
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      if (statusCode == 1) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        widget.loginFunction();
      } else {
        setState(() {
          _isLoading = false;
        });

        Utils.showToast(message: message, durationInSecond: 3);
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
