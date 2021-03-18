import 'dart:convert';
import 'dart:io';

import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';

class Utils {
  static String validateMobileNo(String mobileNo) {
    RegExp regExp = RegExp(r"^[0][1-9]\d{9}$|^[1-9]\d{9}$");

    if (mobileNo.trim().isEmpty) {
      return 'Phone is required';
    }

    if (!regExp.hasMatch(mobileNo)) {
      return 'Enter valid mobile no';
    }

    return null;
  }

  static String validateEmailId(String emailId) {
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (emailId.trim().isEmpty) {
      return 'Email is required';
    }

    if (!regExp.hasMatch(emailId)) {
      return 'Enter valid email id';
    }

    return null;
  }

  static String validatePassword(String password,
      {bool isConfirmPassword = false}) {
    RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

    if (password.trim().isEmpty) {
      return 'Password is required';
    }

    if (!regExp.hasMatch(password)) {
      return isConfirmPassword
          ? 'Your confirm password should contain one upper case letter, one lower case letter, one digit and length should be 8 character long'
          : 'Your password should contain one upper case letter, one lower case letter, one digit and length should be 8 character long';
    }

    return null;
  }

  static parseDate(String dateTime) {
    String date = DateFormat.yMMMMd("en_US").format(DateTime.parse(dateTime));
    print('Parsed Date : $date}');
    return date;
  }

  static parseTime(String dateTime) {
    String time = DateFormat.jm().format(DateTime.parse(dateTime));
    print('Parsed Time : $time');
    return time;
  }

  static parseTime24(String dateTime) {
    String time = DateFormat.Hm().format(DateTime.parse(dateTime));
    print('Parsed Time : $time');
    return time;
  }

  static parseDateDMY(String dateTime) {
    String date = DateFormat.yMd("en_US").format(DateTime.parse(dateTime));
    print('Parsed Date : $date}');
    return date;
  }

  static DateTime getDateTime(String dateTime) {
    DateTime dateTimeObj = DateTime.parse(dateTime);
    return dateTimeObj;
  }

  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String getBase64String(File image) {
    final bytes = Io.File(image.path).readAsBytesSync();

    String base64 = base64Encode(bytes);
    return base64;
  }

  static showAlertDialog(BuildContext context, String message) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Tooth Tycoon"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showToast({String message, durationInSecond}) {
    BotToast.showText(
      text: message,
      duration: Duration(seconds: durationInSecond),
    );
  }

  static Future<Uint8List> assetToBytes(String src) async {
    final bytes = await rootBundle.load(src);
    return bytes.buffer.asUint8List();
  }

  static Future<String> assetToFile(String src) async {
    final bytes = await assetToBytes(src);
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/$src");
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    print(">> ${file.path} ${await file.exists()}");
    return file.path;
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }
}
