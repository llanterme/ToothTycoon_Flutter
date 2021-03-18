import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/loginPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/socialLoginPostData.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/encryptUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';
import 'package:tooth_tycoon/widgets/customWebView.dart';
import 'dart:io' show Platform;

class LoginBottomSheet extends StatefulWidget {
  final Function signupFunction;
  final Function loginFunction;
  final Function resetPasswordFunction;

  LoginBottomSheet({
    @required this.signupFunction,
    @required this.loginFunction,
    @required this.resetPasswordFunction,
  });

  @override
  _LoginBottomSheetState createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  APIService _apiService = APIService();

  TextEditingController _emailEditController = TextEditingController();
  TextEditingController _passwordEditController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isForgotPassword = false;
  bool _isForgotPasswordLoading = false;
  bool _isPasswordVisible = false;

  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;

  FirebaseUser _faceBookUser;

  String _faceBookRedirectUrl =
      'https://toothtycoon-41347.firebaseapp.com/__/auth/handler';
  String faceBookClientId = '860546231360514';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 500 : 420,
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
          _email(),
          _password(),
          _forgotPasswordBtn(),
          _loginBtn(),
          Spacer(),
          _orText(),
          Spacer(),
          _loginWithFaceBookBtn(),
          if (Platform.isIOS) _loginWithAppleBtn(),
          _signupBtn(),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _email() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: TextFormField(
        controller: _emailEditController,
        focusNode: _emailFocusNode,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (String value) {
          Utils.fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
        },
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
          hintText: 'Email Address',
          hintStyle: TextStyle(
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontSize: 14),
          prefix: SizedBox(
            width: 10,
          ),
          suffix: SizedBox(
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

  Widget _forgotPasswordBtn() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _isForgotPasswordLoading
              ? _forgotPasswordLoader()
              : InkWell(
                  onTap: () {
                    _isForgotPassword = true;
                    if (_validateForm()) {
                      _forgotPassword(_emailEditController.text.trim());
                    }
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.COLOR_TEXT_PRIMARY,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _loginBtn() {
    return InkWell(
      onTap: () => _validateForm() ? _submit() : null,
      /*onTap: () => NavigationService.instance.navigateToReplacementNamed(
        Constants.KEY_ROUTE_HOME,
      ),*/
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
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
                  'Login',
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

  Widget _orText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        'Or',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _loginWithFaceBookBtn() {
    return InkWell(
      onTap: () => !_isFacebookLoading ? _faceBookSignIn() : null,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_BTN_BLUE,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: _isFacebookLoading
            ? Center(
                child: _loader(),
              )
            : Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _facebookIcon(),
                  Text(
                    'Login with Facebook',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _facebookIcon() {
    return IconButton(
      onPressed: () {},
      icon: Image.asset(
        'assets/icons/ic_facebook.png',
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _loginWithAppleBtn() {
    return InkWell(
      onTap: () => _appleSignIn(),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: _isAppleLoading
            ? Center(
                child: _loader(),
              )
            : Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _appleIcon(),
                  Text(
                    'Login with Apple',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Avenir',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _appleIcon() {
    return IconButton(
      onPressed: () {},
      icon: Image.asset(
        'assets/icons/ic_apple.png',
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _signupBtn() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.signupFunction();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.COLOR_TEXT_BLACK,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.COLOR_TEXT_PRIMARY,
                      fontFamily: 'Avenir',
                    ),
                  )
                ],
              ),
            ),
          ],
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

  Widget _forgotPasswordLoader() {
    return Container(
      width: 15,
      height: 15,
      margin: EdgeInsets.only(
        right: 20,
      ),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.COLOR_PRIMARY),
      ),
    );
  }

  bool _validateForm() {
    if (_emailEditController.text.trim().isEmpty) {
      Utils.showAlertDialog(
        context,
        'Please enter email id',
      );
      return false;
    } else {
      String message = Utils.validateEmailId(_emailEditController.text.trim());
      if (message != null) {
        Utils.showAlertDialog(context, message);
        return false;
      }
    }

    if (!_isForgotPassword) {
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
    }

    return true;
  }

  void _faceBookSignIn() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$faceBookClientId&redirect_uri=$_faceBookRedirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );
    if (result != null) {
      setState(() {
        _isFacebookLoading = true;
      });
      AuthCredential facebookAuthCred =
          FacebookAuthProvider.credential(result);
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(facebookAuthCred);
      _faceBookUser = user.user;
      print(user);
      print(facebookAuthCred);
      if (_faceBookUser.email != null) {
        _socialLogin(
            _faceBookUser.displayName, _faceBookUser.email, result, 'facebook');
      } else {
        setState(() {
          _isFacebookLoading = false;
        });
        Utils.showAlertDialog(
            context, 'Email-Id dose not exists in your facebook account');
      }
    }
  }

  void _appleSignIn() async {
    if (await AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
      try {
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [
            Scope.email,
            Scope.fullName,
          ])
        ]);

        switch (result.status) {
          case AuthorizationStatus.authorized:
            try {
              print("successfull sign in");
              print(result.credential.user); //All the required credentials
              final AppleIdCredential appleIdCredential = result.credential;
              _socialLogin(appleIdCredential.fullName.givenName,
                  appleIdCredential.fullName.givenName, '', 'apple');
            } catch (e) {
              print("error");
            }
            break;
          case AuthorizationStatus.error:
            print("Sign in failed: ${result.error.localizedDescription}");
            Utils.showToast(message: "Something went wrong!");
            break;

          case AuthorizationStatus.cancelled:
            print('User cancelled');
            break;
        }
      } catch (error) {
        print(error);
      }
    } else {
      print('Apple SignIn is not available for your device');
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailEditController.text.trim();
    String password = _passwordEditController.text.trim();
    String encryptedEmail = await EncryptUtils.encryptText(email);
    String encryptedPassword = await EncryptUtils.encryptText(password);

    print('Encrypted Password : $encryptedPassword}');

    List<String> deviceInfoList = await Utils.getDeviceDetails();
    String deviceId = deviceInfoList[2];

    LoginPostData loginPostData = LoginPostData();
    loginPostData.email = encryptedEmail;
    loginPostData.password = encryptedPassword;
    loginPostData.fcmToken = '1234567890';
    loginPostData.deviceId = deviceId;

    Response response = await _apiService.loginApiCall(loginPostData);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      LoginResponse loginResponse = LoginResponse.fromJson(responseData);

      await PreferenceHelper().setAccessToken(loginResponse.data.accessToken);
      await PreferenceHelper().setUserId(loginResponse.data.id.toString());
      await PreferenceHelper().setEmailId(loginResponse.data.email);
      await PreferenceHelper().setLoginResponse(response.body);
      await PreferenceHelper().setIsUserLogin(true);
      if (loginResponse.data.budget != null) {
        await PreferenceHelper()
            .setCurrencyId(loginResponse.data.budget.currencyId);
        await PreferenceHelper()
            .setCurrencyAmount(loginResponse.data.budget.amount);
      }

      CommonResponse.budget = loginResponse.data.budget;

      setState(() {
        _isLoading = false;
      });

      NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
    } else if (response.statusCode == 422) {
      message = responseData['message'];

      setState(() {
        _isLoading = false;
      });

      Utils.showAlertDialog(context, message);
    } else {
      message = responseData['message'];
      setState(() {
        _isLoading = false;
      });

      Utils.showAlertDialog(context, message);
    }
  }

  void _forgotPassword(String email) async {
    setState(() {
      _isForgotPasswordLoading = true;
    });

    String email = _emailEditController.text.trim();
    String encryptedEmail = await EncryptUtils.encryptText(email);

    Response response = await _apiService.forgotPasswordApiCall(encryptedEmail);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() {
        _isForgotPasswordLoading = false;
      });
      Utils.showToast(
          message: 'Verification Code has been sent to your email id',
          durationInSecond: 3);
      widget.resetPasswordFunction(email);
    } else {
      message = responseData['message'];
      setState(() {
        _isForgotPasswordLoading = false;
      });

      Utils.showAlertDialog(context, message);
    }
  }

  void _socialLogin(String displayName, String email, String socialId,
      String socialName) async {
    List<String> deviceInfoList = await Utils.getDeviceDetails();
    String deviceId = deviceInfoList[2];

    SocialLoginPostData socialLoginPostData = SocialLoginPostData();
    socialLoginPostData.name = displayName;
    socialLoginPostData.email = email;
    socialLoginPostData.socialId = socialId;
    socialLoginPostData.socialName = socialName;
    socialLoginPostData.fcmToken = 'ABCDABCDABCDABCDABCDABCD';
    socialLoginPostData.deviceId = deviceId;

    Response response =
        await _apiService.socialLoginApiCall(socialLoginPostData);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_USER_CREATED) {
      LoginResponse loginResponse = LoginResponse.fromJson(responseData);

      await PreferenceHelper().setAccessToken(loginResponse.data.accessToken);
      await PreferenceHelper().setUserId(loginResponse.data.id.toString());
      await PreferenceHelper().setEmailId(loginResponse.data.email);
      await PreferenceHelper().setLoginResponse(response.body);
      await PreferenceHelper().setIsUserLogin(true);

      CommonResponse.budget = loginResponse.data.budget;

      setState(() {
        if (socialName == 'facebook') {
          _isFacebookLoading = false;
        } else {
          _isAppleLoading = false;
        }
      });

      NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
    } else if (response.statusCode == 422) {
      message = responseData['message'];

      setState(() {
        if (socialName == 'facebook') {
          _isFacebookLoading = false;
        } else {
          _isAppleLoading = false;
        }
      });

      Utils.showAlertDialog(context, message);
    } else {
      message = responseData['message'];
      setState(() {
        if (socialName == 'facebook') {
          _isFacebookLoading = false;
        } else {
          _isAppleLoading = false;
        }
      });

      Utils.showAlertDialog(context, message);
    }
  }
}
