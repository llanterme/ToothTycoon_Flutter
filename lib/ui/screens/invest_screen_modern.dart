import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class InvestScreenModern extends StatefulWidget {
  const InvestScreenModern({super.key});

  @override
  State<InvestScreenModern> createState() => _InvestScreenModernState();
}

class _InvestScreenModernState extends State<InvestScreenModern> {
  bool _isLoading = false;
  double _yearCount = 1;
  double _interestCount = 1;
  double _totalAmount = 0;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calculateTotalInterest();
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAppBar(colorScheme),
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
            const Text('Investing', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalSm,
            const Text("How do you want to invest your\ntooth money?", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            _buildSlider(colorScheme, 'YEARS', _yearCount, 10, (val) => setState(() {_yearCount = val; _calculateTotalInterest();})),
            Spacing.gapVerticalMd,
            _buildSlider(colorScheme, 'INTEREST RATE', _interestCount, 10, (val) => setState(() {_interestCount = val; _calculateTotalInterest();})),
            Spacing.gapVerticalMd,
            _buildFutureValue(colorScheme),
            Spacing.gapVerticalMd,
            AppButton(text: 'Invest', onPressed: !_isLoading ? _invest : null, isFullWidth: true, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(ColorScheme colorScheme, String label, double value, double max, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(Spacing.radiusPill)),
              child: Text('${value.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            ),
          ],
        ),
        Spacing.gapVerticalSm,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10,
            activeTrackColor: colorScheme.secondaryContainer,
            inactiveTrackColor: colorScheme.surfaceContainerHigh,
            thumbColor: colorScheme.primary,
          ),
          child: Slider(min: 1, max: max, value: value, onChanged: (val) => onChanged(val.toInt().toDouble())),
        ),
      ],
    );
  }

  Widget _buildFutureValue(ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('FUTURE VALUE', style: TextStyle(fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
            AutoSizeText('${CommonResponse.budget?.symbol ?? "\$"}${_totalAmount.toStringAsFixed(2)}', minFontSize: 28, maxFontSize: 32, style: const TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _calculateTotalInterest() {
    double p = double.parse(CommonResponse.pullToothData!.reward);
    double r = (_interestCount / 100);
    double t = _yearCount;
    double n = 1;
    double amount = p * pow(1 + (r / n), n * t);
    _totalAmount = double.parse(amount.toStringAsFixed(2));
    CommonResponse.futureValue = _totalAmount.toStringAsFixed(2);
    CommonResponse.investedYear = _yearCount.toInt().toString();
  }

  void _invest() async {
    // Check token before action
    if (!await AuthErrorHandler.checkTokenBeforeAction()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      int year = _dateTime.year + _yearCount.toInt();
      DateTime endDate = DateTime(year);
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');

      final childId = CommonResponse.childId.toString();
      final pullId = CommonResponse.pullToothData!.id.toString();
      final years = _yearCount.toInt().toString();
      final interestRate = _interestCount.toInt().toString();
      final endDateStr = dateFormat.format(endDate);
      final amount = CommonResponse.pullToothData!.earn;
      final finalAmount = _totalAmount.toString();

      // Use ApiClient with automatic token handling
      final response = await ApiClient().postForm(
        '/child/invest',
        body: {
          'child_id': childId,
          'pull_id': pullId,
          'years': years,
          'interest_rate': interestRate,
          'end_date': endDateStr,
          'amount': amount,
          'final_amount': finalAmount,
        },
      );

      setState(() => _isLoading = false);

      if (ApiClient().isSuccessResponse(response)) {
        AuthErrorHandler.showSuccess('Investment created successfully!');
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_TELL_YOUR_FRIEND_SCREEN);
      } else {
        // Handle 401 errors - ApiClient will redirect automatically
        if (response.statusCode == 401) {
          return;
        }

        final message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to create investment');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }

  void _onBackPress() {
    CommonResponse.futureValue = '';
    CommonResponse.investedYear = '';
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);
  }
}
