class RegistrationOtpModel {
  int? status;
  String? msg;
  String? error;

  RegistrationOtpModel({this.status, this.msg});

  RegistrationOtpModel.withError(String errorValue) : error = errorValue;

  RegistrationOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}