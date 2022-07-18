class TimeSheetModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;


  TimeSheetModel.withError(String errorValue) : error = errorValue;


  TimeSheetModel({this.jsonrpc, this.id, this.result});

  TimeSheetModel.fromJson(Map<String, dynamic> json) {
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
  List<SlotIds>? slotIds;

  Result({this.slotIds});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['slot_ids'] != null) {
      slotIds = <SlotIds>[];
      json['slot_ids'].forEach((v) {
        slotIds!.add(new SlotIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slotIds != null) {
      data['slot_ids'] = this.slotIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotIds {
  int? id;
  String? name;

  SlotIds({this.id, this.name});

  SlotIds.fromJson(Map<String, dynamic> json) {
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