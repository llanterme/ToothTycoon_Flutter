import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/bottomsheet/addChildBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/setBudgetBottomSheet.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/encryptUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class DeviceNotSupportedScreen extends StatefulWidget {
  @override
  _DeviceNotSupportedScreenState createState() =>
      _DeviceNotSupportedScreenState();
}

class _DeviceNotSupportedScreenState extends State<DeviceNotSupportedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_PRIMARY,
      body: SafeArea(
        child: Container(
          height: MediaQuery.maybeOf(context).size.height,
          width: MediaQuery.maybeOf(context).size.width,
          child: Center(
            child: Text(
              'This Device is Not Supported',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
