import 'package:flutter/material.dart';

class DateTimeUtils {
  static late String _dayString,
      _monthString,
      _yearString,
      _hour24String,
      _hour12String,
      _minuteString,
      _secondString,
      _stringAmPm,
      _stringAmPmSmall;

  static late int _dayNumber,
      _monthNumber,
      _yearNumber,
      _hour24Number,
      _hour12Number,
      _minuteNumber,
      _secondNumber;

  late DateTime _dateTime;
  late TimeOfDay _timeOfDay;

  static final List<int> _totalDays = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];

  static final List<String> _monthsHalfNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static final List<String> _monthsFullNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static final List<String> _dayFullNames = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  DateTimeUtils({required DateTime dateTime, required TimeOfDay timeOfDay}) {
    this._dateTime = dateTime;
    this._timeOfDay = timeOfDay;

    _dayNumber = dateTime.day;

    if (_dayNumber < 10) {
      _dayString = '0${_dayNumber}';
    } else {
      _dayString = _dayNumber.toString();
    }

    _monthNumber = dateTime.month;

    _monthNumber += 1;
    if (_monthNumber < 10) {
      _monthString = '0${_monthNumber}';
    } else {
      _monthString = _monthNumber.toString();
    }

    _yearNumber = dateTime.year;

    _yearString = _yearNumber.toString();

    _hour24Number = dateTime.hour;

    if (_hour24Number < 10) {
      _hour24String = '0${_hour24Number}';
    } else {
      _hour24String = _hour24Number.toString();
    }

    _hour12Number = timeOfDay.hourOfPeriod;

    if (_hour12Number < 10) {
      _hour12String = '0${_hour12Number}';
    } else {
      _hour12String = _hour12Number.toString();
    }

    if (_hour12Number == 0) {
      _hour12String = "12";
    }

    _minuteNumber = dateTime.minute;

    if (_minuteNumber == 0) {
      _minuteString = "00";
    } else if (_minuteNumber < 10) {
      _minuteString = '0${_minuteNumber}';
    } else {
      _minuteString = _minuteNumber.toString();
    }

    _secondNumber = dateTime.second;

    if (_secondNumber < 10) {
      _secondString = '0${_secondNumber}';
    } else {
      _secondString = _secondNumber.toString();
    }
  }

  static DateTime getParsedDateTime(String dateTime){
    return DateTime.parse(dateTime);
  }

  String getMonthName(int numberOfMonth) {
    if (numberOfMonth > 0 && numberOfMonth <= 12) {
      return _monthsHalfNames[numberOfMonth - 1];
    }
    return "???";
  }

  static String getOrdinal(int value) {
    List<String> fixes = [
      "th",
      "st",
      "nd",
      "rd",
      "th",
      "th",
      "th",
      "th",
      "th",
      "th"
    ];
    if (value % 100 > 9 && value % 100 < 21) {
      return '${value}${fixes[0]}';
    } else {
      return '${value}${fixes[value % 10]}';
    }
  }

  String getDay() {
    return _dayString;
  }

  String getMonth() {
    return _monthString;
  }

  String getYear() {
    return _yearString;
  }

  String getHour24() {
    return _hour24String;
  }

  String getHour12() {
    return _hour12String;
  }

  String getMinute() {
    return _minuteString;
  }

  String getSecond() {
    return _secondString;
  }

  int getDayNumber() {
    return _dayNumber;
  }

  void setDayNumber(int dayNumber) {
    _dayNumber = dayNumber;
  }

  int getMonthNumber() {
    return _monthNumber;
  }

  void setMonthNumber(int monthNumber) {
    monthNumber = monthNumber;
  }

  int getYearNumber() {
    return _yearNumber;
  }

  void setYearNumber(int yearNumber) {
    yearNumber = yearNumber;
  }

  int getHour24Number() {
    return _hour24Number;
  }

  void setHour24Number(int hour24Number) {
    _hour24Number = hour24Number;
  }

  int getHour12Number() {
    return _hour12Number;
  }

  void setHour12Number(int hour12Number) {
    hour12Number = hour12Number;
  }

  int getMinuteNumber() {
    return _minuteNumber;
  }

  void setMinuteNumber(int minuteNumber) {
    _minuteNumber = minuteNumber;
  }

  int getSecondNumber() {
    return _secondNumber;
  }

  void setSecondNumber(int secondNumber) {
    _secondNumber = secondNumber;
  }

  String getAmPm() {
    return _stringAmPm;
  }

  String getFormattedReadableDate() {
    String day = getOrdinal(getDayNumber());
    String month = getMonthName(getMonthNumber());
    return day + " " + month + " " + getYear();
  }

  /*String getMonthName() {
    return getMonthName(getMonthNumber());
  }*/

  String getFormattedReadableTime() {
    return getHour12() + ":" + getMinute() + " " + getAmPm();
  }

  String getFormattedReadableTimeWithSeconds() {
    return getHour12() +
        ":" +
        getMinute() +
        ":" +
        getSecond() +
        " " +
        getAmPm();
  }

  String getFormattedReadableTime24() {
    return getHour24() + ":" + getMinute();
  }

  String getFormattedReadableTime24WithSeconds() {
    return getHour24() + ":" + getMinute() + ":" + getSecond();
  }

  String getFileNameTimeStamp12() {
    return getDay() +
        "_" +
        getMonth() +
        "_" +
        getYear() +
        "_" +
        getHour12() +
        "_" +
        getMinute() +
        "_" +
        getSecond() +
        "_" +
        getAmPm();
  }

  String getFileNameTimeStamp24() {
    return getDay() +
        "_" +
        getMonth() +
        "_" +
        getYear() +
        "_" +
        getHour24() +
        "_" +
        getMinute() +
        "_" +
        getSecond();
  }

  String getDBFormatDate() {
    return getYear() + "-" + getMonth() + "-" + getDay();
  }

  String getDMYFormatDate() {
    return getDay() + "-" + getMonth() + "-" + getYear();
  }

  String getMDYFormatDate() {
    return getMonth() + "-" + getDay() + "-" + getYear();
  }

  String getDBFormatTime12() {
    return getHour12() + ":" + getMinute() + ":" + getSecond();
  }

  String getDBFormatTime24() {
    return getHour24() + ":" + getMinute() + ":" + getSecond();
  }

  String getMonthFullName() {
    return _monthsFullNames[getMonthNumber() - 1];
  }

  String getDayFullName() {
    return _dayFullNames[_dateTime.weekday];
  }
}
