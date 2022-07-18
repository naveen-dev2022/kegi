class BookingHistoryModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  BookingHistoryModel({this.jsonrpc, this.id, this.result});

  BookingHistoryModel.withError(String errorValue) : error = errorValue;


  BookingHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? category;
  List<String>? customerImages;
  List<String>? workBeforeImages;
  List<String>? workAfterImages;
  double? price;
  String? latitude;
  String? longitude;
  String? description;
  String? serviceType;
  String? date;
  String? number;
  String? state;

  BookingIds(
      {this.id,
        this.category,
        this.customerImages,
        this.workBeforeImages,
        this.workAfterImages,
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
    customerImages = json['customer_images'].cast<String>();
    workBeforeImages = json['work_before_images'].cast<String>();
    workAfterImages = json['work_after_images'].cast<String>();
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
    data['customer_images'] = this.customerImages;
    data['work_before_images'] = this.workBeforeImages;
    data['work_after_images'] = this.workAfterImages;
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