class BannerListModel {
  String? jsonrpc;
  Null id;
  Result? result;
  String? error;

  BannerListModel({this.jsonrpc, this.id, this.result});

  BannerListModel.withError(String errorValue) : error = errorValue;

  BannerListModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
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
  List<BannerIds>? bannerIds;

  Result({this.bannerIds});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['banner_ids'] != null) {
      bannerIds = <BannerIds>[];
      json['banner_ids'].forEach((v) {
        bannerIds!.add(BannerIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bannerIds != null) {
      data['banner_ids'] = bannerIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerIds {
  int? id;
  String? name;
  String? notes;
  String? image;

  BannerIds({this.id, this.name,this.notes, this.image});

  BannerIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['notes'] = notes;
    data['image'] = image;
    return data;
  }

}