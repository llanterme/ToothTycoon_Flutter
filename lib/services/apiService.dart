import 'dart:convert' as JSON;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:tooth_tycoon/models/postdataModel/addChildPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/loginPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/signupPostDataModel.dart';
import 'package:tooth_tycoon/models/postdataModel/socialLoginPostData.dart';

class APIService {
  // final String baseUrl = 'http://127.0.0.1:8000/api'; // Live
  final String baseUrl = 'http://ec2-3-141-107-40.us-east-2.compute.amazonaws.com/api'; // Luke
  Map<String, dynamic> header = {'Accept': "application/json"};

  dynamic getFacebookProfileDetails(FacebookAccessToken token) async {
    var userProfile;

    try {
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=email,name,picture.width(800).height(800)&access_token=${token.token}');
      userProfile = JSON.jsonDecode(graphResponse.body);

      return userProfile;
    } on SocketException catch (e) {
      // throw json.encode(_buildErrorResponse(e, "Connection Error"));
    } on Exception catch (e) {
      //throw json.encode(_buildErrorResponse(e, "Timeout Error"));
    }
  }

  Future<FacebookAccessToken> getFacebookToken() async {
    try {
      FacebookLogin _facebookLogin = FacebookLogin();
      final facebookLoginResult = await _facebookLogin.currentAccessToken;

      return facebookLoginResult;
    } on SocketException catch (e) {
      return null;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<http.Response> loginApiCall(LoginPostData loginPostData) async {
    String finalUrl = '$baseUrl/login';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: loginPostData.toJson(),
      );
      print('Login Response : ${response.body}');
      return response;
    } catch (e) {
      print('Login API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> signupApiCall(SignupPostData signupPostData) async {
    String finalUrl = '$baseUrl/register';
    print('Signup Request : ${signupPostData.toJson()}');
    try {
      http.Response response = await http.post(
        finalUrl,
        body: signupPostData.toJson(),
      );
      print('Signup Response : ${response.body}');
      return response;
    } catch (e) {
      print('Signup API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> childListApiCall(String authToken) async {
    String finalUrl = '$baseUrl/child';
    try {
      http.Response response = await http.post(
        finalUrl,
        headers: {'Authorization': authToken},
      );
      print('Child List Api Response : ${response.body}');
      return response;
    } catch (e) {
      print('Child List API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> addChildApiCall(AddChildPostData addChildPostData, String authToken) async {
    String finalUrl = '$baseUrl/child/add';
    try {
      http.MultipartRequest multipartRequest = await http.MultipartRequest(
        'POST',
        Uri.parse(finalUrl),
      );
      multipartRequest.files
          .add(await http.MultipartFile.fromPath('image', addChildPostData.imagePath));
      multipartRequest.fields.addAll(
        {
          'name': addChildPostData.name,
          'age': addChildPostData.dateOfBirth,
        },
      );
      multipartRequest.headers.addAll({'Authorization': authToken});
      http.StreamedResponse streamedResponse = await multipartRequest.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      print('Add Child Api Response : ${response.reasonPhrase}');
      return response;
    } catch (e) {
      print('Add Child API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> setBudgetApiCall(String amount, String authToken, String currencyId) async {
    String finalUrl = "$baseUrl/SetBudget";
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {'amount': amount, 'currency_id': currencyId},
        headers: {
          'Authorization': authToken,
        },
      );
      print('Set Budget Response : ${response.body}');
      return response;
    } catch (e) {
      print('Set Budget Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> pullHistoryApiCall(String authToken, String childId) async {
    String finalUrl = '$baseUrl/child/pull_history';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {'child_id': childId},
        headers: {
          'Authorization': authToken,
        },
      );
      print('Pull History Response : ${response.body}');
      return response;
    } catch (e) {
      print('Pull History API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> pullTeethApiCall(String childId, String teethNumber, String pullDate,
      String authToken, String imagePath) async {
    String finalUrl = '$baseUrl/child/teeth/pull';
    try {
      http.MultipartRequest multipartRequest =
          await http.MultipartRequest('POST', Uri.parse(finalUrl));
      multipartRequest.fields.addAll(
        {'child_id': childId, 'teeth_number': teethNumber, 'pull_date': pullDate},
      );
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('picture', imagePath),
      );
      multipartRequest.headers.addAll({'Authorization': authToken});
      http.StreamedResponse streamedResponse = await multipartRequest.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      print('Pull Teeth Api Response : ${response.reasonPhrase}');
      return response;
    } catch (e) {
      print('Pull Tooth API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> submitAns(
      String firstQueAns, String secondQueAns, String authToken, String childId) async {
    String finalUrl = '$baseUrl/SubmitQuestions';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {
          'child_id': childId,
          'question1': firstQueAns,
          'question2': secondQueAns,
        },
        headers: {
          'Authorization': authToken,
        },
      );
      print('Submit Ans Response : ${response.body}');
      return response;
    } catch (e) {
      print('Signup API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> investApiCall(String authToken, String childId, String pullId, String years,
      String interestRate, String endDate, String amount, String finalAmount) async {
    String finalUrl = '$baseUrl/child/invest';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {
          'child_id': childId,
          'pull_detail_id': pullId,
          'years': years,
          'rate': interestRate,
          'end_date': endDate,
          'amount': amount,
          'final_amount': finalAmount,
        },
        headers: {
          'Authorization': authToken,
        },
      );
      print('Invest API Response : ${response.body}');
      return response;
    } catch (e) {
      print('Signup API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> cashOutApiCall(
    String authToken,
    String childId,
    String pullId,
    String amount,
  ) async {
    String finalUrl = '$baseUrl/child/cashout';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {
          'child_id': childId,
          'pull_detail_id': pullId,
          'amount': amount,
        },
        headers: {
          'Authorization': authToken,
        },
      );
      print('Cash out API Response : ${response.body}');
      return response;
    } catch (e) {
      print('Signup API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> forgotPasswordApiCall(String email) async {
    String finalUrl = '$baseUrl/forgot';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {
          'email': email,
        },
      );
      print('Forgot Password Api Response : ${response.body}');
      return response;
    } catch (e) {
      print('Forgot Password API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> resetPasswordApiCall(
      String validationCode, String email, String password, String confirmPassword) async {
    String finalUrl = '$baseUrl/reset';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {
          'code': validationCode,
          'password': password,
          'password_confirmation': confirmPassword,
          'email': email,
        },
      );
      print('Reset Password API Response : ${response.body}');
      return response;
    } catch (e) {
      print('Reset Password API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> shareMilestoneApiCall(String childId, String authToken) async {
    String finalUrl = '$baseUrl/MillStone';
    try {
      http.Response response = await http.post(
        finalUrl,
        body: {'child_id': childId},
        headers: {
          'Authorization': authToken,
        },
      );
      print('Share Mile Stone API Response ${response.body}');
      return response;
    } catch (e) {
      print('Share Mile Stone API Exception $e');
      throw Exception(e);
    }
  }

  Future<http.Response> socialLoginApiCall(SocialLoginPostData socialLoginPostData) async {
    String finalUrl = '$baseUrl/Social';
    print('Social Login Request : ${socialLoginPostData.toJson()}');
    try {
      http.Response response = await http.post(finalUrl, body: socialLoginPostData.toJson());
      print('Social Login Response : ${response.body}');
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> getCurrencyApiCall(String authToken) async {
    String finalUrl = '$baseUrl/currency/get';
    try {
      http.Response response = await http.get(finalUrl, headers: {'Authorization': authToken});
      print('Get Currency Response : ${response.body}');
      return response;
    } catch (e) {
      print('Get Currency Api Exception $e');
      throw Exception(e);
    }
  }
}
