import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/bottomsheet/addChildBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/setBudgetBottomSheet.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/childListResponse.dart';
import 'package:tooth_tycoon/screens/badgesScreen.dart';
import 'package:tooth_tycoon/screens/historyScreen.dart';
import 'package:tooth_tycoon/screens/summaryScreen.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class ChildDetail extends StatefulWidget {
  @override
  _ChildDetailState createState() => _ChildDetailState();
}

class _ChildDetailState extends State<ChildDetail> {
  static const KEY_SUMMARY_SCREEN = 'SUMMARY_SCREEN';
  static const KEY_HISTORY_SCREEN = 'HISTORY_SCREEN';
  static const KEY_BADGE_SCREEN = 'BADGE_SCREEN';

  bool _isLoading = false;

  String _selScreenTag = KEY_SUMMARY_SCREEN;
  String _childName = '';
  String _childAge = '';

  @override
  void initState() {
    _childName = CommonResponse.childData.name;
    _childAge = CommonResponse.childData.age.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        backgroundColor: AppColors.COLOR_PRIMARY,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(),
                _userInfoWidget(),
                _tabBar(),
                _getSelScreen(_selScreenTag),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconBack(),
          _iconMenu(),
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

  Widget _iconMenu() {
    return Container(
      child: PopupMenuButton(
        icon: Image.asset(
          'assets/icons/ic_menu3dot.png',
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
    );
  }

  Widget _userInfoWidget() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleText(),
              _subTitleText(),
            ],
          ),
          _userProfileImage(),
        ],
      ),
    );
  }

  Widget _titleText() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 5),
      child: Text(
        _childName,
        style: TextStyle(
          fontSize: 33,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _subTitleText() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 5),
      child: Text(
        '$_childAge year old',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _userProfileImage() {
    return Visibility(
      visible: _selScreenTag == KEY_HISTORY_SCREEN,
      child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.COLOR_LIGHT_YELLOW,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 24,
          backgroundImage: CommonResponse.childData.img.endsWith("default.jpg")
              ? AssetImage("assets/images/default.jpeg")
              : NetworkImage(CommonResponse.childData.img),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _selScreenTag = KEY_SUMMARY_SCREEN;
              });
            },
            child: _tabBtn('Summary', KEY_SUMMARY_SCREEN),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selScreenTag = KEY_HISTORY_SCREEN;
              });
            },
            child: _tabBtn('History', KEY_HISTORY_SCREEN),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selScreenTag = KEY_BADGE_SCREEN;
              });
            },
            child: _tabBtn('Badges', KEY_BADGE_SCREEN),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String title, String screenTag) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        color: _selScreenTag == screenTag
            ? AppColors.COLOR_LIGHT_YELLOW
            : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Avenir',
            color: _selScreenTag == screenTag ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getSelScreen(String screenTag) {
    switch (screenTag) {
      case KEY_SUMMARY_SCREEN:
        return SummaryScreen();
      case KEY_HISTORY_SCREEN:
        return HistoryScreen();
      case KEY_BADGE_SCREEN:
        return BadgesScreen();
    }
  }

  Future<bool> _onBackPress() async {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_VIEW_CHILD);

    return true;
  }

  void _logout() async {
    await PreferenceHelper().setLoginResponse(null);
    await PreferenceHelper().setIsUserLogin(false);
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
  }
}
