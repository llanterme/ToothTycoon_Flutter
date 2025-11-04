class ChildListResponse {
  late int status;
  late String message;
  List<ChildData>? data;

  ChildListResponse({required this.status, required this.message, this.data});

  ChildListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChildData>[];
      json['data'].forEach((v) {
        data!.add(ChildData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildData {
  late int id;
  late int userId;
  late String name;
  late int age;
  late String img;
  late String createdAt;
  late String updatedAt;
  late int teethCount;

  ChildData(
      {required this.id,
      required this.userId,
      required this.name,
      required this.age,
      required this.img,
      required this.createdAt,
      required this.updatedAt,
      required this.teethCount});

  ChildData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    age = json['age'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teethCount = json['TeethCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['age'] = age;
    data['img'] = img;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['TeethCount'] = teethCount;
    return data;
  }
}
