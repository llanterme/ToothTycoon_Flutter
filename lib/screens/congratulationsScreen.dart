import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CongratulationScreen extends StatefulWidget {
  @override
  _CongratulationScreenState createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  int _daysCount = 0;

  @override
  void initState() {
    _daysCount = CommonResponse.submitQuestionData.count;
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
          _daysWidget(),
          _descriptionTextWidget(),
          _homeBtn(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        'Congratulations!',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _daysWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/icons/ic_congratulations_eclips.png',
            height: MediaQuery.of(context).size.width * 0.30,
            width: MediaQuery.of(context).size.width * 0.30,
          ),
          AutoSizeText.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '$_daysCount',
                  style: TextStyle(
                    color: AppColors.COLOR_LIGHT_YELLOW,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '\n',
                ),
                TextSpan(
                  text: _daysCount == 1 ? 'DAY' : 'DAYS',
                  style: TextStyle(
                    color: AppColors.COLOR_LIGHT_YELLOW,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            minFontSize: 22,
            maxFontSize: 55,
          ),
        ],
      ),
    );
  }

  Widget _descriptionTextWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        "That's 15 days in a row\nKeep logging for social badges",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _homeBtn() {
    return InkWell(
      onTap: () {
        NavigationService.instance
            .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.COLOR_PRIMARY,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Home',
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

  Future<bool> _onBackPress() async {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);

    return true;
  }
}
