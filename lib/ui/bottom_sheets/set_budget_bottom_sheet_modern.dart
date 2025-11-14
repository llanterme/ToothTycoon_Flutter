import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/services/api_client.dart';
import 'package:tooth_tycoon/utils/auth_error_handler.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';
import 'package:tooth_tycoon/utils/utils.dart';

class SetBudgetBottomSheetModern extends StatefulWidget {
  const SetBudgetBottomSheetModern({Key? key}) : super(key: key);

  @override
  State<SetBudgetBottomSheetModern> createState() => _SetBudgetBottomSheetModernState();
}

class _SetBudgetBottomSheetModernState extends State<SetBudgetBottomSheetModern> {
  int amountCounter = 1;
  bool _isLoading = false;

  CurrencyData? _selCurrencyData;
  List<CurrencyData> _currencyList = [];
  String _selCurrency = '';

  @override
  void initState() {
    super.initState();
    _currencyList = CommonResponse.currencyResponse?.data ?? [];
    setState(() {
      if (_currencyList.isNotEmpty) {
        for (CurrencyData currencyData in _currencyList) {
          if (CommonResponse.budget != null) {
            if (int.parse(CommonResponse.budget!.currencyId) == currencyData.id) {
              _selCurrencyData = currencyData;
              _selCurrency = currencyData.symbol;
              amountCounter = double.parse(CommonResponse.budget!.amount).toInt();
            }
          } else {
            if (currencyData.code == 'USD') {
              _selCurrencyData = currencyData;
              _selCurrency = currencyData.symbol;
              break;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBottomSheet(
      title: 'Set budget',
      maxHeight: 550,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Description
          Text(
            'How much do you want to pay\nper tooth',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: Spacing.xl),

          // Amount Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              IconButton(
                onPressed: _decrement,
                icon: Image.asset(
                  'assets/icons/ic_minus.png',
                  height: 42,
                  width: 42,
                ),
              ),
              SizedBox(width: Spacing.xl),

              // Amount Display
              AnimatedCounter(
                value: amountCounter.toDouble(),
                prefix: _selCurrency,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: amountCounter > 100 && amountCounter <= 999
                      ? 40
                      : amountCounter > 999
                          ? 32
                          : 49,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: Spacing.xl),

              // Increment Button
              IconButton(
                onPressed: _increment,
                icon: Image.asset(
                  'assets/icons/ic_plus.png',
                  height: 42,
                  width: 42,
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.xl),

          // Currency List
          Container(
            height: 60,
            child: ListView.builder(
              itemCount: _currencyList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _currencyWidget(_currencyList[index], colorScheme);
              },
            ),
          ),
          SizedBox(height: Spacing.xl),

          // Done Button
          AppButton(
            text: 'Done',
            onPressed: () => _validate() ? _submit() : null,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
          SizedBox(height: Spacing.md),

          // Cancel Button
          AppButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            isFullWidth: true,
            variant: AppButtonVariant.text,
          ),
        ],
      ),
    );
  }

  Widget _currencyWidget(CurrencyData currency, ColorScheme colorScheme) {
    final isSelected = _selCurrencyData?.code == currency.code;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selCurrencyData = currency;
          _selCurrency = currency.symbol;
        });
      },
      child: Container(
        height: 50,
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            currency.symbol,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      if (amountCounter < 1000) {
        amountCounter++;
      }
    });
  }

  void _decrement() {
    setState(() {
      if (amountCounter != 1) {
        amountCounter--;
      }
    });
  }

  bool _validate() {
    if (amountCounter == 0) {
      Utils.showAlertDialog(context, 'Please set budget');
      return false;
    }
    return true;
  }

  void _submit() async {
    if (_selCurrencyData == null) {
      AuthErrorHandler.showError('No currency available. Please contact support.');
      return;
    }

    // Check token before action
    if (!await AuthErrorHandler.checkTokenBeforeAction()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      String amount = amountCounter.toString();

      // Use ApiClient with automatic token handling
      Response response = await ApiClient().postForm(
        '/SetBudget',
        body: {
          'amount': amount,
          'currency_id': _selCurrencyData!.id.toString(),
        },
      );

      setState(() => _isLoading = false);

      if (ApiClient().isSuccessResponse(response)) {
        // Update budget in local storage and memory
        Budget budget = Budget(
          currencyId: _selCurrencyData!.id.toString(),
          code: _selCurrencyData!.code,
          symbol: _selCurrencyData!.symbol,
          amount: amount,
        );
        CommonResponse.budget = budget;
        await PreferenceHelper().setCurrencyId(_selCurrencyData!.id.toString());
        await PreferenceHelper().setCurrencyAmount(amount);

        // Update login response with new budget
        String? responseStr = await PreferenceHelper().getLoginResponse();
        if (responseStr != null && responseStr.isNotEmpty) {
          var loginResponseData = json.decode(responseStr);
          LoginResponse loginResponse = LoginResponse.fromJson(loginResponseData);
          loginResponse.data?.budget = budget;
          loginResponse.status = '1';
          String loginResponseStr = json.encode(loginResponse.toJson());
          await PreferenceHelper().setLoginResponse(loginResponseStr);
        }

        AuthErrorHandler.showSuccess('Budget set successfully!');
        Navigator.pop(context);
      } else {
        // Handle 401 errors automatically by ApiClient
        if (response.statusCode == 401) {
          return;
        }

        String message = ApiClient().getErrorMessage(response, defaultMessage: 'Failed to set budget');
        AuthErrorHandler.showError(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AuthErrorHandler.handleNetworkError();
    }
  }
}
