import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/ui/bottom_sheets/add_child_bottom_sheet_modern.dart';
import 'package:tooth_tycoon/ui/bottom_sheets/set_budget_bottom_sheet_modern.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/services/token_manager.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class HomeScreenModern extends StatefulWidget {
  const HomeScreenModern({Key? key}) : super(key: key);

  @override
  State<HomeScreenModern> createState() => _HomeScreenModernState();
}

class _HomeScreenModernState extends State<HomeScreenModern> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme, colorScheme),
                        SizedBox(height: Spacing.lg),
                        Text(
                          "Let's get started",
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Spacing.xl),
                        _buildSetBudgetCard(theme, colorScheme),
                        SizedBox(height: Spacing.md),
                        _buildAddChildCard(theme, colorScheme),
                        SizedBox(height: Spacing.md),
                        _buildViewChildrenCard(theme, colorScheme),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/icons/ic_welcome.png',
          height: 80,
          width: 150,
        ),
        PopupMenuButton(
          icon: Image.asset(
            'assets/icons/ic_menu3line.png',
            height: 32,
            width: 32,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 1,
              child: Text('Logout', style: theme.textTheme.bodyLarge),
            ),
          ],
          onSelected: (int value) {
            _logout();
          },
        ),
      ],
    );
  }

  Widget _buildSetBudgetCard(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          height: 15,
          margin: EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ),
        AppCard(
          onTap: _openSetBudgetBottomSheet,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_set_budget.png',
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(width: Spacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SET YOUR BUDGET',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Spacing.xs),
                          Text(
                            "Let's decide how much a tooth is worth.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddChildCard(ThemeData theme, ColorScheme colorScheme) {
    return AppCard(
      onTap: _openAddChildBottomSheet,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_add_child.png',
                  height: 80,
                  width: 80,
                ),
                SizedBox(width: Spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADD A CHILD',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        "Who's the lucky kid? Add them here.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFC8E6C9),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewChildrenCard(ThemeData theme, ColorScheme colorScheme) {
    return AppCard(
      onTap: () {
        if (CommonResponse.budget != null) {
          NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_VIEW_CHILD);
        } else {
          Utils.showToast(message: 'Please set budget', durationInSecond: 3);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_view_children.png',
                  height: 80,
                  width: 80,
                ),
                SizedBox(width: Spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIEW YOUR CHILDREN',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Spacing.xs),
                      Text(
                        "Track each child's progress and tooth money empire",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFB3E5FC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openSetBudgetBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SetBudgetBottomSheetModern(),
      ),
    );
  }

  void _openAddChildBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddChildBottomSheetModern(refreshPage: () {}),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    exit(0);
  }

  void _logout() async {
    // Use TokenManager for comprehensive logout
    await TokenManager().logout();
    await PreferenceHelper().clearRememberMeData();

    AuthErrorHandler.showSuccess('Logged out successfully');
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_WELCOME);
  }

  void _getCurrency() async {
    try {
      // Use ApiClient with automatic token handling
      Response response = await ApiClient().get('/currency/get');

      if (ApiClient().isSuccessResponse(response)) {
        var responseData = json.decode(response.body);
        CurrencyResponse currencyResponse = CurrencyResponse.fromJson(responseData);
        CommonResponse.currencyResponse = currencyResponse;

        // Load saved budget from preferences
        String? selCurrencyId = await PreferenceHelper().getCurrencyId();
        String? amount = await PreferenceHelper().getCurrencyAmount();

        if (selCurrencyId != null && selCurrencyId.isNotEmpty && amount != null) {
          for (CurrencyData currencyData in currencyResponse.data!) {
            if (currencyData.id.toString() == selCurrencyId) {
              Budget budget = Budget(
                currencyId: currencyData.id.toString(),
                amount: amount,
                code: currencyData.code,
                symbol: currencyData.symbol,
              );
              CommonResponse.budget = budget;
              break;
            }
          }
        }

        // Load budget from login response
        String? responseStr = await PreferenceHelper().getLoginResponse();
        if (responseStr != null && responseStr.isNotEmpty) {
          var loginResponseData = json.decode(responseStr);
          LoginResponse loginResponse = LoginResponse.fromJson(loginResponseData);
          CommonResponse.budget = loginResponse.data?.budget;
        }

        if (mounted) {
          setState(() => _isLoading = false);
        }
      } else {
        // Handle 401 errors - ApiClient will redirect automatically
        if (response.statusCode == 401) {
          return;
        }

        if (mounted) {
          setState(() => _isLoading = false);
        }

        String message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to load currencies');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      AuthErrorHandler.handleNetworkError();
    }
  }
}
