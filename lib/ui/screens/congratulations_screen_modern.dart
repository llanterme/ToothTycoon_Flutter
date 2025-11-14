import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CongratulationsScreenModern extends StatefulWidget {
  const CongratulationsScreenModern({super.key});

  @override
  State<CongratulationsScreenModern> createState() => _CongratulationsScreenModernState();
}

class _CongratulationsScreenModernState extends State<CongratulationsScreenModern> {
  int _daysCount = 0;

  @override
  void initState() {
    super.initState();
    _daysCount = CommonResponse.submitQuestionData?.count ?? 0;
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
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(colorScheme),
              const Spacer(),
              Image.asset('assets/icons/ic_fairy.png', height: 185, width: 185),
              const Spacer(),
              _buildCard(colorScheme),
            ],
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Spacing.radiusXl)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            const Text('Congratulations!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            _buildDaysBadge(colorScheme),
            Spacing.gapVerticalMd,
            Text(
              "That's 15 days in a row\nKeep logging for social badges",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Avenir'),
            ),
            Spacing.gapVerticalMd,
            AppButton(
              text: 'Home',
              onPressed: () => NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME),
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysBadge(ColorScheme colorScheme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/icons/ic_congratulations_eclips.png', width: MediaQuery.of(context).size.width * 0.30),
        AutoSizeText.rich(
          TextSpan(children: [
            TextSpan(text: '$_daysCount', style: TextStyle(color: colorScheme.secondaryContainer, fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
            const TextSpan(text: '\n'),
            TextSpan(text: _daysCount == 1 ? 'DAY' : 'DAYS', style: TextStyle(color: colorScheme.secondaryContainer, fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
          ]),
          textAlign: TextAlign.center,
          minFontSize: 22,
          maxFontSize: 55,
        ),
      ],
    );
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
