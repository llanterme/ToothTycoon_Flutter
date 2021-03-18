class LoginResponse {
  dynamic status;
  String message;
  Data data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String email;
  String phone;
  String photo;
  String name;
  String socialId;
  String socialName;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String deviceId;
  String fcmToken;
  Budget budget;
  String accessToken;
  List<Tokens> tokens;

  Data(
      {this.id,
      this.email,
      this.phone,
      this.photo,
      this.name,
      this.socialId,
      this.socialName,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.deviceId,
      this.fcmToken,
      this.budget,
      this.accessToken,
      this.tokens});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    photo = json['photo'];
    name = json['name'];
    socialId = json['social_id'];
    socialName = json['social_name'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deviceId = json['device_id'];
    fcmToken = json['fcm_token'];
    budget =
        json['budget'] != null ? new Budget.fromJson(json['budget']) : null;
    accessToken = json['accessToken'];
    if (json['tokens'] != null) {
      tokens = new List<Tokens>();
      json['tokens'].forEach((v) {
        tokens.add(new Tokens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['photo'] = this.photo;
    data['name'] = this.name;
    data['social_id'] = this.socialId;
    data['social_name'] = this.socialName;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['device_id'] = this.deviceId;
    data['fcm_token'] = this.fcmToken;
    if (this.budget != null) {
      data['budget'] = this.budget.toJson();
    }
    data['accessToken'] = this.accessToken;
    if (this.tokens != null) {
      data['tokens'] = this.tokens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Budget {
  String currencyId;
  String amount;
  String code;
  String symbol;

  Budget({this.currencyId, this.amount, this.code, this.symbol});

  Budget.fromJson(Map<String, dynamic> json) {
    currencyId = json['currency_id'];
    amount = json['amount'];
    code = json['code'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_id'] = this.currencyId;
    data['amount'] = this.amount;
    data['code'] = this.code;
    data['symbol'] = this.symbol;
    return data;
  }
}

class Tokens {
  String id;
  String userId;
  String clientId;
  String name;
  List<Null> scopes;
  bool revoked;
  String createdAt;
  String updatedAt;
  String expiresAt;

  Tokens(
      {this.id,
      this.userId,
      this.clientId,
      this.name,
      this.scopes,
      this.revoked,
      this.createdAt,
      this.updatedAt,
      this.expiresAt});

  Tokens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clientId = json['client_id'];
    name = json['name'];
    revoked = json['revoked'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['client_id'] = this.clientId;
    data['name'] = this.name;
    data['revoked'] = this.revoked;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['expires_at'] = this.expiresAt;
    return data;
  }
}
