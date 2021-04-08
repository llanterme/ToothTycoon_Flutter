import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/widgets/videoPlayerWidget.dart';

class ReceiveBadgeScreen extends StatefulWidget {
  @override
  _ReceiveBadgeScreenState createState() => _ReceiveBadgeScreenState();
}

class _ReceiveBadgeScreenState extends State<ReceiveBadgeScreen> {
  double _ratio = 600 / 500;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.COLOR_PRIMARY,
          body: Container(
            child: MediaQuery.maybeOf(context).size.height <= 639
                ? _scrollableWidget()
                : _nonScrollableMainWidget(),
          ),
        ),
      ),
    );
  }

  Widget _scrollableWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _appBar(),
          _appIcon(),
          _congratulationWidget(),
        ],
      ),
    );
  }

  Widget _nonScrollableMainWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _appBar(),
        _appIcon(),
        _congratulationWidget(),
      ],
    );
  }

  Widget _appBar() {
    return Container(
      width: MediaQuery.maybeOf(context).size.width,
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
    return Image.asset(
      'assets/icons/ic_fairy.png',
      height: 200,
      width: 200,
    );
  }

  Widget _congratulationWidget() {
    return Container(
      width: MediaQuery.maybeOf(context).size.width,
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
          _descriptionTextWidget(),
          _animationWidget(),
          _keepLoginTextWidget(),
          _homeBtn(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(
        'Woohoo!',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _descriptionTextWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        "You just earned the\nMr Money Bags Badge!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /*Widget _videoWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: VideoPlayerWidget(
        height: MediaQuery.maybeOf(context).size.height * 0.40,
        width: (MediaQuery.maybeOf(context).size.height * 0.40) * _ratio,
        videoPath: 'assets/videos/badge_video_sound.mp4',
        isVideoLooping: true,
      ),
    );
  }*/

  Widget _animationWidget() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height * 0.30,
      width: MediaQuery.maybeOf(context).size.height * 0.30,
      child: Center(
        child: Image.asset(
          'assets/icons/ic_badges_list.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _keepLoginTextWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 20),
      child: Text(
        "Keep logging for special badges",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
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
        width: MediaQuery.maybeOf(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
