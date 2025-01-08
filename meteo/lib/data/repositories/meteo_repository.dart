import 'dart:convert';
import 'dart:developer';

import 'package:meteo/data/dataProviders/meteo_api.dart';
import 'package:meteo/data/models/city.dart';
import 'package:meteo/data/models/meteo.dart';

class MeteoRepository {
  final MeteoAPI _meteoAPI = MeteoAPI();

  Future<Meteo?> getMeteo(double lat, double long) async {
    final rawMeteo = await _meteoAPI.getRawMeteo(lat, long);
    if (rawMeteo != null && rawMeteo.isNotEmpty) {
      try {
        Meteo meteo = meteoFromJson(jsonEncode(rawMeteo));

        return meteo;
      } catch (error) {
        log("meteoFromJson Error : $error");
        return null;
      }
    }
    return null;
  }

  Future<Iterable<City>?> searchCities(String keyword) async {
    final rawCities = await _meteoAPI.searchCities(keyword);
    if (rawCities != null && rawCities.isNotEmpty) {
      try {
        Cities cities = citiesFromJson(jsonEncode(rawCities));

        return cities.results;
      } catch (error) {
        log("searchCitiesfromJson Error : $error");
        return null;
      }
    }
    return null;
  }
}
