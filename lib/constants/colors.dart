import 'package:flutter/material.dart';

class AppColors {
  static const Color COLOR_PRIMARY = Color(0xff727dc7);
  static const Color COLOR_LIGHT_GREY = Color(0xffefefef);
  static const Color COLOR_LIGHT_YELLOW = Color(0xffffea7d);
  static const Color COLOR_LIGHT_GREEN = Color(0xff98FF95);
  static const Color COLOR_LIGHT_BLUE = Color(0xff397BF3);
  static const Color COLOR_LIGHT_RED = Color(0xffeb5f59);

  static const Color COLOR_TEXT_PRIMARY = Color(0xff7583CE);
  static const Color COLOR_TEXT_BLACK = Color(0xff212121);
  static const Color COLOR_ENABLE_INDICATOR = Color(0xffFFEA7D);
  static const Color COLOR_DISABLE_INDICATOR = Color(0xffffffff);

  static const Color COLOR_BTN_BLUE = Color(0xff4769B0);

  static const Map<int, Color> primaryColorGradiant = {
    50: Color.fromRGBO(107, 121, 199, .1),
    100: Color.fromRGBO(107, 121, 199, .2),
    200: Color.fromRGBO(107, 121, 199, .3),
    300: Color.fromRGBO(107, 121, 199, .4),
    400: Color.fromRGBO(107, 121, 199, .5),
    500: Color.fromRGBO(107, 121, 199, .6),
    600: Color.fromRGBO(107, 121, 199, .7),
    700: Color.fromRGBO(107, 121, 199, .8),
    800: Color.fromRGBO(107, 121, 199, .9),
    900: Color.fromRGBO(107, 121, 199, 1),
  };
}
