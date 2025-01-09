import 'dart:convert';
import 'dart:developer';

import 'package:meteo/data/dataProviders/meteo_api.dart';
import 'package:meteo/data/models/city.dart';
import 'package:meteo/data/models/meteo.dart';

class MeteoRepository {
  final MeteoAPI _meteoAPI = MeteoAPI();

  // Méthode pour récupérer les données météo d'une localisation donnée (latitude et longitude)
  Future<Meteo?> getMeteo(double lat, double long) async {
    // Appelle l'API pour obtenir les données brutes de la météo
    final rawMeteo = await _meteoAPI.getRawMeteo(lat, long);

    if (rawMeteo != null && rawMeteo.isNotEmpty) {
      try {
        // Convertit les données brutes en un objet Meteo
        Meteo meteo = meteoFromJson(jsonEncode(rawMeteo));

        return meteo; // Retourne l'objet Meteo
      } catch (error) {
        // Log une erreur si la conversion échoue
        log("meteoFromJson Error : $error");
        return null; // Retourne null en cas d'erreur
      }
    }

    return null; // Retourne null si les données brutes sont vides ou nulles
  }

  // Méthode pour rechercher des villes en fonction d'un mot-clé
  Future<Iterable<City>?> searchCities(String keyword) async {
    // Appelle l'API pour rechercher des villes correspondant au mot-clé
    final rawCities = await _meteoAPI.searchCities(keyword);

    if (rawCities != null && rawCities.isNotEmpty) {
      try {
        // Convertit les données brutes en une liste d'objets City
        List<City> cities = cityFromJson(jsonEncode(rawCities));

        return cities; // Retourne la liste des villes trouvées
      } catch (error) {
        // Log une erreur si la conversion échoue
        log("searchCitiesfromJson Error : $error");
        return null; // Retourne null en cas d'erreur
      }
    }

    return null; // Retourne null si aucune ville n'est trouvée ou si les données brutes sont vides
  }
}
