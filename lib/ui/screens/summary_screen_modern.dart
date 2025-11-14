import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

/// Modern summary screen showing child's tooth collection and wallet
class SummaryScreenModern extends StatefulWidget {
  const SummaryScreenModern({super.key});

  @override
  State<SummaryScreenModern> createState() => _SummaryScreenModernState();
}

class _SummaryScreenModernState extends State<SummaryScreenModern> {
  final APIService _apiService = APIService();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isDataAvail = true;
  int _collectedTooth = 0;
  int _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (!_isDataAvail) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Spacing.gapVerticalXl,
              Image.asset(
                'assets/icons/ic_no_data.png',
                height: 200,
                width: 200,
              ),
              Spacing.gapVerticalMd,
              Text(
                'No teeth collected yet',
                style: TextStyle(
                  fontSize: 19,
                  color: colorScheme.onPrimary,
                  fontFamily: 'Avenir',
                ),
              ),
              const SizedBox(height: 100),
              _buildActionButtons(colorScheme, isNoData: true),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Spacing.radiusXl),
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                children: [
                  _buildStatCard(
                    colorScheme,
                    icon: Icons.favorite_outline,
                    title: 'Tooth collected',
                    value: '$_collectedTooth',
                  ),
                  Spacing.gapVerticalSm,
                  _buildStatCard(
                    colorScheme,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Tooth wallet',
                    value:
                        '${CommonResponse.budget?.symbol ?? "\$"}$_totalAmount',
                  ),
                  const SizedBox(height: 100),
                  _buildActionButtons(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            Spacing.gapHorizontalMd,
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontFamily: 'Avenir',
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Avenir',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme, {bool isNoData = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        children: [
          AppButton(
            text: 'Collect tooth',
            onPressed: () => NavigationService.instance
                .navigateToReplacementNamed(Constants.KEY_ROUTE_PULL_TOOTH),
            isFullWidth: true,
            customColor: colorScheme.secondaryContainer,
            customTextColor: colorScheme.onSecondaryContainer,
          ),
          Spacing.gapVerticalSm,
          AppButton(
            text: 'Keep my mouth healthy',
            onPressed: () => NavigationService.instance.navigateToReplacementNamed(
                Constants.KEY_ROUTE_QUESTION_AND_ANSWER),
            variant: AppButtonVariant.outline,
            isFullWidth: true,
            customColor: colorScheme.onPrimary,
            customTextColor: colorScheme.onPrimary,
          ),
          if (!isNoData) ...[
            Spacing.gapVerticalSm,
            AppButton(
              text: 'Cash out',
              onPressed: () {
                if (CommonResponse.pullHistoryData!.amount > 0) {
                  CommonResponse.isFromChildSummary = true;
                  NavigationService.instance.navigateToReplacementNamed(
                      Constants.KEY_ROUTE_CASH_OUT_SCREEN);
                } else {
                  Utils.showToast(
                      message: 'Not enough wallet balance', durationInSecond: 3);
                }
              },
              isFullWidth: true,
              customColor: colorScheme.secondaryContainer,
              customTextColor: colorScheme.onSecondaryContainer,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _getHistory() async {
    final token = await PreferenceHelper().getAccessToken();
    final authToken = '${Constants.VAL_BEARER} $token';

    final response = await _apiService.pullHistoryApiCall(
        authToken, CommonResponse.childId.toString());
    final responseData = json.decode(response.body);
    final message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      final dataList = responseData[Constants.KEY_DATA];

      if (dataList != null && dataList.isNotEmpty) {
        final pullHistoryResponse = PullHistoryResponse.fromJson(responseData);
        CommonResponse.pullHistoryData = pullHistoryResponse.data;
        CommonResponse.pullToothData = null;

        int toothCount = 0;
        if (pullHistoryResponse.data?.teethList != null &&
            pullHistoryResponse.data!.teethList!.isNotEmpty) {
          toothCount = pullHistoryResponse.data!.teethList!.length;
        }

        if (mounted) {
          setState(() {
            _collectedTooth = toothCount;
            _totalAmount = pullHistoryResponse.data?.amount ?? 0;
            _isLoading = false;
          });
        }
      } else {
        CommonResponse.pullHistoryData = null;
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isDataAvail = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Utils.showToast(message: message, durationInSecond: 3);
    }
  }
}
