import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class TellYourFriendScreenModern extends StatelessWidget {
  const TellYourFriendScreenModern({super.key});

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAppBar(colorScheme, context),
                      Image.asset('assets/icons/ic_fairy.png', height: 200, width: 200),
                      Spacing.gapVerticalMd,
                      _buildCard(colorScheme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme, BuildContext context) {
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
            const Text('Investing', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'Great decision, ', style: TextStyle(fontSize: 19, fontFamily: 'Avenir', fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(text: CommonResponse.childName, style: TextStyle(fontSize: 19, fontFamily: 'Avenir', fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  const TextSpan(text: '.', style: TextStyle(fontSize: 19, fontFamily: 'Avenir', fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
            Spacing.gapVerticalMd,
            const Text("By Investing your tooth money, you\ndon't even have to do anything and\nyou will get more money every day.", textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            const Text("Share your pic to earn a rare badge\nand save this precious memory\nchest!", textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            AppButton(text: 'Tell your friends and family', onPressed: () => NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_SHARE_SCREEN), isFullWidth: true),
          ],
        ),
      ),
    );
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
