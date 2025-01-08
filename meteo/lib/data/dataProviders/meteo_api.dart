import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meteo/data/dataProviders/my_dio.dart';

class MeteoAPI {
  Future<dynamic> getRawMeteo(double lat, double lon) async {
    try {
      dio.options.baseUrl = "https://api.openweathermap.org/data/2.5/weather";
      var response = await dio.get(
        ('?lat=$lat&lon=$lon&appid=8d9b31bca6d4e1fc33a7137f179099de&lang=fr'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        await Fluttertoast.showToast(
            msg: "No data found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        log("No data found for this city");
        return "";
      } else {
        await Fluttertoast.showToast(
            msg: "Failed to load data. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        log("Error RawMeteo API");
        return "";
      }
    } catch (exception) {
      log("RowMeteoException : $exception");
    }
  }

  Future<dynamic> searchCities(String keyword) async {
    try {
      dio.options.baseUrl = 'https://geocoding-api.open-meteo.com/v1';
      var response = await dio.get(
        ('/search?name=$keyword&format=json&language=en&count=10'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        log("No data found for this city");
        return "";
      } else {
        log("Error SearchCities API");
        return "";
      }
    } catch (exception) {
      log("RowSearchCities Exception : $exception");
    }
  }
}
