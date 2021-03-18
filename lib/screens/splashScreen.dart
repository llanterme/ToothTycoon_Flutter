import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';

class SplashScreen extends StatelessWidget {
  BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
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
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, _navigatePage);
  }

  void _navigatePage() async {
    bool _isUserLogin = await PreferenceHelper().getIsUserLogin() ?? false;
    if (_isUserLogin) {
      NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
    } else {
      print('Device Width : ${MediaQuery.of(_buildContext).size.width}');
      if (MediaQuery.of(_buildContext).size.width <= 350) {
        NavigationService.instance.navigateToReplacementNamed(
            Constants.KEY_DEVICE_NOT_SUPPORTED_SCREEN);
      } else {
        NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
      }
    }
  }
}
