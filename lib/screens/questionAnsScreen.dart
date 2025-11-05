import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/submitQuestionResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class QuestionAnsScreen extends StatefulWidget {
  @override
  _QuestionAnsScreenState createState() => _QuestionAnsScreenState();
}

class _QuestionAnsScreenState extends State<QuestionAnsScreen> {
  APIService _apiService = APIService();

  static const String ANS_YES = 'YES';
  static const String ANS_NO = 'NO';

  bool _isFirstQuestion = true;
  bool _isAllAnsSubmitted = false;
  bool _isLoading = false;

  String _userName = '';
  String _firstQueAns = ANS_YES;
  String _secondQueAns = ANS_YES;
  String _selectedAns = ANS_YES;

  @override
  void initState() {
    _userName = CommonResponse.childName;
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
          body: _isLoading
              ? _loadingPage()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _appBar(),
                      _appIcon(),
                      _questionWidget(),
                    ],
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

  Widget _appIcon() {
    return Expanded(
      child: Image.asset(
        'assets/icons/ic_fairy.png',
        height: 185,
        width: 185,
      ),
    );
  }

  Widget _questionWidget() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userNameWidget(),
          _isFirstQuestion ? _questionFirstWidget() : _questionSecondWidget(),
          _ansYesWidget(),
          _ansNoWidget(),
          _nextBtn(),
        ],
      ),
    );
  }

  Widget _userNameWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        'Hello $_userName',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _questionFirstWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'Did you brush your teeth today?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _questionSecondWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'Did you floss your teeth today?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _ansYesWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAns = ANS_YES;
          if (_isFirstQuestion) {
            _firstQueAns = ANS_YES;
          } else {
            _secondQueAns = ANS_YES;
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        decoration: BoxDecoration(
          color: _selectedAns == ANS_YES
              ? AppColors.COLOR_LIGHT_YELLOW
              : AppColors.COLOR_LIGHT_GREY,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                'YES',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.COLOR_TEXT_BLACK,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Visibility(
                visible: _selectedAns == ANS_YES,
                child: _selAnsWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ansNoWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAns = ANS_NO;
          if (_isFirstQuestion) {
            _firstQueAns = ANS_NO;
          } else {
            _secondQueAns = ANS_NO;
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        decoration: BoxDecoration(
          color: _selectedAns == ANS_NO
              ? AppColors.COLOR_LIGHT_YELLOW
              : AppColors.COLOR_LIGHT_GREY,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                'NO',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.COLOR_TEXT_BLACK,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Visibility(
                visible: _selectedAns == ANS_NO,
                child: _selAnsWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _selAnsWidget() {
    return Container(
      height: 25,
      width: 25,
      margin: EdgeInsets.only(left: 50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.COLOR_PRIMARY,
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/ic_right.png',
          height: 18,
          width: 18,
        ),
      ),
    );
  }

  Widget _nextBtn() {
    return InkWell(
      onTap: () {
        if (_isFirstQuestion) {
          setState(
            () {
              _selectedAns = ANS_YES;
              _isFirstQuestion = false;
            },
          );
        } else {
          print('First Question Ans : $_firstQueAns');
          print('Second Question Ans : $_secondQueAns');
          _submitAns();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.COLOR_PRIMARY,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Next',
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

  Widget _loadingPage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.COLOR_PRIMARY,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  void _onBackPress() {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);

     }

  void _submitAns() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    String childId = CommonResponse.childId.toString();
    String firstQueAns = _firstQueAns == ANS_YES ? '1' : '0';
    String secondQueAns = _secondQueAns == ANS_YES ? '1' : '0';

    Response response = await _apiService.submitAns(
        firstQueAns, secondQueAns, authToken, childId);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      SubmitQuestionResponse submitQuestionResponse =
          SubmitQuestionResponse.fromJson(responseData);
      setState(() {
        _isLoading = false;
      });

      if (submitQuestionResponse.data?.count == 15) {
        NavigationService.instance.navigateToReplacementNamed(
            Constants.KEY_ROUTE_RECEIVE_BADGE_SCREEN);
      } else {
        CommonResponse.submitQuestionData = submitQuestionResponse.data;
        NavigationService.instance.navigateToReplacementNamed(
            Constants.KEY_ROUTE_CONGRATULATION_SCREEN);
      }
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
