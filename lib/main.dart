import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/screens/analysingScreen.dart';
import 'package:tooth_tycoon/screens/cashOutScreen.dart';
import 'package:tooth_tycoon/screens/congratulationsAfterToothPullScreen.dart';
import 'package:tooth_tycoon/screens/deviceNotSupportedScreen.dart';
import 'package:tooth_tycoon/screens/investScreen.dart';
import 'package:tooth_tycoon/screens/questionAnsScreen.dart';
import 'package:tooth_tycoon/screens/captureImageScreen.dart';
import 'package:tooth_tycoon/screens/childDetail.dart';
import 'package:tooth_tycoon/screens/congratulationsScreen.dart';
import 'package:tooth_tycoon/screens/homeScreen.dart';
import 'package:tooth_tycoon/screens/pullToothScreen.dart';
import 'package:tooth_tycoon/screens/receiveBadgeScreen.dart';
import 'package:tooth_tycoon/screens/shareImageScreen.dart';
import 'package:tooth_tycoon/screens/splashScreen.dart';
import 'package:tooth_tycoon/screens/tellYourFriendScreen.dart';
import 'package:tooth_tycoon/screens/viewChildren.dart';
import 'package:tooth_tycoon/screens/welcomeScreen.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(
        statusBarColor: AppColors.COLOR_PRIMARY.withValues(alpha: 1));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tooth Tycoon',
      builder: BotToastInit(),
      navigatorKey: NavigationService.instance.navigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: Constants.KEY_ROUTE_SPLASH,
      routes: {
        Constants.KEY_ROUTE_SPLASH: (BuildContext context) => SplashScreen(),
        Constants.KEY_ROUTE_WELCOME: (BuildContext context) => WelcomeScreen(),
        Constants.KEY_ROUTE_HOME: (BuildContext context) => HomeScreen(),
        Constants.KEY_ROUTE_VIEW_CHILD: (BuildContext context) =>
            ViewChildScreen(),
        Constants.KEY_ROUTE_CHILD_DETAIL: (BuildContext context) =>
            ChildDetail(),
        Constants.KEY_ROUTE_CAPTURE_IMAGE: (BuildContext context) =>
            CaptureImageScreen(),
        Constants.KEY_ROUTE_PULL_TOOTH: (BuildContext context) =>
            PullToothScreen(),
        Constants.KEY_ROUTE_QUESTION_AND_ANSWER: (BuildContext context) =>
            QuestionAnsScreen(),
        Constants.KEY_ROUTE_CONGRATULATION_SCREEN: (BuildContext context) =>
            CongratulationScreen(),
        Constants.KEY_ROUTE_RECEIVE_BADGE_SCREEN: (BuildContext context) =>
            ReceiveBadgeScreen(),
        Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL:
            (BuildContext context) => CongratulationAfterToothPullScreen(),
        Constants.KEY_ROUTE_INVEST_SCREEN: (BuildContext context) =>
            InvestScreen(),
        Constants.KEY_ROUTE_CASH_OUT_SCREEN: (BuildContext context) =>
            CashOutScreen(),
        Constants.KEY_ROUTE_TELL_YOUR_FRIEND_SCREEN: (BuildContext context) =>
            TellYourFriendScreen(),
        Constants.KEY_ROUTE_ANALYSING_SCREEN: (BuildContext context) =>
            AnalysingScreen(),
        Constants.KEY_ROUTE_SHARE_SCREEN: (BuildContext context) =>
            ShareScreen(),
        Constants.KEY_DEVICE_NOT_SUPPORTED_SCREEN: (BuildContext context) =>
            DeviceNotSupportedScreen(),
      },
    );
  }
}
