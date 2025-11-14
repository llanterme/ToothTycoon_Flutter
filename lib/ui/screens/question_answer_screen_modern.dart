import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:tooth_tycoon/constants/constants.dart';
import 'package:tooth_tycoon/helper/prefrenceHelper.dart';
import 'package:tooth_tycoon/models/responseModel/submitQuestionResponse.dart';
import 'package:tooth_tycoon/services/apiService.dart';
import 'package:tooth_tycoon/services/navigation_service.dart';
import 'package:tooth_tycoon/ui/ui_exports.dart';
import 'package:tooth_tycoon/utils/commonResponse.dart';

class QuestionAnswerScreenModern extends StatefulWidget {
  const QuestionAnswerScreenModern({super.key});

  @override
  State<QuestionAnswerScreenModern> createState() => _QuestionAnswerScreenModernState();
}

class _QuestionAnswerScreenModernState extends State<QuestionAnswerScreenModern> {
  final APIService _apiService = APIService();
  static const String ANS_YES = 'YES';
  static const String ANS_NO = 'NO';

  bool _isFirstQuestion = true;
  bool _isLoading = false;
  String _userName = '';
  String _firstQueAns = ANS_YES;
  String _secondQueAns = ANS_YES;
  String _selectedAns = ANS_YES;

  @override
  void initState() {
    super.initState();
    _userName = CommonResponse.childName;
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
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: colorScheme.onPrimary))
              : Column(
                  children: [
                    _buildAppBar(colorScheme),
                    const Spacer(),
                    Image.asset('assets/icons/ic_fairy.png', height: 185, width: 185),
                    const Spacer(),
                    _buildQuestionCard(colorScheme),
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

  Widget _buildQuestionCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Spacing.radiusXl)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            Text('Hello $_userName', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
            Spacing.gapVerticalMd,
            Text(
              _isFirstQuestion ? 'Did you brush your teeth today?' : 'Did you floss your teeth today?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Avenir'),
            ),
            Spacing.gapVerticalMd,
            _buildAnswerButton(ANS_YES, colorScheme),
            Spacing.gapVerticalSm,
            _buildAnswerButton(ANS_NO, colorScheme),
            Spacing.gapVerticalMd,
            AppButton(
              text: 'Next',
              onPressed: _handleNext,
              isFullWidth: true,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String answer, ColorScheme colorScheme) {
    final isSelected = _selectedAns == answer;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAns = answer;
          if (_isFirstQuestion) {
            _firstQueAns = answer;
          } else {
            _secondQueAns = answer;
          }
        });
      },
      child: AppCard(
        backgroundColor: isSelected ? colorScheme.secondaryContainer : colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(answer, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Avenir')),
              if (isSelected) Icon(Icons.check_circle, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    if (_isFirstQuestion) {
      setState(() {
        _selectedAns = ANS_YES;
        _isFirstQuestion = false;
      });
    } else {
      _submitAns();
    }
  }

  void _submitAns() async {
    setState(() => _isLoading = true);

    final token = await PreferenceHelper().getAccessToken();
    final authToken = '${Constants.VAL_BEARER} $token';
    final childId = CommonResponse.childId.toString();
    final firstQueAns = _firstQueAns == ANS_YES ? '1' : '0';
    final secondQueAns = _secondQueAns == ANS_YES ? '1' : '0';

    final response = await _apiService.submitAns(firstQueAns, secondQueAns, authToken, childId);
    final responseData = json.decode(response.body);
    final message = responseData[Constants.KEY_MESSAGE];

    if (response.statusCode == Constants.VAL_RESPONSE_STATUS_OK) {
      final submitQuestionResponse = SubmitQuestionResponse.fromJson(responseData);
      setState(() => _isLoading = false);

      if (submitQuestionResponse.data?.count == 15) {
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_RECEIVE_BADGE_SCREEN);
      } else {
        CommonResponse.submitQuestionData = submitQuestionResponse.data;
        NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CONGRATULATION_SCREEN);
      }
    } else {
      setState(() => _isLoading = false);
      BotToast.showText(text: message, duration: const Duration(seconds: 3));
    }
  }

  void _onBackPress() {
    NavigationService.instance.navigateToReplacementNamed(Constants.KEY_ROUTE_CHILD_DETAIL);
  }
}
