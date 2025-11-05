class PullToothResponse {
  late int status;
  late String message;
  PullToothData? data;

  PullToothResponse({required this.status, required this.message, this.data});

  PullToothResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PullToothData.fromJson(json['data']) : null;
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

class PullToothData {
  late String childId;
  late String teethNumber;
  late String pullDate;
  late String picture;
  late String updatedAt;
  late String createdAt;
  late int id;
  late String reward;
  late String earn;

  PullToothData(
      {required this.childId,
        required this.teethNumber,
        required this.pullDate,
        required this.picture,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
        required this.reward,
        required this.earn});

  PullToothData.fromJson(Map<String, dynamic> json) {
    childId = json['child_id'];
    teethNumber = json['teeth_number'];
    pullDate = json['pull_date'];
    picture = json['picture'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    reward = json['reward'];
    earn = json['earn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['child_id'] = childId;
    data['teeth_number'] = teethNumber;
    data['pull_date'] = pullDate;
    data['picture'] = picture;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['earn'] = earn;
    data['reward'] = reward;
    return data;
  }
}
