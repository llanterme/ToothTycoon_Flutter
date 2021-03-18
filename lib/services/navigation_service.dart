import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  // Replaces the actual page with other page
  Future<dynamic> navigateToReplacementNamed(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateToReplacementNamedWithArgument(
      String _routeName, dynamic argument) {
    return navigatorKey.currentState
        .pushReplacementNamed(_routeName, arguments: argument);
  }

  // Pushes page on top of other page
  Future<dynamic> navigateToPushNamed(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> navigateToMaterialPgeRoute(MaterialPageRoute _route) {
    return navigatorKey.currentState.push(_route);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
