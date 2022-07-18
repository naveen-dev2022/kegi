class BookingActiveModel {

  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  BookingActiveModel({this.jsonrpc, this.id, this.result});

  BookingActiveModel.withError(String errorValue) : error = errorValue;

  BookingActiveModel.fromJson(Map<String, dynamic> json) {
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

  List<BookingIds>? bookingIds;
  Result({this.bookingIds});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['booking_ids'] != null) {
      bookingIds = <BookingIds>[];
      json['booking_ids'].forEach((v) {
        bookingIds!.add(new BookingIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingIds != null) {
      data['booking_ids'] = this.bookingIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingIds {
  int? id;
  var category;
  List<String>? images;
  double? price;
  var latitude;
  var longitude;
  String? description;
  String? serviceType;
  String? date;
  String? number;
  String? state;

  BookingIds(
      {this.id,
        this.category,
        this.images,
        this.price,
        this.latitude,
        this.longitude,
        this.description,
        this.serviceType,
        this.date,
        this.number,
        this.state});

  BookingIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    images = json['images'].cast<String>();
    price = json['price'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    serviceType = json['service_type'];
    date = json['date'];
    number = json['number'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['images'] = this.images;
    data['price'] = this.price;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    data['service_type'] = this.serviceType;
    data['date'] = this.date;
    data['number'] = this.number;
    data['state'] = this.state;
    return data;
  }


}