class PreloadModel {
  String? jsonrpc;
  Null? id;
  Result? result;
  String? error;

  PreloadModel({this.jsonrpc, this.id, this.result});

  PreloadModel.withError(String errorValue) : error = errorValue;


  PreloadModel.fromJson(Map<String, dynamic> json) {
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
  List<ServiceCategoryIds>? serviceCategoryIds;
  List<ServiceType>? serviceType;
  List<PaymentDetails>? paymentDetails;

  Result({this.serviceCategoryIds, this.serviceType, this.paymentDetails});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['service_category_ids'] != null) {
      serviceCategoryIds = <ServiceCategoryIds>[];
      json['service_category_ids'].forEach((v) {
        serviceCategoryIds!.add(new ServiceCategoryIds.fromJson(v));
      });
    }
    if (json['service_type'] != null) {
      serviceType = <ServiceType>[];
      json['service_type'].forEach((v) {
        serviceType!.add(new ServiceType.fromJson(v));
      });
    }
    if (json['payment_details'] != null) {
      paymentDetails = <PaymentDetails>[];
      json['payment_details'].forEach((v) {
        paymentDetails!.add(new PaymentDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serviceCategoryIds != null) {
      data['service_category_ids'] =
          this.serviceCategoryIds!.map((v) => v.toJson()).toList();
    }
    if (this.serviceType != null) {
      data['service_type'] = this.serviceType!.map((v) => v.toJson()).toList();
    }
    if (this.paymentDetails != null) {
      data['payment_details'] =
          this.paymentDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceCategoryIds {
  int? id;
  String? name;

  ServiceCategoryIds({this.id, this.name});

  ServiceCategoryIds.fromJson(Map<String, dynamic> json) {
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

class ServiceType {
  String? expertVisitReq;
  String? iKnowWhatIssue;
  String? assistance;
  String? emergency;

  ServiceType(
      {this.expertVisitReq,
        this.iKnowWhatIssue,
        this.assistance,
        this.emergency});

  ServiceType.fromJson(Map<String, dynamic> json) {
    expertVisitReq = json['expert_visit_req'];
    iKnowWhatIssue = json['i_know_what_issue'];
    assistance = json['assistance'];
    emergency = json['emergency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expert_visit_req'] = this.expertVisitReq;
    data['i_know_what_issue'] = this.iKnowWhatIssue;
    data['assistance'] = this.assistance;
    data['emergency'] = this.emergency;
    return data;
  }
}

class PaymentDetails {
  int? id;
  String? serviceType;
  double? amount;
  double? surcharge;
  double? vat;

  PaymentDetails(
      {this.id, this.serviceType, this.amount, this.surcharge, this.vat});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceType = json['service_type'];
    amount = json['amount'];
    surcharge = json['surcharge'];
    vat = json['vat(%)'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_type'] = this.serviceType;
    data['amount'] = this.amount;
    data['surcharge'] = this.surcharge;
    data['vat(%)'] = this.vat;
    return data;
  }
}