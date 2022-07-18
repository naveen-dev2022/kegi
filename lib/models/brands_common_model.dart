

class BrandsCommonData {
  int? id;
  String? name;
  String? notes;
  String? image;

  BrandsCommonData({this.id, this.name,this.notes, this.image});

  BrandsCommonData.fromJson(Map<String, dynamic> json) {
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