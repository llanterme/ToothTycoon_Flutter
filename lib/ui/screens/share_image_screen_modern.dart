import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class ShareImageScreenModern extends StatefulWidget {
  const ShareImageScreenModern({super.key});

  @override
  State<ShareImageScreenModern> createState() => _ShareImageScreenModernState();
}

class _ShareImageScreenModernState extends State<ShareImageScreenModern> {
  final GlobalKey _globalKey = GlobalKey();
  final APIService _apiService = APIService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(colorScheme),
                Image.asset('assets/icons/ic_fairy.png', height: 185, width: 185),
                Spacing.gapVerticalMd,
                _buildCard(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onPrimary),
          onPressed: _onBackPress,
        ),
      ),
    );
  }

  Widget _buildCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Spacing.radiusXl)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            const Text('Share', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            _buildShareImage(colorScheme),
            Spacing.gapVerticalMd,
            AppButton(text: 'Share', onPressed: _shareMileStone, isFullWidth: true, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildShareImage(ColorScheme colorScheme) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        height: 350,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(CommonResponse.capturedImagePath), fit: BoxFit.contain),
            Image.asset('assets/images/img_share.png', fit: BoxFit.contain),
            Positioned(top: 10, left: 0, right: 0, child: Text("I'm a", textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: Colors.white, fontFamily: 'Avenir'))),
            Positioned(bottom: 30, left: 20, right: 20, child: _buildDescription()),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(text: 'My tooth is worth ', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Avenir')),
          TextSpan(text: '${CommonResponse.budget?.symbol ?? "\$"}${CommonResponse.pullToothData!.reward} ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Avenir', color: Colors.black)),
          const TextSpan(text: 'and I invested it.\n', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Avenir')),
          TextSpan(text: 'In ${CommonResponse.investedYear} years it will be worth ', style: const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Avenir')),
          TextSpan(text: '${CommonResponse.budget?.symbol ?? "\$"}${CommonResponse.futureValue}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Avenir')),
        ],
      ),
    );
  }

  Future<void> _createImage() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/ToothTycoon.png').writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Tooth Tycoon!');
    } catch (e) {
      debugPrint('Share Image Error: $e');
    }
  }

  void _shareMileStone() async {
    setState(() => _isLoading = true);

    final token = await PreferenceHelper().getAccessToken();
    final authToken = '${Constants.VAL_BEARER} $token';
    final childId = CommonResponse.childId.toString();

    final response = await _apiService.shareMilestoneApiCall(childId, authToken);
    final responseData = json.decode(response.body);
    final message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      setState(() => _isLoading = false);
      await _createImage();
    } else {
      setState(() => _isLoading = false);
      Utils.showToast(message: message, durationInSecond: 3);
    }
  }

  void _onBackPress() {
    CommonResponse.futureValue = '';
    CommonResponse.investedYear = '';
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
  }
}
