class SignupResponse {
  late String status;
  late String msg;
  Data? data;

  SignupResponse({required this.status, required this.msg, this.data});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    msg = json['message'] ?? json['msg'] ?? '';
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  late String name;
  late String email;
  late String updatedAt;
  late String createdAt;
  late int id;
  late String accessToken;

  Data(
      {required this.name,
        required this.email,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
        required this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? 0;
    accessToken = json['accessToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['accessToken'] = accessToken;
    return data;
  }
}
