class LoginResponse {
  dynamic status;
  late String message;
  Data? data;

  LoginResponse({this.status, required this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  late int id;
  late String email;
  late String phone;
  late String photo;
  late String name;
  late String socialId;
  late String socialName;
  late String emailVerifiedAt;
  late String createdAt;
  late String updatedAt;
  late String deviceId;
  late String fcmToken;
  Budget? budget;
  late String accessToken;
  List<Tokens>? tokens;

  Data(
      {required this.id,
      required this.email,
      required this.phone,
      required this.photo,
      required this.name,
      required this.socialId,
      required this.socialName,
      required this.emailVerifiedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.deviceId,
      required this.fcmToken,
      this.budget,
      required this.accessToken,
      this.tokens});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    photo = json['photo'] ?? '';
    name = json['name'] ?? '';
    socialId = json['social_id'] ?? '';
    socialName = json['social_name'] ?? '';
    emailVerifiedAt = json['email_verified_at'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    deviceId = json['device_id'] ?? '';
    fcmToken = json['fcm_token'] ?? '';
    budget = json['budget'] != null ? Budget.fromJson(json['budget']) : null;
    accessToken = json['accessToken'] ?? '';
    if (json['tokens'] != null) {
      tokens = <Tokens>[];
      json['tokens'].forEach((v) {
        tokens!.add(Tokens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['photo'] = photo;
    data['name'] = name;
    data['social_id'] = socialId;
    data['social_name'] = socialName;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['device_id'] = deviceId;
    data['fcm_token'] = fcmToken;
    if (budget != null) {
      data['budget'] = budget!.toJson();
    }
    data['accessToken'] = accessToken;
    if (tokens != null) {
      data['tokens'] = tokens!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Budget {
  late String currencyId;
  late String amount;
  late String code;
  late String symbol;

  Budget({required this.currencyId, required this.amount, required this.code, required this.symbol});

  Budget.fromJson(Map<String, dynamic> json) {
    currencyId = json['currency_id'] ?? '';
    amount = json['amount'] ?? '';
    code = json['code'] ?? '';
    symbol = json['symbol'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency_id'] = currencyId;
    data['amount'] = amount;
    data['code'] = code;
    data['symbol'] = symbol;
    return data;
  }
}

class Tokens {
  late String id;
  late String userId;
  late String clientId;
  late String name;
  List<dynamic>? scopes;
  late bool revoked;
  late String createdAt;
  late String updatedAt;
  late String expiresAt;

  Tokens(
      {required this.id,
      required this.userId,
      required this.clientId,
      required this.name,
      this.scopes,
      required this.revoked,
      required this.createdAt,
      required this.updatedAt,
      required this.expiresAt});

  Tokens.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    // userId = json['user_id'].toString();
    userId = json['user_id']?.toString() ?? '';
    clientId = json['client_id']?.toString() ?? '';
    name = json['name'] ?? '';
    revoked = json['revoked'] ?? false;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    expiresAt = json['expires_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['client_id'] = clientId;
    data['name'] = name;
    data['revoked'] = revoked;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['expires_at'] = expiresAt;
    return data;
  }
}
