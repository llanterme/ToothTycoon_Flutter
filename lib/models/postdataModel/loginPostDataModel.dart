class LoginPostData {
  String email;
  String password;
  String fcmToken;
  String deviceId;

  LoginPostData({required this.email, required this.password, required this.fcmToken, required this.deviceId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
      'device_id': deviceId,
    };

    return data;
  }
}
