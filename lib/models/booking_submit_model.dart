class BookingSubmitDataModel {
  String? name;
  bool? status;
  String? error;

  BookingSubmitDataModel({this.name, this.status});

  BookingSubmitDataModel.withError(String errorValue) : error = errorValue;

  BookingSubmitDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}