import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:tooth_tycoon/bottomsheet/loginBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/resetPasswordBottomSheet.dart';
import 'package:tooth_tycoon/bottomsheet/signupBottomSheet.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/helper/add_helper.dart';

import 'package:tooth_tycoon/widgets/videoPlayerWidget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _pageController = PageController(initialPage: 0);

  final currentPage = ValueNotifier<int>(0);

  String _welcomeAnimationPath = 'assets/videos/welcome_animation.mp4';

  double ratio = 832 / 726;

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();

    super.dispose();
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
              print("add dissmess");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_PRIMARY,
      body: FutureBuilder<void>(
          future: _initGoogleMobileAds(),
          builder: (context, snapshot) {
            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _appIconWidget(),
                    _slider(),
                    _pageIndicator(),
                    _signupBtn(),
                    _loginBtn(),
                    const SizedBox(height: 20),
                    if (_isBannerAdReady)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: _bannerAd.size.width.toDouble(),
                          height: _bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        ),
                      ),
                    ButtonTheme(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        minWidth: 300.0,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.amber)),
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            'PURCHASE ACCESS',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_isInterstitialAdReady) _interstitialAd?.show();
                          },
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _appIconWidget() {
    return VideoPlayerWidget(
      height: MediaQuery.of(context).size.height * 0.30,
      width: (MediaQuery.of(context).size.height * 0.30) * ratio,
      videoPath: _welcomeAnimationPath,
    );
  }

  Widget _welcomeText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Welcome to\nTooth Tycoon',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 33,
            color: Colors.white,
            fontFamily: 'Avenir',
          ),
        ),
      ),
    );
  }

  Widget _slider() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      margin: EdgeInsets.only(top: 25),
      child: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          currentPage.value = index;
        },
        children: <Widget>[
          _slider1Text(),
          _slider2Text(),
          _slider3Text(),
          _slider4Text(),
        ],
      ),
    );
  }

  Widget _slider1Text() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _welcomeText(),
            SizedBox(
              height: 10,
            ),
            Text(
              'What is the going rate for a tooth?\nYou decide!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider2Text() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _welcomeText(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your kids will learn to build their own\nempire from an early age to eventually\nbecome a Tooth Tycoon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider3Text() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _welcomeText(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Share these milestone and newly acquired\nmoney smarts with friends and family',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider4Text() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _welcomeText(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Use tooth money to teach your children\nabout the magic of compound interest',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: CirclePageIndicator(
        itemCount: 4,
        currentPageNotifier: currentPage,
        dotColor: AppColors.COLOR_DISABLE_INDICATOR.withOpacity(0.5),
        selectedDotColor: AppColors.COLOR_ENABLE_INDICATOR,
        selectedSize: 10,
        size: 10,
      ),
    );
  }

  Widget _signupBtn() {
    return SingleChildScrollView(
      child: InkWell(
        onTap: () => _openSignupBottomSheet(),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 30, right: 30, top: 60),
          decoration: BoxDecoration(
            color: AppColors.COLOR_BTN_BLUE,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Avenir',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return InkWell(
      onTap: () => _openLoginBottomSheet(),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.COLOR_TEXT_PRIMARY,
              fontFamily: 'Avenir',
            ),
          ),
        ),
      ),
    );
  }

  void _openSignupBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SignupBottomSheet(
          loginFunction: _openLoginBottomSheet,
        ),
      ),
    );
  }

  void _openLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LoginBottomSheet(
          signupFunction: _openSignupBottomSheet,
          resetPasswordFunction: _openResetPasswordBottomSheet,
          loginFunction: _openSignupBottomSheet,
        ),
      ),
    );
  }

  void _openResetPasswordBottomSheet(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ResetPasswordBottomSheet(
          email: email,
          loginFunction: _openLoginBottomSheet,
        ),
      ),
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
