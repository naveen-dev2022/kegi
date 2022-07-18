class PromoCodeModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  PromoCodeModel({this.jsonrpc, this.id, this.result});

  PromoCodeModel.withError(String errorValue) : error = errorValue;

  PromoCodeModel.fromJson(Map<String, dynamic> json) {
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
  List<PromoCodeIds>? promoCodeIds;

  Result({this.promoCodeIds});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['promo_code_ids'] != null) {
      promoCodeIds = <PromoCodeIds>[];
      json['promo_code_ids'].forEach((v) {
        promoCodeIds!.add(new PromoCodeIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promoCodeIds != null) {
      data['promo_code_ids'] =
          this.promoCodeIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoCodeIds {
  int? id;
  String? code;
  String? notes;

  PromoCodeIds({this.id, this.code, this.notes});

  PromoCodeIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['notes'] = this.notes;
    return data;
  }
}