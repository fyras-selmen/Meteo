import 'dart:convert';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  List<City> results;
  double generationtimeMs;

  Cities({
    required this.results,
    required this.generationtimeMs,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        results: json["results"] != null
            ? List<City>.from(json["results"].map((x) => City.fromJson(x)))
            : [],
        generationtimeMs: json["generationtime_ms"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "generationtime_ms": generationtimeMs,
      };
}

class City {
  int id;
  String name;
  double latitude;
  double longitude;
  int elevation;
  String? featureCode;
  String? countryCode;
  int admin1Id;
  int? admin2Id;
  int? admin3Id;
  String? timezone;
  int? population;
  List<String>? postcodes;
  int countryId;
  String country;
  String? admin1;
  String? admin2;
  String? admin3;
  int? admin4Id;
  String? admin4;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.featureCode,
    required this.countryCode,
    required this.admin1Id,
    this.admin2Id,
    this.admin3Id,
    required this.timezone,
    this.population,
    this.postcodes,
    required this.countryId,
    required this.country,
    required this.admin1,
    this.admin2,
    this.admin3,
    this.admin4Id,
    this.admin4,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"] ?? "",
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        elevation: 0,
        featureCode: "",
        countryCode: "",
        admin1Id: 0,
        admin2Id: 0,
        admin3Id: 0,
        timezone: "",
        population: 0,
        postcodes: [],
        countryId: 0,
        country: json["country"] ?? "",
        admin1: "",
        admin2: "",
        admin3: "",
        admin4Id: 0,
        admin4: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "elevation": elevation,
        "feature_code": featureCode,
        "country_code": countryCode,
        "admin1_id": admin1Id,
        "admin2_id": admin2Id,
        "admin3_id": admin3Id,
        "timezone": timezone,
        "population": population,
        "postcodes": postcodes == null
            ? []
            : List<dynamic>.from(postcodes!.map((x) => x)),
        "country_id": countryId,
        "country": country,
        "admin1": admin1,
        "admin2": admin2,
        "admin3": admin3,
        "admin4_id": admin4Id,
        "admin4": admin4,
      };
}
