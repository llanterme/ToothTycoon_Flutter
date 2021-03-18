class CashOutResponse {
  int status;
  String message;
  Data data;

  CashOutResponse({this.status, this.message, this.data});

  CashOutResponse.fromJson(Map<String, dynamic> json) {
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
  int userId;
  String childId;
  String pullDetailId;
  String amount;
  String updatedAt;
  String createdAt;
  int id;

  Data(
      {this.userId,
        this.childId,
        this.pullDetailId,
        this.amount,
        this.updatedAt,
        this.createdAt,
        this.id});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['child_id'] = this.childId;
    data['pull_detail_id'] = this.pullDetailId;
    data['amount'] = this.amount;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}