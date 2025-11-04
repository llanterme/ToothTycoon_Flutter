import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class CashOutScreen extends StatefulWidget {
  @override
  _CashOutScreenState createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  APIService _apiService = APIService();

  bool _isLoading = false;

  double _withdrawBalanceCount = 1;

  int _maxWithdrawLimit = 0;

  @override
  void initState() {
    if (CommonResponse.pullHistoryData != null) {
      if (CommonResponse.pullToothData != null) {
        int lastEarn = int.parse(CommonResponse.pullToothData!.earn);
        _maxWithdrawLimit = lastEarn;
      } else {
        int totalEarn = CommonResponse.pullHistoryData!.amount ?? 0;
        _maxWithdrawLimit = totalEarn;
      }
    } else if (CommonResponse.pullToothData != null) {
      _maxWithdrawLimit = int.parse(CommonResponse.pullToothData!.earn);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPress();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.COLOR_PRIMARY,
          body: Container(
            child: MediaQuery.of(context).size.height <= 639
                ? _scrollableMainWidget()
                : _nonScrollableMainWidget(),
          ),
        ),
      ),
    );
  }

  Widget _scrollableMainWidget() {
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

  Widget _nonScrollableMainWidget() {
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

  Widget _appIcon() {
    return Image.asset(
      'assets/icons/ic_fairy.png',
      height: 200,
      width: 200,
    );
  }

  Widget _congratulationWidget() {
    return Container(
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
          _titleWidget(),
          _descriptionTextWidget(),
          _balanceWidget(),
          _withdrawBalanceWidget(),
          _withdrawBalanceBtn(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text(
        'Cash out',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _descriptionTextWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 30),
      child: Text(
        "How much do you want to cash out?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _balanceWidget() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.COLOR_LIGHT_GREY,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _balanceText(),
          _balanceCountText(),
        ],
      ),
    );
  }

  Widget _balanceText() {
    return Text(
      'BALANCE',
      style: TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _balanceCountText() {
    return AutoSizeText(
      '${CommonResponse.budget?.symbol ?? '\$'}$_maxWithdrawLimit',
      minFontSize: 28,
      maxFontSize: 32,
      style: TextStyle(
          fontFamily: 'Avenir',
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _withdrawBalanceWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _withdrawBalanceText(),
              _withdrawBalanceCountWidget(),
            ],
          ),
          _withdrawBalanceSliderWidget(),
        ],
      ),
    );
  }

  Widget _withdrawBalanceText() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Text(
        'WITHDRAW',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _withdrawBalanceCountWidget() {
    return Container(
      height: 40,
      width: 120,
      margin: EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
        color: AppColors.COLOR_LIGHT_GREY,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          '${CommonResponse.budget?.symbol ?? '\$'}${_withdrawBalanceCount.toInt()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _withdrawBalanceSliderWidget() {
    return Container(
      height: 30,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 10,
          activeTrackColor: AppColors.COLOR_LIGHT_YELLOW,
          inactiveTrackColor: AppColors.COLOR_LIGHT_GREY,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: 15,
          ),
          thumbColor: AppColors.COLOR_PRIMARY,
        ),
        child: Slider(
          min: 1,
          max: _maxWithdrawLimit.toDouble(),
          value: _withdrawBalanceCount,
          onChanged: (value) {
            setState(() {
              _withdrawBalanceCount = value;
            });
          },
        ),
      ),
    );
  }

  Widget _withdrawBalanceBtn() {
    return InkWell(
      onTap: () => !_isLoading ? _withdrawCash() : null,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                  'Withdraw Cash',
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

  void _onBackPress() {
    if (!CommonResponse.isFromChildSummary) {
      NavigationService.instance.navigateToReplacementNamed(
          Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);
    } else {
      NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
    }
  }

  void _withdrawCash() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    String childId = CommonResponse.childId.toString();
    String amount = _withdrawBalanceCount.toInt().toString();
    String pullId;
    if (CommonResponse.isFromChildSummary) {
      pullId = '0';
    } else {
      pullId = CommonResponse.pullToothData!.id.toString();
    }

    Response response =
        await _apiService.cashOutApiCall(authToken, childId, pullId, amount);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() {
        _isLoading = false;
      });

      if (CommonResponse.isFromChildSummary) {
        CommonResponse.isFromChildSummary = false;
        NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
      } else {
        NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
