class AddressAddModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  AddressAddModel({this.jsonrpc, this.id, this.result});

  AddressAddModel.withError(String errorValue) : error = errorValue;

  AddressAddModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    data['id'] = id;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? status;
  String? msg;

  Result({this.status, this.msg});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = status;
    data['msg'] = msg;
    return data;
  }

}