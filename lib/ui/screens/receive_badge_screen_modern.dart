import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';

class ReceiveBadgeScreenModern extends StatelessWidget {
  const ReceiveBadgeScreenModern({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPress(context);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(colorScheme, context),
                Spacing.gapVerticalMd,
                Image.asset('assets/icons/ic_fairy.png', height: 200, width: 200),
                Spacing.gapVerticalMd,
                _buildCard(colorScheme, context),
              ],
            ),
          ),
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
          onPressed: () => _onBackPress(context),
        ),
      ),
    );
  }

  Widget _buildCard(ColorScheme colorScheme, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Spacing.radiusXl)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            const Text('Woohoo!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalSm,
            const Text("You just earned the\nMr Money Bags Badge!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            SizedBox(height: MediaQuery.of(context).size.height * 0.30, child: Image.asset('assets/icons/ic_badges_list.gif', fit: BoxFit.contain)),
            Spacing.gapVerticalMd,
            const Text("Keep logging for special badges", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            AppButton(text: 'Home', onPressed: () => NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME), isFullWidth: true),
          ],
        ),
      ),
    );
  }

  void _onBackPress(BuildContext context) {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
