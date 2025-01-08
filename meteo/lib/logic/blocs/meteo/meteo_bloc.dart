import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/data/cache/cache_manager.dart';
import 'package:meteo/data/models/city.dart';
import 'package:meteo/data/models/meteo.dart';
import 'package:meteo/data/repositories/meteo_repository.dart';
import 'package:meteo/logic/cubits/internet/internet_cubit.dart';

part 'meteo_event.dart';
part 'meteo_state.dart';

class MeteoBloc extends Bloc<MeteoEvent, MeteoState> {
  MeteoBloc() : super(const MeteoState()) {
    on<MeteoEvent>((event, emit) async {
      final MeteoRepository meteoRepository = MeteoRepository();
      if (event is FetchMeteoEvent) {
        try {
          KiwiContainer kc = KiwiContainer();
          final InternetCubit internetCubit = kc.resolve("internetCubit");
          Meteo? meteo;
          if (internetCubit.state is InternetConnected) {
            meteo = await meteoRepository.getMeteo(event.lat, event.long);
          } else {
            List<Meteo> cities = [];
            if (await CacheManager.containsKey("data")) {
              var oldCitiesRaw = await CacheManager.getData("data");
              cities = meteoListFromJson(oldCitiesRaw.syncData);
              if (cities.isNotEmpty) {
                for (var city in cities) {
                  if (city.id == event.id) {
                    meteo = city;
                    break;
                  }
                }
              } else {
                emit(state.copyWith(
                  status: MeteoStatus.error,
                ));
              }
            }
          }

          return emit(state.copyWith(
            status: MeteoStatus.success,
            data: meteo,
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
          emit(state.copyWith(favoriteCities: [], status: MeteoStatus.error));
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
        if (alreadyExist) {
          /*   await Fluttertoast.showToast(
              msg: "City already saved",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.5),
              textColor: Colors.white,
              fontSize: 16.0); */
        } else {
          cities.add(state.data!);
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "data", syncData: jsonEncode(cities));
          bool done = await CacheManager.setData("data", cacheDBModel);
          if (done) {
            /*    await Fluttertoast.showToast(
                msg: "City saved",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black.withOpacity(0.5),
                textColor: Colors.white,
                fontSize: 16.0); */
            emit(state.copyWith(favoriteCities: cities));
          }
        }
      } else if (event is DeleteCityEvent) {
        // Trigger FetchCitiesEvent only if necessary
        add(const FetchCitiesEvent());

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
              emit(state.copyWith(favoriteCities: newCities));
              /*    await Fluttertoast.showToast(
                  msg: "City deleted",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  textColor: Colors.white,
                  fontSize: 16.0); */
            }
          } catch (e) {
            // Handle caching errors gracefully
            print("Failed to update cache: $e");
          }
        }
      }
    });
  }
}
