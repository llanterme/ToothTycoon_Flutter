class SocialLoginPostData {
  String email;
  String name;
  String socialId;
  String socialName;
  String fcmToken;
  String deviceId;

  Map<String, String> toJson() {
    Map<String, String> data = {
      'email': this.email,
      'name': this.name,
      'social_id': this.socialId,
      'social_name': this.socialName,
      'fcm_token': this.fcmToken,
      'device_id': this.deviceId,
    };
    return data;
  }
}
