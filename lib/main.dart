import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/screens/splashScreen.dart';
import 'package:tooth_tycoon/ui/screens/analysing_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/capture_image_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/cash_out_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/child_detail_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/congratulations_after_tooth_pull_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/congratulations_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/device_not_supported_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/home_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/invest_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/pull_tooth_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/question_answer_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/receive_badge_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/share_image_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/tell_your_friend_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/view_children_screen_modern.dart';
import 'package:tooth_tycoon/ui/screens/welcome_screen_modern.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart' as ui;

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

      // Modern Material 3 theming
      theme: ui.AppTheme.lightTheme,
      darkTheme: ui.AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Can be changed to ThemeMode.system for automatic switching

      builder: BotToastInit(),
      navigatorKey: NavigationService.instance.navigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: Constants.KEY_ROUTE_SPLASH,
      routes: {
        Constants.KEY_ROUTE_SPLASH: (BuildContext context) => SplashScreen(),
        Constants.KEY_ROUTE_WELCOME: (BuildContext context) => const WelcomeScreenModern(),
        Constants.KEY_ROUTE_HOME: (BuildContext context) => const HomeScreenModern(),
        Constants.KEY_ROUTE_VIEW_CHILD: (BuildContext context) => const ViewChildrenScreenModern(),
        Constants.KEY_ROUTE_CHILD_DETAIL: (BuildContext context) => const ChildDetailScreenModern(),
        Constants.KEY_ROUTE_CAPTURE_IMAGE: (BuildContext context) => const CaptureImageScreenModern(),
        Constants.KEY_ROUTE_PULL_TOOTH: (BuildContext context) => const PullToothScreenModern(),
        Constants.KEY_ROUTE_QUESTION_AND_ANSWER: (BuildContext context) => const QuestionAnswerScreenModern(),
        Constants.KEY_ROUTE_CONGRATULATION_SCREEN: (BuildContext context) => const CongratulationsScreenModern(),
        Constants.KEY_ROUTE_RECEIVE_BADGE_SCREEN: (BuildContext context) => const ReceiveBadgeScreenModern(),
        Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL: (BuildContext context) => const CongratulationsAfterToothPullScreenModern(),
        Constants.KEY_ROUTE_INVEST_SCREEN: (BuildContext context) => const InvestScreenModern(),
        Constants.KEY_ROUTE_CASH_OUT_SCREEN: (BuildContext context) => const CashOutScreenModern(),
        Constants.KEY_ROUTE_TELL_YOUR_FRIEND_SCREEN: (BuildContext context) => const TellYourFriendScreenModern(),
        Constants.KEY_ROUTE_ANALYSING_SCREEN: (BuildContext context) => const AnalysingScreenModern(),
        Constants.KEY_ROUTE_SHARE_SCREEN: (BuildContext context) => const ShareImageScreenModern(),
        Constants.KEY_DEVICE_NOT_SUPPORTED_SCREEN: (BuildContext context) => const DeviceNotSupportedScreenModern(),
      },
    );
  }
}
