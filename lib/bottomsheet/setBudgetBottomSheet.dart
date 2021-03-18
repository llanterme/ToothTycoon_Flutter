import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class SetBudgetBottomSheet extends StatefulWidget {
  @override
  _SetBudgetBottomSheetState createState() => _SetBudgetBottomSheetState();
}

class _SetBudgetBottomSheetState extends State<SetBudgetBottomSheet> {
  APIService _apiService = APIService();

  int amountCounter = 1;

  bool _isLoading = false;

  CurrencyData _selCurrencyData;
  List<CurrencyData> _currencyList = [];

  String _selCurrency = '';

  @override
  void initState() {
    _currencyList = CommonResponse.currencyResponse.data;
    setState(() {
      if (_currencyList != null && _currencyList.isNotEmpty) {
        for (CurrencyData currencyData in _currencyList) {
          if (CommonResponse.budget != null) {
            if (int.parse(CommonResponse.budget.currencyId) ==
                currencyData.id) {
              _selCurrencyData = currencyData;
              _selCurrency = _selCurrencyData.symbol;
              amountCounter =
                  double.parse(CommonResponse.budget.amount).toInt();
            }
          } else {
            if (currencyData.code == 'USD') {
              _selCurrencyData = currencyData;
              _selCurrency = _selCurrencyData.symbol;
              break;
            }
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470,
      width: MediaQuery.of(context).size.width,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          _textTitle(),
          _descriptionText(),
          _amountIncrementDecrementWidget(),
          _currencyListWidget(),
          _doneBtn(),
          _cancelBtn(),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        'Set budget',
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: AppColors.COLOR_TEXT_BLACK,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _descriptionText() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
      ),
      child: Text(
        'How much do you want to pay\nper tooth',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }

  Widget _amountIncrementDecrementWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 30,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _iconDecrementBtn(),
          Spacer(),
          _amountText(),
          Spacer(),
          _iconIncrementBtn(),
        ],
      ),
    );
  }

  Widget _iconDecrementBtn() {
    return InkWell(
      onTap: () => _decrement(),
      child: Container(
        margin: EdgeInsets.only(left: 40),
        child: Image.asset(
          'assets/icons/ic_minus.png',
          height: 42,
          width: 42,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _amountText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '$_selCurrency$amountCounter',
        style: TextStyle(
          fontSize: amountCounter > 100 && amountCounter <= 999
              ? 40
              : amountCounter > 999
                  ? 32
                  : 49,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _iconIncrementBtn() {
    return InkWell(
      onTap: () => _increment(),
      child: Container(
        margin: EdgeInsets.only(right: 40),
        child: Image.asset(
          'assets/icons/ic_plus.png',
          height: 42,
          width: 42,
        ),
      ),
    );
  }

  Widget _currencyListWidget() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: ListView.builder(
        itemCount: _currencyList != null && _currencyList.isNotEmpty
            ? _currencyList.length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return _currencyWidget(_currencyList[index]);
        },
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _currencyWidget(CurrencyData currency) {
    return InkWell(
      onTap: () {
        setState(() {
          _selCurrencyData = currency;
          _selCurrency = _selCurrencyData.symbol;
        });
      },
      child: Container(
        height: 50,
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: _selCurrencyData.code == currency.code
                ? AppColors.COLOR_BTN_BLUE
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Center(
          child: Text(
            currency.symbol,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _doneBtn() {
    return InkWell(
      onTap: () => _validate() ? _submit() : null,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_BTN_BLUE,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: _isLoading
              ? _loader()
              : Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Avenir',
                  ),
                ),
        ),
      ),
    );
  }

  Widget _cancelBtn() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
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

  void _increment() {
    setState(() {
      if (amountCounter < 1000) {
        amountCounter++;
      }
    });
  }

  void _decrement() {
    setState(() {
      if (amountCounter != 1) {
        amountCounter--;
      }
    });
  }

  bool _validate() {
    if (amountCounter == 0) {
      Utils.showAlertDialog(context, 'Please set budget');
      return false;
    }

    return true;
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    String token = await PreferenceHelper().getAccessToken();
    String authToken = 'Bearer $token';
    String amount = amountCounter.toString();

    Response response = await _apiService.setBudgetApiCall(
        amount, authToken, _selCurrencyData.id.toString());
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() {
        _isLoading = false;
      });
      Budget budget = Budget();
      budget.currencyId = _selCurrencyData.id.toString();
      budget.code = _selCurrencyData.code;
      budget.symbol = _selCurrencyData.symbol;
      budget.amount = amount;
      CommonResponse.budget = budget;
      await PreferenceHelper().setCurrencyId(_selCurrencyData.id.toString());
      await PreferenceHelper().setCurrencyAmount(amount);

      String responseStr = await PreferenceHelper().getLoginResponse();

      if (responseStr != null && responseStr.isNotEmpty) {
        var loginResponseData = json.decode(responseStr);
        LoginResponse loginResponse = LoginResponse.fromJson(loginResponseData);
        loginResponse.data.budget = budget;
        loginResponse.status = '1';
        String loginResponseStr = json.encode(loginResponse.toJson());
        await PreferenceHelper().setLoginResponse(loginResponseStr);
      }

      Navigator.pop(context);
    } else {
      setState(() {
        _isLoading = false;
      });

      BotToast.showText(
        text: message,
        contentColor: AppColors.COLOR_PRIMARY,
        duration: Duration(seconds: 3),
      );
    }
  }
}
