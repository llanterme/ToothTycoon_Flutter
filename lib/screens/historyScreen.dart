import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/dateTimeUtils.dart';
import 'package:tooth_tycoon/utils/utils.dart';
import 'package:video_player/video_player.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  APIService _apiService = APIService();

  VideoPlayerController _videoPlayerController;

  double ratio = 800 / 600;

  String _mouthOpenVideoPath = 'assets/videos/mouth_open_video.mp4';

  bool _isLoading = false;
  bool _isVideoVisible = true;
  bool _isClickable = true;
  bool _isDataAvail = true;

  int _currentValue = 0;

  String _toothName = '';
  String _collectedDate = '';

  List<TeethList> _teethList;

  @override
  void initState() {
    if (CommonResponse.pullHistoryData != null) {
      _currentValue = CommonResponse.pullHistoryData.amount;
      if (CommonResponse.pullHistoryData.teethList != null &&
          CommonResponse.pullHistoryData.teethList.isNotEmpty) {
        _teethList = CommonResponse.pullHistoryData.teethList;
        _initController('', '');
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _instructionText(),
                  _mouthWidget(),
                  _toothNameWidget(),
                  _collectedDateWidget(),
                  _currentValueWidget(),
                ],
              ),
            ),
          );
  }

  Widget _instructionText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Tap a tooth to view history',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _mouthWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        children: [
          _isVideoVisible
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: _videoPlayerWidget(
                      MediaQuery.of(context).size.height * 0.40,
                      (MediaQuery.of(context).size.height * 0.40) * ratio,
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.asset(
                      'assets/icons/ic_mouth_open.png',
                      height: MediaQuery.of(context).size.height * 0.40,
                      width:
                          (MediaQuery.of(context).size.height * 0.40) * ratio,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          _clickableRegionWidget(),
        ],
      ),
    );
  }

  Widget _videoPlayerWidget(double _height, double _width) {
    return Container(
      color: AppColors.COLOR_PRIMARY,
      height: _height,
      width: _width,
      child: _videoPlayerController != null
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.size != null
                  ? _videoPlayerController.value.aspectRatio
                  : 1.0,
              child: VideoPlayer(_videoPlayerController),
            )
          : Container(),
    );
  }

  Widget _clickableRegionWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.40,
          width: (MediaQuery.of(context).size.height * 0.40) * ratio,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0700,
              ),
              _topClickableRegionWidget(),
              Spacer(),
              _bottomClickableRegionWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topClickableRegionWidget() {
    return Container(
      height: 80,
      width: (MediaQuery.of(context).size.height * 0.30) * ratio,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13),
      padding: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _t1Widget(),
          _t2Widget(),
          _t3Widget(),
          _t4Widget(),
          _t5Widget(),
          _t6Widget(),
          _t7Widget(),
          _t8Widget(),
          _t9Widget(),
          _t10Widget(),
        ],
      ),
    );
  }

  Widget _t1Widget() {
    return Expanded(
      flex: 8,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t1.mp4';
            _isClickable = false;
            _initController('1', Constants.TEETH_SECOND_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 40),
        ),
      ),
    );
  }

  Widget _t2Widget() {
    return Expanded(
      flex: 7,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t2.mp4';
            _isClickable = false;
            _initController('2', Constants.TEETH_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(
            top: 10,
          ),
        ),
      ),
    );
  }

  Widget _t3Widget() {
    return Expanded(
      flex: 6,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t3.mp4';
            _isClickable = false;
            _initController('3', Constants.TEETH_CUSPID);
          }
        },
        child: Container(
          height: 35,
        ),
      ),
    );
  }

  Widget _t4Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t4.mp4';
            _isClickable = false;
            _initController('4', Constants.TEETH_LATERAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(bottom: 20),
        ),
      ),
    );
  }

  Widget _t5Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t5.mp4';
            _isClickable = false;
            _initController('5', Constants.TEETH_CENTRAL_INCISOR);
          }
        },
        child: Container(
          height: 45,
          margin: EdgeInsets.only(bottom: 20),
        ),
      ),
    );
  }

  Widget _t6Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t6.mp4';
            _isClickable = false;
            _initController('6', Constants.TEETH_CENTRAL_INCISOR);
          }
        },
        child: Container(
          height: 45,
          margin: EdgeInsets.only(bottom: 20),
        ),
      ),
    );
  }

  Widget _t7Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t7.mp4';
            _isClickable = false;
            _initController('7', Constants.TEETH_LATERAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(bottom: 20),
        ),
      ),
    );
  }

  Widget _t8Widget() {
    return Expanded(
      flex: 6,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t8.mp4';
            _isClickable = false;
            _initController('8', Constants.TEETH_CUSPID);
          }
        },
        child: Container(
          height: 35,
        ),
      ),
    );
  }

  Widget _t9Widget() {
    return Expanded(
      flex: 7,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t9.mp4';
            _isClickable = false;
            _initController('9', Constants.TEETH_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 25),
        ),
      ),
    );
  }

  Widget _t10Widget() {
    return Expanded(
      flex: 8,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t10.mp4';
            _isClickable = false;
            _initController('10', Constants.TEETH_SECOND_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(
            top: 40,
          ),
        ),
      ),
    );
  }

  Widget _bottomClickableRegionWidget() {
    return Container(
      height: 65,
      width: (MediaQuery.of(context).size.height * 0.30) * ratio,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.16),
      padding: EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _b1Widget(),
          _b2Widget(),
          _b3Widget(),
          _b4Widget(),
          _b5Widget(),
          _b6Widget(),
          _b7Widget(),
          _b8Widget(),
          _b9Widget(),
          _b10Widget(),
        ],
      ),
    );
  }

  Widget _b1Widget() {
    return Expanded(
      flex: 8,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b1.mp4';
            _isClickable = false;
            _initController('11', Constants.TEETH_SECOND_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 40),
        ),
      ),
    );
  }

  Widget _b2Widget() {
    return Expanded(
      flex: 7,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b2.mp4';
            _isClickable = false;
            _initController('12', Constants.TEETH_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }

  Widget _b3Widget() {
    return Expanded(
      flex: 6,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b3.mp4';
            _isClickable = false;
            _initController('13', Constants.TEETH_CUSPID);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _b4Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b4.mp4';
            _isClickable = false;
            _initController('14', Constants.TEETH_LATERAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(top: 20),
        ),
      ),
    );
  }

  Widget _b5Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b5.mp4';
            _isClickable = false;
            _initController('15', Constants.TEETH_CENTRAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(top: 20),
        ),
      ),
    );
  }

  Widget _b6Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b6.mp4';
            _isClickable = false;
            _initController('16', Constants.TEETH_CENTRAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(top: 20),
        ),
      ),
    );
  }

  Widget _b7Widget() {
    return Expanded(
      flex: 13,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b7.mp4';
            _isClickable = false;
            _initController('17', Constants.TEETH_LATERAL_INCISOR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(top: 20),
        ),
      ),
    );
  }

  Widget _b8Widget() {
    return Expanded(
      flex: 6,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b8.mp4';
            _isClickable = false;
            _initController('18', Constants.TEETH_CUSPID);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _b9Widget() {
    return Expanded(
      flex: 7,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b9.mp4';
            _isClickable = false;
            _initController('19', Constants.TEETH_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 15),
        ),
      ),
    );
  }

  Widget _b10Widget() {
    return Expanded(
      flex: 8,
      child: InkWell(
        onTap: () {
          if (_isClickable) {
            _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/b10.mp4';
            _isClickable = false;
            _initController('20', Constants.TEETH_SECOND_MOLAR);
          }
        },
        child: Container(
          height: 40,
          margin: EdgeInsets.only(bottom: 30),
        ),
      ),
    );
  }

  Widget _toothNameWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        bottom: 10,
      ),
      child: Text(
        _toothName,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _collectedDateWidget() {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date collected',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _collectedDate,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentValueWidget() {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current value',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${CommonResponse.budget.symbol}$_currentValue',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.COLOR_TEXT_BLACK,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
      'No history available',
      style: TextStyle(
        fontSize: 19,
        color: Colors.white,
        fontFamily: 'Avenir',
      ),
    );
  }

  _startTime() async {
    var _duration = new Duration(milliseconds: 500);
    Timer(
      _duration,
      _hideVideo,
    );
  }

  void _hideVideo() async {
    setState(() {
      //_isVideoVisible = false;
      _isClickable = true;
    });
  }

  void _initController(String teethNumber, String toothName) async {
    VideoPlayerController controller =
        VideoPlayerController.asset(_mouthOpenVideoPath);
    controller.setLooping(false);
    controller.initialize();
    controller.setVolume(0.0);

    setState(() {
      _videoPlayerController = controller;
      _videoPlayerController.play();
      _videoPlayerController.addListener(() {
        print('On Listner : ${_videoPlayerController.value.isPlaying}');

        setState(() {
          if (!_videoPlayerController.value.isPlaying) {
            _isVideoVisible = false;
            _startTime();
            _toothName = toothName;
            if (teethNumber.isNotEmpty) _getTeethHistory(teethNumber);
          } else {
            _isVideoVisible = true;
            _isClickable = false;
          }
        });
      });
    });
  }

  void _getTeethHistory(String teethNumber) async {
    String collectedDate = '';
    if (_teethList != null && _teethList.isNotEmpty) {
      for (TeethList teethData in _teethList) {
        if (teethNumber == teethData.teethNumber) {
          collectedDate = teethData.pullDate;
          break;
        }
      }

      if (collectedDate.isNotEmpty) {
        setState(() {
          _collectedDate = collectedDate;
        });
      } else {
        Utils.showToast(message: 'Data not found', durationInSecond: 3);
        setState(() {
          _collectedDate = '---';
        });
      }
    } else {
      Utils.showToast(message: 'Data not found', durationInSecond: 3);
      setState(() {
        _collectedDate = '---';
      });
    }
  }
}
