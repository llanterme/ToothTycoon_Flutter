import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CongratulationAfterToothPullScreen extends StatefulWidget {
  @override
  _CongratulationAfterToothPullScreenState createState() =>
      _CongratulationAfterToothPullScreenState();
}

class _CongratulationAfterToothPullScreenState extends State<CongratulationAfterToothPullScreen> {
  bool _isShowAmount = false;

  int _amount = 0;

  @override
  void initState() {
    _amount = double.parse(CommonResponse.pullToothData.reward).toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.COLOR_PRIMARY,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(CommonResponse.capturedImagePath),
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.COLOR_PRIMARY.withOpacity(0.7),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _appBar(),
                  _animationWidget(),
                  _congratulationWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

  Widget _animationWidget() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ImageSequenceAnimator(
                'assets/images/congratulationsAnimationImages',
                'Congratulations',
                1,
                4,
                'png',
                132,
                fps: 24,
                isLooping: false,
                isBoomerang: false,
                isAutoPlay: true,
                onFinishPlaying: (ImageSequenceAnimatorState imageState) {
                  setState(
                    () {
                      _isShowAmount = true;
                    },
                  );
                },
              ),
            ),
          ),
          _amountWidget(),
        ],
      ),
    );
  }

  Widget _amountWidget() {
    return Center(
      child: Container(
        height: 95,
        width: 95,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.19, left: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Visibility(
            visible: _isShowAmount,
            child: Text(
              '${CommonResponse.budget.symbol}$_amount',
              style: TextStyle(
                fontSize: _amount <= 999 ? 35 : 22,
                color: AppColors.COLOR_LIGHT_YELLOW,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _congratulationWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.34,
      width: MediaQuery.of(context).size.width,
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
          _descriptionTextWidget(),
          Spacer(),
          _investBtn(),
          _cashOutBtn(),
        ],
      ),
    );
  }

  Widget _descriptionTextWidget() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Text(
        "What do you want to do?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _investBtn() {
    return InkWell(
      onTap: () {
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_INVEST_SCREEN);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          top: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_PRIMARY,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Invest It',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Widget _cashOutBtn() {
    return InkWell(
      onTap: () {
        CommonResponse.isFromChildSummary = false;
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CASH_OUT_SCREEN);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.COLOR_LIGHT_YELLOW,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Cash out',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);

    return true;
  }
}
