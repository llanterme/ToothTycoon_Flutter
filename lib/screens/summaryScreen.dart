import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/screens/receiveBadgeScreen.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  APIService _apiService = APIService();

  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isDataAvail = true;

  int _collectedTooth = 0;

  int _totalAmount = 0;

  @override
  void initState() {
    _getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _loadingPage()
        : !_isDataAvail
            ? _noDataWidget()
            : Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  thickness: 6,
                  radius: Radius.circular(5),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _child1(),
                        _child2(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        _collectToothBtn(),
                        _keepMouthHealthyBtn(),
                        _cashOutBtn(),
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget _child1() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          leading: Image.asset(
            'assets/icons/ic_set_budget.png',
            height: 48,
            width: 48,
          ),
          title: Text(
            'Tooth collected',
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Avenir',
            ),
          ),
          trailing: Container(
            height: 48,
            width: 48,
            child: Center(
              child: Text(
                '$_collectedTooth',
                style: TextStyle(fontSize: 28, fontFamily: 'Avenir'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _child2() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          leading: Image.asset(
            'assets/icons/ic_set_budget.png',
            height: 48,
            width: 48,
          ),
          title: Text(
            'Tooth wallet',
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Avenir',
            ),
          ),
          trailing: Container(
            height: 48,
            width: 100,
            child: Center(
              child: Text(
                '${CommonResponse.budget.symbol}$_totalAmount',
                style: TextStyle(fontSize: 28, fontFamily: 'Avenir'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _collectToothBtn() {
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_PULL_TOOTH),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.COLOR_LIGHT_YELLOW,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Collect tooth',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Widget _keepMouthHealthyBtn() {
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_QUESTION_AND_ANSWER),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Keep my mouth healthy',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.COLOR_TEXT_BLACK,
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
        if (CommonResponse.pullHistoryData.amount > 0) {
          CommonResponse.isFromChildSummary = true;
          NavigationService.instance
              .navigateToReplacementNamed(Constants.KEY_ROUTE_CASH_OUT_SCREEN);
        } else {
          Utils.showToast(
              message: 'Not enough wallet balance', durationInSecond: 3);
        }
        /*Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ReceiveBadgeScreen(),
          ),
        );*/
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              fontSize: 14,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  Widget _noDataWidget() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _noDataIcon(),
            _noDataText(),
            Spacer(),
            _collectToothBtn(),
            _keepMouthHealthyBtn(),
          ],
        ),
      ),
    );
  }

  Widget _noDataIcon() {
    return Image.asset(
      'assets/icons/ic_no_data.png',
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width * 0.70,
    );
  }

  Widget _noDataText() {
    return Text(
      'No teeth collected yet',
      style: TextStyle(
        fontSize: 19,
        color: Colors.white,
        fontFamily: 'Avenir',
      ),
    );
  }

  Widget _loadingPage() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.COLOR_PRIMARY,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  void _getHistory() async {
    String token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    Response response = await _apiService.pullHistoryApiCall(
        authToken, CommonResponse.childId.toString());
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      var dataList = responseData[Constants.KEY_DATA];

      if (dataList != null && dataList.isNotEmpty) {
        PullHistoryResponse pullHistoryResponse =
            PullHistoryResponse.fromJson(responseData);

        CommonResponse.pullHistoryData = pullHistoryResponse.data;
        CommonResponse.pullToothData = null;

        int toothCount = 0;

        if (pullHistoryResponse.data.teethList != null &&
            pullHistoryResponse.data.teethList.isNotEmpty) {
          toothCount = pullHistoryResponse.data.teethList.length;
        }

        setState(() {
          _collectedTooth = toothCount;
          _totalAmount = pullHistoryResponse.data.amount;
          _isLoading = false;
        });
      } else {
        CommonResponse.pullHistoryData = null;
        setState(() {
          _isLoading = false;
          _isDataAvail = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
