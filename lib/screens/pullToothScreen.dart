import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:video_player/video_player.dart';

class PullToothScreen extends StatefulWidget {
  @override
  _PullToothScreenState createState() => _PullToothScreenState();
}

class _PullToothScreenState extends State<PullToothScreen> {
  VideoPlayerController _videoPlayerController;

  // Ratio = Width / Height
  double ratio = 800 / 600;

  String _mouthOpenVideoPath = 'assets/videos/mouth_open_video.mp4';
  String _toothName = '';
  String _teethDescription = '';

  bool _isVideoVisible = true;
  bool _isClickable = true;
  bool _isFirstMollerVideoPlaying = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _initController(null, null);
    //_startTime();
  }

  @override
  void dispose() {
    if (_videoPlayerController != null) _videoPlayerController.dispose();
    super.dispose();
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appBar(),
                  _titleText(),
                  _instructionText(),
                  _mouthWidget(),
                  _toothNameWidget(),
                  _toothDescription(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  _pullTooth(),
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

  Widget _titleText() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Text(
        'Select a tooth',
        style: TextStyle(
          fontSize: 33,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _instructionText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Tap to select a tooth',
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
                      width: (MediaQuery.of(context).size.height * 0.40) *
                          ratio,
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
      width: MediaQuery.of(context).size.width,
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
            CommonResponse.selectedTooth = '1';
            _initController(Constants.TEETH_SECOND_MOLAR,
                Constants.DESCRIPTION_SECOND_MOLAR);
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
            CommonResponse.selectedTooth = '2';
            _initController(
                Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(
            top: 15,
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
            CommonResponse.selectedTooth = '3';
            _initController(
                Constants.TEETH_CUSPID, Constants.DESCRIPTION_CUSPID);
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
            CommonResponse.selectedTooth = '4';
            _initController(Constants.TEETH_LATERAL_INCISOR,
                Constants.DESCRIPTION_LATERAL_INCISOR);
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
            CommonResponse.selectedTooth = '5';
            _initController(Constants.TEETH_CENTRAL_INCISOR,
                Constants.DESCRIPTION_CENTRAL_INCISOR);
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
            CommonResponse.selectedTooth = '6';
            _initController(Constants.TEETH_CENTRAL_INCISOR,
                Constants.DESCRIPTION_CENTRAL_INCISOR);
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
            CommonResponse.selectedTooth = '7';
            _initController(Constants.TEETH_LATERAL_INCISOR,
                Constants.DESCRIPTION_LATERAL_INCISOR);
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
            CommonResponse.selectedTooth = '8';
            _initController(
                Constants.TEETH_CUSPID, Constants.DESCRIPTION_CUSPID);
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
            CommonResponse.selectedTooth = '9';
            _initController(
                Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 15),
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
            CommonResponse.selectedTooth = '10';
            _initController(Constants.TEETH_SECOND_MOLAR,
                Constants.DESCRIPTION_SECOND_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(top: 40),
        ),
      ),
    );
  }

  Widget _bottomClickableRegionWidget() {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width,
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
            CommonResponse.selectedTooth = '11';
            _initController(Constants.TEETH_SECOND_MOLAR,
                Constants.DESCRIPTION_SECOND_MOLAR);
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
            CommonResponse.selectedTooth = '12';
            _initController(
                Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 15),
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
            CommonResponse.selectedTooth = '13';
            _initController(
                Constants.TEETH_CUSPID, Constants.DESCRIPTION_CUSPID);
          }
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 3),
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
            CommonResponse.selectedTooth = '14';
            _initController(Constants.TEETH_LATERAL_INCISOR,
                Constants.DESCRIPTION_LATERAL_INCISOR);
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
            CommonResponse.selectedTooth = '15';
            _initController(Constants.TEETH_CENTRAL_INCISOR,
                Constants.DESCRIPTION_CENTRAL_INCISOR);
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
            CommonResponse.selectedTooth = '16';
            _initController(Constants.TEETH_CENTRAL_INCISOR,
                Constants.DESCRIPTION_CENTRAL_INCISOR);
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
            CommonResponse.selectedTooth = '17';
            _initController(Constants.TEETH_LATERAL_INCISOR,
                Constants.DESCRIPTION_LATERAL_INCISOR);
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
            CommonResponse.selectedTooth = '18';
            _initController(
                Constants.TEETH_CUSPID, Constants.DESCRIPTION_CUSPID);
          }
        },
        child: Container(
          height: 35,
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
            CommonResponse.selectedTooth = '19';
            _initController(
                Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
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
            CommonResponse.selectedTooth = '20';
            _initController(Constants.TEETH_SECOND_MOLAR,
                Constants.DESCRIPTION_SECOND_MOLAR);
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _toothDescription() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Text(
        _teethDescription,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _pullTooth() {
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateToReplacementNamed(Constants.KEY_ROUTE_CAPTURE_IMAGE),
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
            'Pull Tooth',
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

  Future<bool> _onBackPress() async {
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);

    return true;
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

  void _playFirstMollerVideo() {
    _mouthOpenVideoPath = 'assets/videos/toothSelectionVideo/t9.mp4';
    _isClickable = false;
    _initController(
        Constants.TEETH_FIRST_MOLAR, Constants.DESCRIPTION_FIRST_MOLAR);
  }

  void _initController(String toothName, String teethDescription) async {
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
            if (_isInit) {
              _playFirstMollerVideo();
              _isInit = false;
            } else {
              _toothName = toothName;
              _teethDescription = teethDescription;
            }
          } else {
            _isVideoVisible = true;
            _isClickable = false;
          }
        });
      });
    });
  }
}
