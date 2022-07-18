class RegistrationModel {
  String? status;
  String? token;
  String? message;
  User? user;
  String? error;

  RegistrationModel({this.status, this.token, this.message, this.user});

  RegistrationModel.withError(String errorValue) : error = errorValue;

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? firstName;
  int? userId;
  String? coverImage;
  String? email;

  User({this.firstName, this.userId, this.coverImage, this.email});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    userId = json['user_id'];
    coverImage = json['cover_image'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['user_id'] = this.userId;
    data['cover_image'] = this.coverImage;
    data['email'] = this.email;
    return data;
  }
}