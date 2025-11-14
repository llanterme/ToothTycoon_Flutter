import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class AnalysingScreenModern extends StatefulWidget {
  const AnalysingScreenModern({super.key});

  @override
  State<AnalysingScreenModern> createState() => _AnalysingScreenModernState();
}

class _AnalysingScreenModernState extends State<AnalysingScreenModern> {
  bool _isToothBtnEnable = false;
  double _progress = 0;
  String analysingStatus = 'Analysing';

  @override
  void initState() {
    super.initState();
    _startTimer();
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
                    const Spacer(),
                    _buildAnalysing(colorScheme),
                    const Spacer(),
                    _buildButton(colorScheme),
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

  Widget _buildAnalysing(ColorScheme colorScheme) {
    return Column(
      children: [
        Image.asset('assets/icons/ic_analyzing.gif', height: 300, width: 300),
        Spacing.gapVerticalMd,
        Text(analysingStatus, style: TextStyle(fontSize: 33, color: colorScheme.onPrimary, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
        Spacing.gapVerticalMd,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            child: LinearProgressIndicator(
              backgroundColor: colorScheme.primary,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondaryContainer),
              value: _progress,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(ColorScheme colorScheme) {
    return Opacity(
      opacity: !_isToothBtnEnable ? 0.7 : 1.0,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: AppButton(
          text: 'How much is your tooth worth?',
          onPressed: _isToothBtnEnable ? () => NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL) : null,
          isFullWidth: true,
          customColor: colorScheme.secondaryContainer,
          customTextColor: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (_progress == 1) {
          timer.cancel();
          _isToothBtnEnable = true;
          analysingStatus = 'Done';
        } else {
          _progress += 0.5;
        }
      });
    });
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
