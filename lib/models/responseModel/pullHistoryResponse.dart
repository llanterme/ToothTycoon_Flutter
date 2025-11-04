class PullHistoryResponse {
  late int status;
  late String message;
  PullHistoryData? data;

  PullHistoryResponse({required this.status, required this.message, this.data});

  PullHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PullHistoryData.fromJson(json['data']) : null;
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

class PullHistoryData {
  List<TeethList>? teethList;
  late int amount;
  List<Badges>? badges;

  PullHistoryData({this.teethList, required this.amount, this.badges});

  PullHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['TeethList'] != null) {
      teethList = <TeethList>[];
      json['TeethList'].forEach((v) {
        teethList!.add(TeethList.fromJson(v));
      });
    }
    amount = json['Amount'];
    if (json['Badges'] != null) {
      badges = <Badges>[];
      json['Badges'].forEach((v) {
        badges!.add(Badges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teethList != null) {
      data['TeethList'] = teethList!.map((v) => v.toJson()).toList();
    }
    data['Amount'] = amount;
    if (badges != null) {
      data['Badges'] = badges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeethList {
  late int id;
  late String childId;
  late String teethNumber;
  late String picture;
  late String pullDate;
  late String createdAt;
  late String updatedAt;

  TeethList(
      {required this.id,
      required this.childId,
      required this.teethNumber,
      required this.picture,
      required this.pullDate,
      required this.createdAt,
      required this.updatedAt});

  TeethList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    childId = json['child_id'].toString();
    teethNumber = json['teeth_number'].toString();
    picture = json['picture'];
    pullDate = json['pull_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['child_id'] = childId;
    data['teeth_number'] = teethNumber;
    data['picture'] = picture;
    data['pull_date'] = pullDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Badges {
  late int id;
  late String name;
  late String description;
  late String img;
  late String createdAt;
  late String updatedAt;

  Badges({required this.id, required this.name, required this.description, required this.img, required this.createdAt, required this.updatedAt});

  Badges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['img'] = img;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
