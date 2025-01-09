import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/data/cache/cache_manager.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/utils/appNavigator.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(const SplashScreenLoading()) {
    KiwiContainer kc = KiwiContainer();
    StreamSubscription<MeteoState>? meteoBlocSubscription;
    final MeteoBloc meteoBloc = kc.resolve("meteoBloc");
    var triggered = false;
    try {
      meteoBloc.add(const FetchCitiesEvent());
      meteoBlocSubscription = meteoBloc.stream.listen((state) async {
        if (!triggered) {
          triggered = true;

          log("Listening to MeteoBloc");
          //if not First time
          if (await CacheManager.containsKey("data")) {
            if (meteoBloc.state.status == MeteoStatus.success) {
              if (meteoBloc.state.favoriteCities!.isNotEmpty) {
                meteoBloc.add(FetchMeteoEvent(
                    id: meteoBloc.state.favoriteCities!.last.id,
                    long: 0,
                    lat: 0));
              } else {
                var currentLocation = await getCurrentLocation();
                if (currentLocation != null) {
                  meteoBloc.add(FetchMeteoEvent(
                      id: 0,
                      long: currentLocation.longitude,
                      lat: currentLocation.latitude));
                }
              }
            }
          } else {
            var currentLocation = await getCurrentLocation();
            if (currentLocation != null) {
              meteoBloc.add(FetchMeteoEvent(
                  id: 0,
                  long: currentLocation.longitude,
                  lat: currentLocation.latitude));
            }
          }
        }

        if (meteoBloc.state.status == MeteoStatus.fetched) {
          NavigationService().replaceTo('/home');
          meteoBlocSubscription!.cancel();
        }
      });
    } catch (exception) {
      log(exception.toString());
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
