// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meteo/data/models/meteo.dart';
import 'package:meteo/utils/capitalize.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Meteo meteo;

  const CurrentWeatherWidget({super.key, required this.meteo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  "https://openweathermap.org/img/wn/${meteo.weather.first.icon}@2x.png",
                  fit: BoxFit.fill,
                ),
                Column(
                  children: [
                    Text(
                      meteo.weather.first.description.capitalize(),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "${meteo.main.temp.ceil()}°C",
                      style: const TextStyle(fontSize: 34),
                    )
                  ],
                )
              ],
            )),
        Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: ScreenUtil().scaleHeight * 90,
                    width: ScreenUtil().scaleWidth * 90,
                    child: Image.asset(
                      "assets/icons/windy.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getWindDirection(meteo.wind.deg),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "${meteo.wind.speed.ceil()} km/h",
                        style: const TextStyle(fontSize: 34),
                      )
                    ],
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: ScreenUtil().scaleHeight * 90,
                    width: ScreenUtil().scaleWidth * 90,
                    child: Image.asset(
                      "assets/icons/humidity.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Humidité",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "${meteo.main.humidity}%",
                        style: const TextStyle(fontSize: 34),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String getWindDirection(degree) {
    if (degree > 337.5) return 'Nord';
    if (degree > 292.5) return 'Nord-Ouest';
    if (degree > 247.5) return 'Ouest';
    if (degree > 202.5) return 'Sud-Ouest';
    if (degree > 157.5) return 'Sud';
    if (degree > 122.5) return 'Sud-Est';
    if (degree > 67.5) return 'Est';
    if (degree > 22.5) {
      return 'Nord-Est';
    }
    return 'Nord';
  }
}
