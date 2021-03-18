class LoginPostData {
  String email;
  String password;
  String fcmToken;
  String deviceId;

  LoginPostData({this.email, this.password, this.fcmToken, this.deviceId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': this.email,
      'password': this.password,
      'fcm_token': this.fcmToken,
      'device_id': this.deviceId,
    };

    return data;
  }
}
