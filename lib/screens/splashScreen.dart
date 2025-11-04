import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _startTime();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.COLOR_PRIMARY,
        child: Center(
          child: Image.asset(
            'assets/icons/ic_app_icon.png',
            height: MediaQuery.of(context).size.height * 0.30,
          ),
        ),
      ),
    );
  }

  _startTime() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, _navigatePage);
  }

  void _navigatePage() async {
    // Don't clear SharedPreferences in production! This line was resetting all saved data
    // SharedPreferences.setMockInitialValues({});  // Only for testing

    bool _isUserLogin = await PreferenceHelper().getIsUserLogin() ?? false;
    print('Splash Screen - Is User Logged In: $_isUserLogin');

    if (_isUserLogin) {
      print('Navigating to HOME screen');
      NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
    } else {
      print('Navigating to WELCOME screen');
      NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
    }
  }
}
