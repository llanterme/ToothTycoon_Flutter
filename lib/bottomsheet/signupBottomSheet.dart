import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/postdataModel/signupPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/socialLoginPostData.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/models/responseModel/signupResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/encryptUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';
import 'package:tooth_tycoon/widgets/customWebView.dart';
import 'dart:io' show Platform;

class SignupBottomSheet extends StatefulWidget {
  final Function loginFunction;

  SignupBottomSheet({@required this.loginFunction});

  @override
  _SignupBottomSheetState createState() => _SignupBottomSheetState();
}

class _SignupBottomSheetState extends State<SignupBottomSheet> {
  APIService _apiService = APIService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;

  TextEditingController _emailEditController = TextEditingController();
  TextEditingController _passwordEditController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  FirebaseUser _faceBookUser;

  String _faceBookRedirectUrl =
      'https://toothtycoon-41347.firebaseapp.com/__/auth/handler';
  String faceBookClientId = '860546231360514';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 500 : 410,
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
          _signupBtn(),
          Spacer(),
          _orText(),
          Spacer(),
          _signupWithFaceBookBtn(),
          if (Platform.isIOS) _signupWithAppleBtn(),
          _loginBtn(),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Sign Up',
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
        onFieldSubmitted: (String value) {
          Utils.fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
        },
        maxLines: 1,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
          fontSize: 14,
        ),
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
        top: 15,
      ),
      child: TextFormField(
        controller: _passwordEditController,
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
          fontSize: 14,
        ),
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
            fontSize: 14,
          ),
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

  Widget _signupBtn() {
    return InkWell(
      onTap: () => _validateForm() ? _submit() : null,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
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
                  'Sign Up',
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
      margin: EdgeInsets.only(top: 30, bottom: 20),
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

  Widget _signupWithFaceBookBtn() {
    return InkWell(
      onTap: () => _faceBookSignIn(),
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
                    'Sign up with Facebook',
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

  Widget _signupWithAppleBtn() {
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
                    'Sign up with Apple',
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

  Widget _loginBtn() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.loginFunction();
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
                    text: 'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.COLOR_TEXT_BLACK,
                      fontFamily: 'Avenir',
                    ),
                  ),
                  TextSpan(
                    text: 'Login',
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
          FacebookAuthProvider.getCredential(accessToken: result);
      AuthResult user =
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
                  appleIdCredential.email, "01", 'apple');
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

    SignupPostData signupPostData = SignupPostData();
    signupPostData.email = encryptedEmail;
    signupPostData.name = encryptedEmail;
    signupPostData.password = encryptedPassword;
    signupPostData.confirmPassword = encryptedPassword;

    Response response = await _apiService.signupApiCall(signupPostData);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_USER_CREATED) {
      SignupResponse signupResponse = SignupResponse.fromJson(responseData);

      await PreferenceHelper().setAccessToken(signupResponse.data.accessToken);
      await PreferenceHelper().setUserId(signupResponse.data.id.toString());
      await PreferenceHelper().setEmailId(signupResponse.data.email);
      await PreferenceHelper().setLoginResponse(response.body);
      await PreferenceHelper().setIsUserLogin(true);

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
      setState(() {
        _isLoading = false;
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
