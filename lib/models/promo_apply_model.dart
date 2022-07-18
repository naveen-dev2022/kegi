class PromoApplyModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  PromoApplyModel({this.jsonrpc, this.id, this.result});

  PromoApplyModel.withError(String errorValue) : error = errorValue;

  PromoApplyModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? status;
  double? discountAmount;
  String? msg;

  Result({this.status, this.msg});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    discountAmount=json['discount_amount'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}