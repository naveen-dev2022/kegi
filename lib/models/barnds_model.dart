class BrandListModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  BrandListModel({this.jsonrpc, this.id, this.result});

  BrandListModel.withError(String errorValue) : error = errorValue;

  BrandListModel.fromJson(Map<String, dynamic> json) {
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
  List<BrandIds>? brandIds;

  Result({this.brandIds});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['brand_ids'] != null) {
      brandIds = <BrandIds>[];
      json['brand_ids'].forEach((v) {
        brandIds!.add(new BrandIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brandIds != null) {
      data['brand_ids'] = this.brandIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BrandIds {
  int? id;
  String? name;
  String? notes;
  String? image;

  BrandIds({this.id, this.name,this.notes, this.image});

  BrandIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['notes'] = this.notes;
    data['image'] = this.image;
    return data;
  }
}