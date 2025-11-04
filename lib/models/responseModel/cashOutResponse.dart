class CashOutResponse {
  late int status;
  late String message;
  Data? data;

  CashOutResponse({required this.status, required this.message, this.data});

  CashOutResponse.fromJson(Map<String, dynamic> json) {
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
  late int userId;
  late String childId;
  late String pullDetailId;
  late String amount;
  late String updatedAt;
  late String createdAt;
  late int id;

  Data(
      {required this.userId,
        required this.childId,
        required this.pullDetailId,
        required this.amount,
        required this.updatedAt,
        required this.createdAt,
        required this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    childId = json['child_id'];
    pullDetailId = json['pull_detail_id'];
    amount = json['amount'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['child_id'] = childId;
    data['pull_detail_id'] = pullDetailId;
    data['amount'] = amount;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}