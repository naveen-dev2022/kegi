class AddressListModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  AddressListModel({this.jsonrpc, this.id, this.result});

  AddressListModel.withError(String errorValue) : error = errorValue;

  AddressListModel.fromJson(Map<String, dynamic> json) {
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
  List<AddressList>? addressList;

  Result({this.addressList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['address_list'] != null) {
      addressList = <AddressList>[];
      json['address_list'].forEach((v) {
        addressList!.add(new AddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressList != null) {
      data['address_list'] = this.addressList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressList {
  int? addressId;
  String? type;
  String? flatNo;
  String? buildingName;
  String? streetName;
  var latitude;
  var longitude;
  String? countryId;

  AddressList(
      {this.addressId,
        this.type,
        this.flatNo,
        this.buildingName,
        this.streetName,
        this.latitude,
        this.longitude,
        this.countryId});
  AddressList.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    type = json['type'];
    flatNo = json['flat_no'];
    buildingName = json['building_name'];
    streetName = json['street_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['type'] = this.type;
    data['flat_no'] = this.flatNo;
    data['building_name'] = this.buildingName;
    data['street_name'] = this.streetName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['country_id'] = this.countryId;
    return data;
  }
}
