import 'package:tooth_tycoon/models/responseModel/childListResponse.dart';
import 'package:tooth_tycoon/models/responseModel/currencyResponse.dart';
import 'package:tooth_tycoon/models/responseModel/loginResponseModel.dart';
import 'package:tooth_tycoon/models/responseModel/pullHistoryResponse.dart';
import 'package:tooth_tycoon/models/responseModel/pullToothResponse.dart';
import 'package:tooth_tycoon/models/responseModel/submitQuestionResponse.dart';

class CommonResponse {
  static int childId = 0;

  static String selectedTooth = '8';
  static String childName = '';
  static String capturedImagePath = '';
  static String investedYear = '';
  static String futureValue = '';

  static PullToothData? pullToothData;
  static PullHistoryData? pullHistoryData;
  static ChildData? childData;
  static SubmitQuestionData? submitQuestionData;
  static CurrencyResponse? currencyResponse;
  static Budget? budget;

  static bool isFromChildSummary = false;
}
