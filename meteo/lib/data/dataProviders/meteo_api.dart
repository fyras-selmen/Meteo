import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meteo/data/dataProviders/my_dio.dart';

class MeteoAPI {
  // Méthode pour récupérer les données météo brutes pour une localisation donnée (latitude et longitude)
  Future<dynamic> getRawMeteo(double lat, double lon) async {
    try {
      // Définit l'URL de base pour l'API météo
      dio.options.baseUrl = "https://api.openweathermap.org/data/2.5/weather";

      // Effectue une requête GET avec les paramètres nécessaires (latitude, longitude, clé API, etc.)
      var response = await dio.get(
        ('?lat=$lat&lon=$lon&appid=$apiKey&lang=fr&units=metric'),
      );

      // Vérifie le code de statut HTTP de la réponse
      if (response.statusCode == 200) {
        // Si la requête est réussie, retourne les données reçues
        return response.data;
      } else if (response.statusCode == 404) {
        // Si aucune donnée n'est trouvée pour cette localisation
        await Fluttertoast.showToast(
            msg: "Aucune donnée trouvée pour cette ville",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return ""; // Retourne une chaîne vide
      } else {
        // Si une autre erreur survient
        await Fluttertoast.showToast(
            msg: "Veuillez réessayer plus tard",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return ""; // Retourne une chaîne vide
      }
    } catch (exception) {
      // Log l'exception en cas d'erreur pendant la requête
      log("RowMeteoException : $exception");
    }
  }

  // Méthode pour rechercher des villes correspondant à un mot-clé donné
  Future<dynamic> searchCities(String keyword) async {
    try {
      // Définit l'URL de base pour l'API de recherche de villes
      dio.options.baseUrl = 'http://api.openweathermap.org/geo/1.0/direct';

      // Effectue une requête GET avec le mot-clé et les autres paramètres nécessaires
      var response = await dio.get(
        ('?q=$keyword&limit=5&appid=$apiKey'),
      );

      // Vérifie le code de statut HTTP de la réponse
      if (response.statusCode == 200) {
        // Si la requête est réussie, retourne les données reçues
        return response.data;
      } else if (response.statusCode == 404) {
        // Si aucune ville n'est trouvée pour le mot-clé donné
        log("No data found for this city");
        return ""; // Retourne une chaîne vide
      } else {
        // En cas d'autres erreurs HTTP
        log("Error SearchCities API");
        return ""; // Retourne une chaîne vide
      }
    } catch (exception) {
      // Gère les exceptions spécifiques à Dio (par exemple, problèmes de connexion)
      if (exception is DioException) {
        if (exception.type.name == "connectionError") {
          await Fluttertoast.showToast(
              msg: "Pas de connexion internet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }

      // Log l'exception en cas d'erreur pendant la requête
      log("RowSearchCities Exception : $exception");
    }
  }
}
