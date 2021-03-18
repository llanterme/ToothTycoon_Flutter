import 'package:shared_preferences/shared_preferences.dart';
import 'package:tooth_tycoon/constants/constants.dart';

class PreferenceHelper {
  setLoginResponse(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_LOGIN_RESPONSE, value);
  }

  Future<String> getLoginResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_LOGIN_RESPONSE);
  }

  setAccessToken(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_AUTH_TOKEN, value);
  }

  Future<String> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_AUTH_TOKEN);
  }

  setUserId(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_USER_ID, value);
  }

  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_USER_ID);
  }

  setEmailId(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_EMAIL_ID, value);
  }

  Future<String> getEmailId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_EMAIL_ID);
  }

  setIsUserLogin(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(Constants.KEY_IS_LOGIN, value);
  }

  Future<bool> getIsUserLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(Constants.KEY_IS_LOGIN);
  }

  setCurrencyId(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_CURRENCY_ID, value);
  }

  Future<String> getCurrencyId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_CURRENCY_ID);
  }

  setCurrencyAmount(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Constants.KEY_CURRENCY_AMOUNT, value);
  }

  Future<String> getCurrencyAmount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.KEY_CURRENCY_AMOUNT);
  }
}
