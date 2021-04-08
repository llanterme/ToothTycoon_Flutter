import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/investResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class InvestScreen extends StatefulWidget {
  @override
  _InvestScreenState createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  APIService _apiService = APIService();

  bool _isLoading = false;

  double _yearCount = 1;
  double _interestCount = 1;
  double _totalAmount = 0;

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _calculateTotalInterest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.maybeOf(context).size.height,
            width: MediaQuery.maybeOf(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(CommonResponse.capturedImagePath),
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              height: MediaQuery.maybeOf(context).size.height,
              width: MediaQuery.maybeOf(context).size.width,
              color: AppColors.COLOR_PRIMARY.withOpacity(0.7),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _appBar(),
                    _appIcon(),
                    _congratulationWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
      width: MediaQuery.maybeOf(context).size.width,
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
          _yearWidget(),
          _interestRateWidget(),
          _futureValueWidget(),
          _investBtn(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15),
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

  Widget _descriptionTextWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 15),
      child: Text(
        "How do you want to invest your\ntooth money?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _yearWidget() {
    return Container(
      width: MediaQuery.maybeOf(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _yearText(),
              _yearCountWidget(),
            ],
          ),
          _yearSliderWidget(),
        ],
      ),
    );
  }

  Widget _yearText() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Text(
        'YEARS',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _yearCountWidget() {
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
          '${_yearCount.toInt()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _yearSliderWidget() {
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
          max: 10,
          value: _yearCount,
          onChanged: (value) {
            setState(() {
              print('Year Slider Count : ${value.toInt().toDouble()}');
              _yearCount = value.toInt().toDouble();
              CommonResponse.investedYear = _yearCount.toInt().toString();
            });
            _calculateTotalInterest();
          },
        ),
      ),
    );
  }

  Widget _interestRateWidget() {
    return Container(
      width: MediaQuery.maybeOf(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _interestRateText(),
              _interestCountWidget(),
            ],
          ),
          _interestSliderWidget(),
        ],
      ),
    );
  }

  Widget _interestRateText() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Text(
        'INTEREST RATE',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _interestCountWidget() {
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
          '${_interestCount.toInt()}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _interestSliderWidget() {
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
          max: 10,
          value: _interestCount,
          onChanged: (value) {
            print('Interest Rate Counter : ${value.toInt().toDouble()}');
            setState(() {
              _interestCount = value.toInt().toDouble();
            });
            _calculateTotalInterest();
          },
        ),
      ),
    );
  }

  Widget _futureValueWidget() {
    return Container(
      height: 70,
      width: MediaQuery.maybeOf(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
          _futureValueText(),
          _futureValueCountText(),
        ],
      ),
    );
  }

  Widget _futureValueText() {
    return Text(
      'FUTURE VALUE',
      style: TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _futureValueCountText() {
    return AutoSizeText(
      '${CommonResponse.budget.symbol}${_totalAmount.toStringAsFixed(2)}',
      minFontSize: 28,
      maxFontSize: 32,
      style: TextStyle(
          fontFamily: 'Avenir',
          color: Colors.black,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _investBtn() {
    return InkWell(
      onTap: () => !_isLoading ? _invest() : null,
      child: Container(
        height: 50,
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          top: 5,
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
                  'Invest',
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
    CommonResponse.futureValue = '';
    CommonResponse.investedYear = '';
    NavigationService.instance.navigateToReplacementNamed(
        Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);

    return true;
  }

  void _calculateTotalInterest() {
    // Old Logic
    /*double p = double.parse(CommonResponse.pullToothData.reward);

    double r = _interestCount.toInt() / 100;

    double annualCycle = 12;

    double t = _yearCount;

    setState(() {
      _totalAmount = p + (p * r * t) / 100;
      CommonResponse.futureValue = _totalAmount.toString();
    });*/

    // New Logic (Compound Interest)

    // P = Principal Amount
    double p = double.parse(CommonResponse.pullToothData.reward);
    // R = Annual Interest Rate
    double r = (_interestCount / 100);
    // T = Time the Money is Invested or Borrowed for.
    double t = _yearCount;
    // N =  the number of times that interest is compounded per unit t, for example if interest is compounded monthly and t is in years then the value of n would be 12. If interest is compounded quarterly and t is in years then the value of n would be 4.
    double n = 1;

    double amount = p * pow(1 + (r / n), n * t);

    _totalAmount = double.parse(amount.toStringAsFixed(2));

    print('Interest Total Amount : $_totalAmount');

    CommonResponse.futureValue = _totalAmount.toStringAsFixed(2);
    CommonResponse.investedYear = _yearCount.toInt().toString();
  }

  void _invest() async {
    setState(() {
      _isLoading = true;
    });

    int year = _dateTime.year + _yearCount.toInt();
    DateTime _endDate = DateTime(year);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    String token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    String childId = CommonResponse.childId.toString();
    String pullId = CommonResponse.pullToothData.id.toString();
    String years = _yearCount.toInt().toString();
    String interestRate = _interestCount.toInt().toString();
    String endDate = dateFormat.format(_endDate);
    String amount = CommonResponse.pullToothData.earn;
    String finalAmount = _totalAmount.toString();

    Response response = await _apiService.investApiCall(authToken, childId,
        pullId, years, interestRate, endDate, amount, finalAmount);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      InvestResponse investResponse = InvestResponse.fromJson(responseData);

      setState(
        () {
          _isLoading = false;
        },
      );

      NavigationService.instance.navigateToReplacementNamed(
          Constants.KEY_ROUTE_TELL_YOUR_FRIEND_SCREEN);
    } else {
      setState(() {
        _isLoading = false;
      });

      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
