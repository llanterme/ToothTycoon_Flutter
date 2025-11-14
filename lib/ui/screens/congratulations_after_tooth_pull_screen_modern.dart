import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:tooth_tycoon/constants/colors.dart' as constants_colors;
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CongratulationsAfterToothPullScreenModern extends StatefulWidget {
  const CongratulationsAfterToothPullScreenModern({super.key});

  @override
  State<CongratulationsAfterToothPullScreenModern> createState() => _CongratulationsAfterToothPullScreenModernState();
}

class _CongratulationsAfterToothPullScreenModernState extends State<CongratulationsAfterToothPullScreenModern> {
  bool _isShowAmount = false;
  int _amount = 0;

  @override
  void initState() {
    super.initState();
    _amount = double.parse(CommonResponse.pullToothData!.reward).toInt();
  }

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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(CommonResponse.capturedImagePath), fit: BoxFit.cover),
            Container(
              color: colorScheme.primary.withValues(alpha: 0.7),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(colorScheme),
                    _buildAnimation(colorScheme),
                    _buildCard(colorScheme),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildAnimation(ColorScheme colorScheme) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The animation containing the tooth fairy, text, and circle
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ImageSequenceAnimator(
                'assets/images/congratulationsAnimationImages',
                'Congratulations',
                1,
                4,
                'png',
                132,
                fps: 24,
                isLooping: false,
                isBoomerang: false,
                isAutoPlay: true,
                onFinishPlaying: (ImageSequenceAnimatorState imageState) {
                  setState(() => _isShowAmount = true);
                },
              ),
            ),
          ),
          // The amount positioned inside the circle that's part of the animation
          _buildAmountWidget(colorScheme),
        ],
      ),
    );
  }

  Widget _buildAmountWidget(ColorScheme colorScheme) {
    return Center(
      child: Container(
        height: 95,
        width: 95,
        // This margin positions the text to align with the circle in the animation
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.19,
          left: 5,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Visibility(
            visible: _isShowAmount,
            child: Text(
              '${CommonResponse.budget?.symbol ?? "\$"}$_amount',
              style: TextStyle(
                fontSize: _amount <= 999 ? 35 : 22,
                color: constants_colors.AppColors.COLOR_LIGHT_YELLOW,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
            const Text('What do you want to do?', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            AppButton(text: 'Invest It', onPressed: () => NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_INVEST_SCREEN), isFullWidth: true),
            Spacing.gapVerticalSm,
            AppButton(
              text: 'Cash out',
              onPressed: () {
                CommonResponse.isFromChildSummary = false;
                NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CASH_OUT_SCREEN);
              },
              variant: AppButtonVariant.secondary,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
