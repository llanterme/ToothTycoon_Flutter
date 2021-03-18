class InvestResponse {
  int status;
  String message;
  Data data;

  InvestResponse({this.status, this.message, this.data});

  InvestResponse.fromJson(Map<String, dynamic> json) {
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
  String years;
  String rate;
  String endDate;
  String amount;
  String finalAmount;
  String updatedAt;
  String createdAt;
  int id;

  Data(
      {this.userId,
        this.childId,
        this.pullDetailId,
        this.years,
        this.rate,
        this.endDate,
        this.amount,
        this.finalAmount,
        this.updatedAt,
        this.createdAt,
        this.id});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['child_id'] = this.childId;
    data['pull_detail_id'] = this.pullDetailId;
    data['years'] = this.years;
    data['rate'] = this.rate;
    data['end_date'] = this.endDate;
    data['amount'] = this.amount;
    data['final_amount'] = this.finalAmount;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}