import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIService _apiService = APIService();

  bool _isLoading = true;

  @override
  void initState() {
    _getCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Device Height : ${MediaQuery.maybeOf(context).size.height}');
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        backgroundColor: AppColors.COLOR_PRIMARY,
        body: SafeArea(
          child: _isLoading
              ? _loadingPage()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _welcomeText(),
                      _screenDescription(),
                      SizedBox(
                        height: 10,
                      ),
                      _setBudgetCard(),
                      SizedBox(
                        height: 10,
                      ),
                      _addChildCard(),
                      SizedBox(
                        height: 10,
                      ),
                      _viewChildrenCard(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _welcomeText() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/ic_welcome.png',
            height: 80,
            width: 150,
          ),
          PopupMenuButton(
            icon: Image.asset(
              'assets/icons/ic_menu3line.png',
              height: 32,
              width: 32,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Avenir',
                  ),
                ),
              ),
            ],
            onSelected: (int value) {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _screenDescription() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Text(
        "Let's get started",
        style:
            TextStyle(fontSize: 33, color: Colors.white, fontFamily: 'Avenir'),
      ),
    );
  }

  Widget _setBudgetCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 15,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.only(top: 0),
            child: InkWell(
              onTap: () async {
                _openSetBudgetBottomSheet();

                // final ByteData bytes1 =
                //     await rootBundle.load('assets/images/img_child_1.png');
                //
                // await Share.files(
                //     'tooth app image',
                //     {
                //       'toothapp.png': bytes1.buffer.asUint8List(),
                //     },
                //     '*/*',
                //     text: 'Tooth Tycoon\nhttps://google.co.in');
              },
              child: Container(
                width: MediaQuery.maybeOf(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _setBudgetIcon(),
                          _setBudgetText(),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.maybeOf(context).size.height * 0.02,
                      width: MediaQuery.maybeOf(context).size.width,
                      decoration: BoxDecoration(
                          color: AppColors.COLOR_LIGHT_YELLOW,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _setBudgetIcon() {
    return Container(
      child: Image.asset(
        'assets/icons/ic_set_budget.png',
        height: MediaQuery.maybeOf(context).size.width * 0.25,
        width: MediaQuery.maybeOf(context).size.width * 0.25,
      ),
    );
  }

  Widget _setBudgetText() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height * 0.10,
      margin: EdgeInsets.only(left: 20),
      width: MediaQuery.maybeOf(context).size.width * 0.50,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SET YOUR BUDGET',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                fontFamily: 'Avenir'),
          ),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              "Let's decide how much a tooth is worth.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.normal,
                fontFamily: 'Avenir',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addChildCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        margin: EdgeInsets.only(top: 13),
        elevation: 5,
        child: InkWell(
          onTap: () => _openAddChildBottomSheet(),
          child: Container(
            width: MediaQuery.maybeOf(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _addChildIcon(),
                      _addChildText(),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.maybeOf(context).size.height * 0.02,
                  width: MediaQuery.maybeOf(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.COLOR_LIGHT_GREEN,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addChildIcon() {
    return Container(
      child: Image.asset(
        'assets/icons/ic_add_child.png',
        height: MediaQuery.maybeOf(context).size.width * 0.25,
        width: MediaQuery.maybeOf(context).size.width * 0.25,
      ),
    );
  }

  Widget _addChildText() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height * 0.10,
      width: MediaQuery.maybeOf(context).size.width * 0.50,
      margin: EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADD A CHILD',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir'),
          ),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              "Who's the lucky kid? Add them here.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Avenir',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _viewChildrenCard() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Card(
        margin: EdgeInsets.only(top: 13),
        elevation: 5,
        child: InkWell(
          onTap: () {
            if (CommonResponse.budget != null) {
              NavigationService.instance
                  .navigateToReplacementNamed(Constants.KEY_ROUTE_VIEW_CHILD);
            } else {
              Utils.showToast(
                  message: 'Please set budget', durationInSecond: 3);
            }
          },
          child: Container(
            width: MediaQuery.maybeOf(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _viewChildrenIcon(),
                      _viewChildrenText(),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.maybeOf(context).size.height * 0.02,
                  width: MediaQuery.maybeOf(context).size.width,
                  decoration: BoxDecoration(
                      color: AppColors.COLOR_LIGHT_BLUE,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewChildrenIcon() {
    return Container(
      child: Image.asset(
        'assets/icons/ic_view_children.png',
        height: MediaQuery.maybeOf(context).size.width * 0.25,
        width: MediaQuery.maybeOf(context).size.width * 0.25,
      ),
    );
  }

  Widget _viewChildrenText() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height * 0.10,
      width: MediaQuery.maybeOf(context).size.width * 0.50,
      margin: EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VIEW YOUR CHILDREN',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir'),
          ),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              "Track each child's progress and tooth money empire",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Avenir',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _loadingPage() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height,
      width: MediaQuery.maybeOf(context).size.width,
      color: AppColors.COLOR_PRIMARY,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  void _openSetBudgetBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.maybeOf(context).viewInsets.bottom),
        child: SetBudgetBottomSheet(),
      ),
    );
  }

  void _openAddChildBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.maybeOf(context).viewInsets.bottom),
        child: AddChildBottomSheet(),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    exit(0);
    return true;
  }

  void _logout() async {
    await PreferenceHelper().setLoginResponse(null);
    await PreferenceHelper().setIsUserLogin(false);
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
  }

  void _getCurrency() async {
    String authToken = await PreferenceHelper().getAccessToken();

    Response response = await _apiService.getCurrencyApiCall(authToken);
    var responseData = json.decode(response.body);
    int statusCode = responseData[Constants.KEY_STATUS_CODE];
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      CurrencyResponse currencyResponse =
          CurrencyResponse.fromJson(responseData);
      CommonResponse.currencyResponse = currencyResponse;

      String selCurrencyId = await PreferenceHelper().getCurrencyId();
      String amount = await PreferenceHelper().getCurrencyAmount();

      if (selCurrencyId != null && selCurrencyId.isNotEmpty) {
        for (CurrencyData currencyData in currencyResponse.data) {
          if (currencyData.id.toString() == selCurrencyId) {
            Budget budget = Budget();
            budget.currencyId = currencyData.id.toString();
            budget.amount = amount;
            budget.code = currencyData.code;
            budget.symbol = currencyData.symbol;
            break;
          }
        }
      }

      String responseStr = await PreferenceHelper().getLoginResponse();
      if (responseStr != null && responseStr.isNotEmpty) {
        var responseData = json.decode(responseStr);
        LoginResponse loginResponse = LoginResponse.fromJson(responseData);
        CommonResponse.budget = loginResponse.data.budget;
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
