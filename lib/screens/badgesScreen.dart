import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/widgets/videoPlayerWidget.dart';

class BadgesScreen extends StatefulWidget {
  @override
  _BadgesScreenState createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  List<Badges> _badgesList;

  bool _isDataAvail = true;

  @override
  void initState() {
    if (CommonResponse.pullHistoryData != null) {
      if (CommonResponse.pullHistoryData.badges != null &&
          CommonResponse.pullHistoryData.badges.isNotEmpty) {
        _badgesList = CommonResponse.pullHistoryData.badges;
      }
    } else {
      _isDataAvail = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_isDataAvail
        ? _noDataWidget()
        : Expanded(
            child: _badgeList(),
          );
  }

  Widget _badgeList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
        childAspectRatio: (((MediaQuery.of(context).size.width) / 2) / 410),
        primary: false,
        children: List.generate(
          _badgesList != null && _badgesList.isNotEmpty
              ? _badgesList.length
              : 0,
          (index) {
            return _badgeCell(_badgesList[index]);
          },
        ),
      ),
    );
  }

  Widget _badgeCell(Badges badges) {
    return Container(
      child: Column(
        children: [
          _badgeImage(),
          _badgeNameAndDescription(badges),
        ],
      ),
    );
  }

  Widget _badgeImage() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Image.asset(
        'assets/icons/ic_badges_list.gif',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _badgeNameAndDescription(Badges badges) {
    return Container(
      height: 95,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _badgeName(badges.name),
          SizedBox(
            height: 5,
          ),
          _badgeDescription(badges.description),
        ],
      ),
    );
  }

  Widget _badgeName(String name) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontFamily: 'Avenir',
      ),
    );
  }

  Widget _badgeDescription(String description) {
    return Text(
      description,
      textAlign: TextAlign.center,
      softWrap: true,
      maxLines: 2,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontFamily: 'Avenir',
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
      'No badges found',
      style: TextStyle(
        fontSize: 19,
        color: Colors.white,
        fontFamily: 'Avenir',
      ),
    );
  }
}
