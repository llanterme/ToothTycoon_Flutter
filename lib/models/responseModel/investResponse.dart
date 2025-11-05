class InvestResponse {
  late int status;
  late String message;
  Data? data;

  InvestResponse({required this.status, required this.message, this.data});

  InvestResponse.fromJson(Map<String, dynamic> json) {
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
  late String years;
  late String rate;
  late String endDate;
  late String amount;
  late String finalAmount;
  late String updatedAt;
  late String createdAt;
  late int id;

  Data(
      {required this.userId,
        required this.childId,
        required this.pullDetailId,
        required this.years,
        required this.rate,
        required this.endDate,
        required this.amount,
        required this.finalAmount,
        required this.updatedAt,
        required this.createdAt,
        required this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    childId = json['child_id'];
    pullDetailId = json['pull_detail_id'];
    years = json['years'];
    rate = json['rate'];
    endDate = json['end_date'];
    amount = json['amount'];
    finalAmount = json['final_amount'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['child_id'] = childId;
    data['pull_detail_id'] = pullDetailId;
    data['years'] = years;
    data['rate'] = rate;
    data['end_date'] = endDate;
    data['amount'] = amount;
    data['final_amount'] = finalAmount;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}