class SubmitQuestionResponse {
  int status;
  String message;
  SubmitQuestionData data;

  SubmitQuestionResponse({this.status, this.message, this.data});

  SubmitQuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SubmitQuestionData.fromJson(json['data']) : null;
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

class SubmitQuestionData {
  Tooth tooth;
  int count;

  SubmitQuestionData({this.tooth, this.count});

  SubmitQuestionData.fromJson(Map<String, dynamic> json) {
    tooth = json['tooth'] != null ? new Tooth.fromJson(json['tooth']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tooth != null) {
      data['tooth'] = this.tooth.toJson();
    }
    data['count'] = this.count;
    return data;
  }
}

class Tooth {
  int id;
  String question1;
  String question2;
  String childeId;
  Null deletedAt;
  String createdAt;
  String updatedAt;

  Tooth(
      {this.id,
        this.question1,
        this.question2,
        this.childeId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Tooth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question1 = json['question1'];
    question2 = json['question2'];
    childeId = json['childe_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question1'] = this.question1;
    data['question2'] = this.question2;
    data['childe_id'] = this.childeId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}