import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/bottomsheet/addChildBottomSheet.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/childListResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class ViewChildScreen extends StatefulWidget {
  @override
  _ViewChildScreenState createState() => _ViewChildScreenState();
}

class _ViewChildScreenState extends State<ViewChildScreen> {
  APIService _apiService = APIService();

  bool _isLoading = false;
  bool _isDataAvail = true;

  List<ChildData> _childList;

  @override
  void initState() {
    _getChildList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        backgroundColor: AppColors.COLOR_PRIMARY,
        body: SafeArea(
          child: _isLoading
              ? _loadingPage()
              : !_isDataAvail
                  ? _noDataWidget()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _appBar(),
                            _titleText(),
                            _childListWidget(),
                            SizedBox(
                              height: 15,
                            ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconBack(),
          _iconsButtons(),
        ],
      ),
    );
  }

  Widget _iconsButtons() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _iconAddChild(),
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

  Widget _iconAddChild() {
    return InkWell(
      onTap: () => _openAddChildBottomSheet(),
      child: Container(
        child: Image.asset(
          'assets/icons/ic_add_child_small.png',
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  Widget _iconMenu() {
    return Container(
      child: Image.asset(
        'assets/icons/ic_menu3dot.png',
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _titleText() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Text(
        'View Children',
        style: TextStyle(
          fontSize: 33,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _childListWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: _childList != null && _childList.isNotEmpty ? _childList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return _childCell(_childList[index]);
          }),
    );
  }

  Widget _childCell(ChildData childData) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          onTap: () {
            CommonResponse.childId = childData.id;
            CommonResponse.childData = childData;
            CommonResponse.childName = childData.name;
            NavigationService.instance.navigateToReplacementNamed(
              Constants.KEY_ROUTE_CHILD_DETAIL,
            );
          },
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: childData.img.endsWith("default.jpg")
                ? AssetImage("assets/images/default.jpeg")
                : NetworkImage(childData.img),
          ),
          title: Text(
            childData.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Avenir',
            ),
          ),
          subtitle: Text(
            '${childData.age} year old',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.COLOR_TEXT_BLACK.withOpacity(0.5),
              fontFamily: 'Avenir',
            ),
          ),
          trailing: Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.COLOR_LIGHT_YELLOW,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                '${childData.teethCount} Teeth',
                style: TextStyle(fontSize: 14, fontFamily: 'Avenir'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noDataWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appBar(),
          _titleText(),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _noDataIcon(),
              _noDataText(),
              _addChildBtn(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noDataIcon() {
    return Image.asset(
      'assets/icons/ic_no_data.png',
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width * 0.80,
    );
  }

  Widget _noDataText() {
    return Text(
      'No children have been added yet',
      style: TextStyle(
        fontSize: 19,
        color: Colors.white,
        fontFamily: 'Avenir',
      ),
    );
  }

  Widget _addChildBtn() {
    return InkWell(
      onTap: () => _openAddChildBottomSheet(),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          top: 100,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_LIGHT_YELLOW,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Add Child',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
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

  Future<bool> _onBackPress() async {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);

    return true;
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddChildBottomSheet(
          refreshPage: _getChildList,
        ),
      ),
    );
  }

  void _getChildList() async {
    setState(() {
      _isLoading = true;
    });

    String token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';

    Response response = await _apiService.childListApiCall(authToken);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      var dataList = responseData[Constants.KEY_DATA];

      if (dataList != null && dataList.isNotEmpty) {
        ChildListResponse childListResponse = ChildListResponse.fromJson(responseData);
        setState(() {
          _childList = childListResponse.data;
          if (_childList != null && _childList.isNotEmpty) {
            _isDataAvail = true;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isDataAvail = false;
        });
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
