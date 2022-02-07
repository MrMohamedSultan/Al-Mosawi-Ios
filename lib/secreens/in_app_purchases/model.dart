class PurchaseModel {
  String status;
  String message;
  UserData userData;

  PurchaseModel({this.status, this.message, this.userData});

  PurchaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userData = json['UserData'] != null
        ? new UserData.fromJson(json['UserData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userData != null) {
      data['UserData'] = this.userData.toJson();
    }
    return data;
  }
}

class UserData {
  int id;
  String name;

  UserData({this.id, this.name});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
