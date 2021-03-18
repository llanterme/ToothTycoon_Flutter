class PullToothResponse {
  int status;
  String message;
  PullToothData data;

  PullToothResponse({this.status, this.message, this.data});

  PullToothResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PullToothData.fromJson(json['data']) : null;
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

class PullToothData {
  String childId;
  String teethNumber;
  String pullDate;
  String picture;
  String updatedAt;
  String createdAt;
  int id;
  String reward;
  String earn;

  PullToothData(
      {this.childId,
        this.teethNumber,
        this.pullDate,
        this.picture,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.reward,
        this.earn});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['child_id'] = this.childId;
    data['teeth_number'] = this.teethNumber;
    data['pull_date'] = this.pullDate;
    data['picture'] = this.picture;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['earn'] = this.earn;
    data['reward'] = this.reward;
    return data;
  }
}