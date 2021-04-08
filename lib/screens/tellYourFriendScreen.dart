import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class TellYourFriendScreen extends StatefulWidget {
  @override
  _TellYourFriendScreenState createState() => _TellYourFriendScreenState();
}

class _TellYourFriendScreenState extends State<TellYourFriendScreen> {
  APIService _apiService = APIService();

  bool _isLoading = false;

  double _yearCount = 1;
  double _interestCount = 1;

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(CommonResponse.capturedImagePath),
                fit: BoxFit.fill,
              ),
              Container(
                color: AppColors.COLOR_PRIMARY.withOpacity(0.7),
                child: MediaQuery.maybeOf(context).size.height <= 639
                    ? _scrollableMainView()
                    : _nonScrollableMainView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollableMainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _appBar(),
          _appIcon(),
          _congratulationWidget(),
        ],
      ),
    );
  }

  Widget _nonScrollableMainView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _appBar(),
        _appIcon(),
        _congratulationWidget(),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      width: MediaQuery.maybeOf(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _iconBack(),
        ],
      ),
    );
  }

  Widget _iconBack() {
    return InkWell(
      onTap: () => _onBackPress(),
      child: Container(
        child: Image.asset(
          'assets/icons/ic_back.png',
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  Widget _appIcon() {
    return Image.asset(
      'assets/icons/ic_fairy.png',
      height: 200,
      width: 200,
    );
  }

  Widget _congratulationWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
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
          _titleWidget(),
          _nameWidget(),
          _investingDescription(),
          _shareDescription(),
          _shareWithFriendAndFamilyBtn(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        'Investing',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _nameWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Great decision, ',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                color: AppColors.COLOR_TEXT_BLACK,
              ),
            ),
            TextSpan(
              text: CommonResponse.childName,
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                color: AppColors.COLOR_PRIMARY,
              ),
            ),
            TextSpan(
              text: '.',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                color: AppColors.COLOR_TEXT_BLACK,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _investingDescription() {
    return Container(
      child: Text(
        "By Investing your tooth money, you\ndon't even have to do anything and\nyou will get more money every day.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _shareDescription() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        "Share your pic to earn a rare badge\nand save this precious memory\nchest!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _shareWithFriendAndFamilyBtn() {
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_SHARE_SCREEN),
      child: Container(
        height: 50,
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_PRIMARY,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: _isLoading
              ? _loader()
              : Text(
                  'Tell your friends and family',
                  style: TextStyle(
                    fontSize: 18,
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

  Future<bool> _onBackPress() async {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);

    return true;
  }
}
