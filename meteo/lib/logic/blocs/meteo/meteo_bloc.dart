import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meteo/data/cache/cache_manager.dart';
import 'package:meteo/data/models/city.dart';
import 'package:meteo/data/models/meteo.dart';
import 'package:meteo/data/repositories/meteo_repository.dart';

part 'meteo_event.dart';
part 'meteo_state.dart';

class MeteoBloc extends Bloc<MeteoEvent, MeteoState> {
  MeteoBloc() : super(const MeteoState()) {
    on<MeteoEvent>((event, emit) async {
      final MeteoRepository meteoRepository = MeteoRepository();
      if (event is FetchMeteoEvent) {
        try {
          Meteo? targetCity;
          var isInternetConnected =
              await InternetConnectionChecker().connectionStatus;
          if (isInternetConnected == InternetConnectionStatus.connected) {
            targetCity = await meteoRepository.getMeteo(event.lat, event.long);
          } else {
            if (state.favoriteCities != null) {
              if (state.favoriteCities!.isNotEmpty) {
                for (var city in state.favoriteCities!) {
                  if (city.id == event.id) {
                    targetCity = city;
                    break;
                  }
                }
              }
            }
          }
          if (targetCity != null) {
            emit(state.copyWith(
                isCitySaved: (state.favoriteCities
                        ?.any((city) => city.id == targetCity!.id) ??
                    false)));
          }
          emit(state.copyWith(
            status: MeteoStatus.fetched,
            data: targetCity,
          ));
        } catch (e) {
          emit(state.copyWith(
            status: MeteoStatus.error,
          ));
          log("FetchMeteoEvent Exception :$e");
        }
      } else if (event is FetchCitiesEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("data")) {
          var oldCitiesRaw = await CacheManager.getData("data");

          cities = meteoListFromJson(oldCitiesRaw.syncData);

          emit(state.copyWith(
              favoriteCities: cities, status: MeteoStatus.success));
        } else {
          emit(state.copyWith(favoriteCities: [], status: MeteoStatus.success));
        }
      } else if (event is AddCityEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("data")) {
          var oldCitiesRaw = await CacheManager.getData("data");
          cities = meteoListFromJson(oldCitiesRaw.syncData);
        }
        bool alreadyExist = false;
        for (var element in cities) {
          if (element.name == state.data!.name) {
            alreadyExist = true;
            break;
          }
        }
        if (!alreadyExist) {
          cities.add(state.data!);
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "data", syncData: jsonEncode(cities));
          bool done = await CacheManager.setData("data", cacheDBModel);
          if (done) {
            emit(state.copyWith(
                favoriteCities: cities,
                isCitySaved: cities.any((city) => city.id == state.data!.id)));
          }
        }
      } else if (event is DeleteCityEvent) {
        // Use list comprehension for filtering cities
        final newCities =
            state.favoriteCities!.where((city) => city.id != event.id).toList();

        // Avoid unnecessary cache writes by checking if data has changed
        if (newCities.length != state.favoriteCities!.length) {
          final cacheDBModel = APICacheDBModel(
            key: "data",
            syncData: jsonEncode(newCities),
          );

          try {
            final done = await CacheManager.setData("data", cacheDBModel);
            if (done) {
              emit(state.copyWith(
                  favoriteCities: newCities,
                  isCitySaved:
                      newCities.any((city) => city.id == state.data!.id)));
            }
          } catch (e) {
            // Handle caching errors gracefully
            print("Failed to update cache: $e");
          }
        }
      } else if (event is ToggleSearching) {
        emit(state.copyWith(isSearching: !state.isSearching));
      }
    });
  }
}
