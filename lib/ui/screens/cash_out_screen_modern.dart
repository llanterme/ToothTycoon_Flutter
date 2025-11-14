import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class CashOutScreenModern extends StatefulWidget {
  const CashOutScreenModern({super.key});

  @override
  State<CashOutScreenModern> createState() => _CashOutScreenModernState();
}

class _CashOutScreenModernState extends State<CashOutScreenModern> {
  bool _isLoading = false;
  double _withdrawBalanceCount = 1;
  int _maxWithdrawLimit = 0;

  @override
  void initState() {
    super.initState();
    if (CommonResponse.pullHistoryData != null) {
      if (CommonResponse.pullToothData != null) {
        _maxWithdrawLimit = int.parse(CommonResponse.pullToothData!.earn);
      } else {
        _maxWithdrawLimit = CommonResponse.pullHistoryData!.amount;
      }
    } else if (CommonResponse.pullToothData != null) {
      _maxWithdrawLimit = int.parse(CommonResponse.pullToothData!.earn);
    }
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
            const Text('Cash out', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            const Text("How much do you want to cash out?", textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            _buildBalance(colorScheme),
            Spacing.gapVerticalMd,
            _buildWithdrawSlider(colorScheme),
            Spacing.gapVerticalMd,
            AppButton(text: 'Withdraw Cash', onPressed: !_isLoading ? _withdrawCash : null, isFullWidth: true, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildBalance(ColorScheme colorScheme) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('BALANCE', style: TextStyle(fontSize: 18, fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
            AutoSizeText('${CommonResponse.budget?.symbol ?? '\$'}$_maxWithdrawLimit', minFontSize: 28, maxFontSize: 32, style: const TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawSlider(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('WITHDRAW', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(Spacing.radiusPill)),
              child: Text('${CommonResponse.budget?.symbol ?? '\$'}${_withdrawBalanceCount.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
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
          child: Slider(min: 1, max: _maxWithdrawLimit.toDouble(), value: _withdrawBalanceCount, onChanged: (value) => setState(() => _withdrawBalanceCount = value)),
        ),
      ],
    );
  }

  void _withdrawCash() async {
    // Check token before action
    if (!await AuthErrorHandler.checkTokenBeforeAction()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final childId = CommonResponse.childId.toString();
      final amount = _withdrawBalanceCount.toInt().toString();
      final pullId = CommonResponse.isFromChildSummary ? '0' : CommonResponse.pullToothData!.id.toString();

      // Use ApiClient with automatic token handling
      final response = await ApiClient().postForm(
        '/child/cashout',
        body: {
          'child_id': childId,
          'pull_id': pullId,
          'amount': amount,
        },
      );

      setState(() => _isLoading = false);

      if (ApiClient().isSuccessResponse(response)) {
        AuthErrorHandler.showSuccess('Cash out successful!');

        if (CommonResponse.isFromChildSummary) {
          CommonResponse.isFromChildSummary = false;
          NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
        } else {
          NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_HOME);
        }
      } else {
        // Handle 401 errors - ApiClient will redirect automatically
        if (response.statusCode == 401) {
          return;
        }

        final message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to cash out');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }

  void _onBackPress() {
    if (!CommonResponse.isFromChildSummary) {
      NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATIONS_ON_TOOTH_PULL);
    } else {
      NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
    }
  }
}
