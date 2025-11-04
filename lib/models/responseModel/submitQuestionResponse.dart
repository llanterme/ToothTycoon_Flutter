class SubmitQuestionResponse {
  late int status;
  late String message;
  SubmitQuestionData? data;

  SubmitQuestionResponse({required this.status, required this.message, this.data});

  SubmitQuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? SubmitQuestionData.fromJson(json['data']) : null;
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

class SubmitQuestionData {
  Tooth? tooth;
  late int count;

  SubmitQuestionData({this.tooth, required this.count});

  SubmitQuestionData.fromJson(Map<String, dynamic> json) {
    tooth = json['tooth'] != null ? Tooth.fromJson(json['tooth']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tooth != null) {
      data['tooth'] = tooth!.toJson();
    }
    data['count'] = count;
    return data;
  }
}

class Tooth {
  late int id;
  late String question1;
  late String question2;
  late String childeId;
  dynamic deletedAt;
  late String createdAt;
  late String updatedAt;

  Tooth(
      {required this.id,
        required this.question1,
        required this.question2,
        required this.childeId,
        this.deletedAt,
        required this.createdAt,
        required this.updatedAt});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question1'] = question1;
    data['question2'] = question2;
    data['childe_id'] = childeId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
