// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:convert';

List<City> cityFromJson(String str) =>
    List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

class City {
  String name;

  double lat;
  double lon;
  String? country;

  City({
    required this.name,
    required this.lat,
    required this.lon,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        country: json["country"],
      );
}
