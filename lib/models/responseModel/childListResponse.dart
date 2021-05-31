class ChildListResponse {
  int status;
  String message;
  List<ChildData> data;

  ChildListResponse({this.status, this.message, this.data});

  ChildListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ChildData>();
      json['data'].forEach((v) {
        data.add(new ChildData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildData {
  int id;
  int userId;
  String name;
  int age;
  String img;
  String createdAt;
  String updatedAt;
  int teethCount;

  ChildData(
      {this.id,
      this.userId,
      this.name,
      this.age,
      this.img,
      this.createdAt,
      this.updatedAt,
      this.teethCount});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['TeethCount'] = this.teethCount;
    return data;
  }
}
