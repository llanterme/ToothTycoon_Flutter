class PullHistoryResponse {
  int status;
  String message;
  PullHistoryData data;

  PullHistoryResponse({this.status, this.message, this.data});

  PullHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PullHistoryData.fromJson(json['data']) : null;
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

class PullHistoryData {
  List<TeethList> teethList;
  int amount;
  List<Badges> badges;

  PullHistoryData({this.teethList, this.amount, this.badges});

  PullHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['TeethList'] != null) {
      teethList = new List<TeethList>();
      json['TeethList'].forEach((v) {
        teethList.add(new TeethList.fromJson(v));
      });
    }
    amount = json['Amount'];
    if (json['Badges'] != null) {
      badges = new List<Badges>();
      json['Badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teethList != null) {
      data['TeethList'] = this.teethList.map((v) => v.toJson()).toList();
    }
    data['Amount'] = this.amount;
    if (this.badges != null) {
      data['Badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeethList {
  int id;
  String childId;
  String teethNumber;
  String picture;
  String pullDate;
  String createdAt;
  String updatedAt;

  TeethList(
      {this.id,
      this.childId,
      this.teethNumber,
      this.picture,
      this.pullDate,
      this.createdAt,
      this.updatedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['child_id'] = this.childId;
    data['teeth_number'] = this.teethNumber;
    data['picture'] = this.picture;
    data['pull_date'] = this.pullDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Badges {
  int id;
  String name;
  String description;
  String img;
  String createdAt;
  String updatedAt;

  Badges({this.id, this.name, this.description, this.img, this.createdAt, this.updatedAt});

  Badges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
