class SocialLoginPostData {
  late String email;
  late String name;
  late String socialId;
  late String socialName;
  late String fcmToken;
  late String deviceId;

  Map<String, String> toJson() {
    Map<String, String> data = {
      'email': email,
      'name': name,
      'social_id': socialId,
      'social_name': socialName,
      'fcm_token': fcmToken,
      'device_id': deviceId,
    };
    return data;
  }
}
