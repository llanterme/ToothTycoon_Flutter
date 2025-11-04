import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/add_helper.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class AnalysingScreen extends StatefulWidget {
  @override
  _AnalysingScreenState createState() => _AnalysingScreenState();
}

class _AnalysingScreenState extends State<AnalysingScreen> {
  bool _isToothBtnEnable = false;

  double _progress = 0;

  String analysingStatus = 'Analysing';

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    _loadInterstitialAd();
    _startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(CommonResponse.capturedImagePath),
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.COLOR_PRIMARY.withValues(alpha: 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _appBar(),
                  _analysingWidget(),
                  Spacer(),
                  _toothBtn(),
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

  Widget _analysingWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _animationWidget(),
          _analysingTextWidget(),
          _linearProgressWidget(),
        ],
      ),
    );
  }

  Widget _animationWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width * 0.70,
      child: Image.asset('assets/icons/ic_analyzing.gif'),
    );
  }

  Widget _analysingTextWidget() {
    return Container(
      child: Text(
        analysingStatus,
        style: TextStyle(
          fontSize: 33,
          color: Colors.white,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _linearProgressWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 8,
      margin: EdgeInsets.only(top: 20, left: 60, right: 60),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        child: LinearProgressIndicator(
          backgroundColor: AppColors.COLOR_PRIMARY,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.COLOR_LIGHT_YELLOW),
          value: _progress,
        ),
      ),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              NavigationService.instance
                  .navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Widget _toothBtn() {
    return Opacity(
      opacity: !_isToothBtnEnable ? 0.7 : 1.0,
      child: InkWell(
        onTap: () {
          if (_isToothBtnEnable && _isInterstitialAdReady) {
            _interstitialAd?.show();
          } else {
            NavigationService.instance
                .navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);
          }
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 25, left: 30, right: 30),
          decoration: BoxDecoration(
            color: AppColors.COLOR_LIGHT_YELLOW,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Center(
            child: Text(
              'How much is your tooth worth?',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    new Timer.periodic(
      Duration(seconds: 2),
      (Timer timer) => setState(
        () {
          if (_progress == 1) {
            timer.cancel();
            setState(() {
              _isToothBtnEnable = true;
              analysingStatus = 'Done';
            });
          } else {
            _progress += 0.5;
          }
        },
      ),
    );
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
