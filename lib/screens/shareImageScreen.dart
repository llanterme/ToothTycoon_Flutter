import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:tooth_tycoon/constants/colors.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/lager.dart';
import 'package:tooth_tycoon/utils/utils.dart';

import 'dart:ui' as ui;

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  GlobalKey _globalKey = GlobalKey();
  APIService _apiService = APIService();

  bool _isLoading = false;
  bool _isPainted = false;

  var pngBytes;

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
            child: MediaQuery.of(context).size.height <= 639
                ? _scrollableMainWidget()
                : _nonScrollableMainWidget(),
          ),
        ),
      ),
    );
  }

  Widget _scrollableMainWidget() {
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
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
      height: 185,
      width: 185,
    );
  }

  Widget _congratulationWidget() {
    return Container(
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
          _shareImageWidget(),
          _investBtn(),
        ],
      ),
    );
  }

  Widget _shareImageWidget() {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        height: 350,
        width: 350,
        margin: EdgeInsets.only(top: 15, bottom: 15),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            _userImage(),
            _decoratedImage(),
            Positioned(
              top: 10,
              child: Text(
                "I'm a",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: _shareDescription(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userImage() {
    return Image.file(
      File(CommonResponse.capturedImagePath),
      fit: BoxFit.contain,
    );
  }

  Widget _decoratedImage() {
    return Image.asset(
      'assets/images/img_share.png',
      fit: BoxFit.contain,
    );
  }

  Widget _shareDescription() {
    return Container(
      child: Center(
          child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'My tooth is worth ',
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontFamily: 'Avenir'),
          ),
          TextSpan(
            text:
                '${CommonResponse.budget?.symbol ?? "\$"}${CommonResponse.pullToothData!.reward} ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Avenir',
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'and I invested it.\n',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Avenir',
            ),
          ),
          TextSpan(
            text: 'In ${CommonResponse.investedYear} years it will be worth ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Avenir',
            ),
          ),
          TextSpan(
            text:
                '${CommonResponse.budget?.symbol ?? "\$"}${CommonResponse.futureValue}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Avenir',
            ),
          ),
        ]),
      )),
    );
  }

  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(
        'Share',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
        ),
      ),
    );
  }

  Widget _investBtn() {
    return InkWell(
      onTap: () async {
        //_createImage(_shareImageWidget());

        _shareMileStone();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: 50,
          right: 50,
          top: 5,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_PRIMARY,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: _isLoading
              ? _loader()
              : Text(
                  'Share',
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

  Widget _loader() {
    return Container(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Future<void> _createImage(Widget widget) async {
    try {
      RenderRepaintBoundary? boundary =
          _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary file and share
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ToothTycoon.png').writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Tooth Tycoon!');
    } catch (e) {
      await Lager.log('Share Image Screen : Share Image Exception : $e');
    }
  }

  void _onBackPress() {
    CommonResponse.futureValue = '';
    CommonResponse.investedYear = '';
    NavigationService.instance
        .navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);

     }

  void _shareMileStone() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await PreferenceHelper().getAccessToken();
    String authToken = '${Constants.VAL_BEARER} $token';
    String childId = CommonResponse.childId.toString();

    Response response =
        await _apiService.shareMilestoneApiCall(childId, authToken);
    dynamic responseData = json.decode(response.body);
    String message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() {
        _isLoading = false;
      });

      _createImage(_shareImageWidget());
    } else {
      setState(() {
        _isLoading = false;
      });

      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
