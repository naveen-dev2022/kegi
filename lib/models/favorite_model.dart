
class Favorite {
  String? title;
  String? subtitle;
  double? lat;
  double? lang;

  Favorite({this.title, this.subtitle, this.lat,this.lang});

  factory Favorite.fromJson(Map<String, dynamic> parsedJson) {
    return  Favorite(
        title: parsedJson['title'] ?? "",
        subtitle: parsedJson['subtitle'] ?? "",
        lat: parsedJson['lat'] ?? "",
    lang: parsedJson['lang'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "title": this.title,
      "subtitle": this.subtitle,
      "lat": this.lat,
      "lang": this.lang,
    };
  }
}