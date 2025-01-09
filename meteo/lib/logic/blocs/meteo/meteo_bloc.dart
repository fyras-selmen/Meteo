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

      // Gestion de l'événement FetchMeteoEvent
      if (event is FetchMeteoEvent) {
        try {
          Meteo? targetCity;
          var isInternetConnected =
              await InternetConnectionChecker().connectionStatus;

          if (isInternetConnected == InternetConnectionStatus.connected) {
            // Si connecté à Internet, récupérer les données météo depuis le repository
            targetCity = await meteoRepository.getMeteo(event.lat, event.long);
          } else {
            // Si pas de connexion Internet, vérifier les villes favorites en cache
            if (state.favoriteCities != null) {
              if (state.favoriteCities!.isNotEmpty) {
                for (var city in state.favoriteCities!) {
                  if (city.id == event.id) {
                    // Si la ville cible est trouvée dans les favoris, l'utiliser
                    targetCity = city;
                    break;
                  }
                }
              }
            }
          }

          if (targetCity != null) {
            // Vérifie si la ville cible est déjà enregistrée dans les favoris
            emit(state.copyWith(
                isCitySaved: (state.favoriteCities
                        ?.any((city) => city.id == targetCity!.id) ??
                    false)));
          }

          // Met à jour l'état avec les données météo récupérées
          emit(state.copyWith(
            status: MeteoStatus.fetched,
            data: targetCity,
          ));
        } catch (e) {
          // En cas d'erreur, émet un état d'erreur et log l'exception
          emit(state.copyWith(
            status: MeteoStatus.error,
          ));
          log("FetchMeteoEvent Exception :$e");
        }
      }

      // Gestion de l'événement FetchCitiesEvent
      else if (event is FetchCitiesEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("data")) {
          // Récupère les villes favorites depuis le cache
          var oldCitiesRaw = await CacheManager.getData("data");
          cities = meteoListFromJson(oldCitiesRaw.syncData);

          // Met à jour l'état avec la liste des villes favorites
          emit(state.copyWith(
              favoriteCities: cities, status: MeteoStatus.success));
        } else {
          // Si aucune donnée n'est trouvée dans le cache, initialise une liste vide
          emit(state.copyWith(favoriteCities: [], status: MeteoStatus.success));
        }
      }

      // Gestion de l'événement AddCityEvent
      else if (event is AddCityEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("data")) {
          // Récupère les villes favorites existantes depuis le cache
          var oldCitiesRaw = await CacheManager.getData("data");
          cities = meteoListFromJson(oldCitiesRaw.syncData);
        }

        bool alreadyExist = false;
        for (var element in cities) {
          if (element.name == state.data!.name) {
            // Vérifie si la ville est déjà enregistrée dans les favoris
            alreadyExist = true;
            break;
          }
        }

        if (!alreadyExist) {
          // Ajoute la ville actuelle aux favoris si elle n'existe pas déjà
          cities.add(state.data!);
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "data", syncData: jsonEncode(cities));

          // Met à jour le cache avec la nouvelle liste des favoris
          bool done = await CacheManager.setData("data", cacheDBModel);

          if (done) {
            emit(state.copyWith(
                favoriteCities: cities,
                isCitySaved: cities.any((city) => city.id == state.data!.id)));
          }
        }
      }

      // Gestion de l'événement DeleteCityEvent
      else if (event is DeleteCityEvent) {
        // Supprime une ville des favoris en filtrant par ID
        final newCities =
            state.favoriteCities!.where((city) => city.id != event.id).toList();

        if (newCities.length != state.favoriteCities!.length) {
          final cacheDBModel = APICacheDBModel(
            key: "data",
            syncData: jsonEncode(newCities),
          );

          try {
            // Met à jour le cache avec la nouvelle liste après suppression
            final done = await CacheManager.setData("data", cacheDBModel);

            if (done) {
              emit(state.copyWith(
                  favoriteCities: newCities,
                  isCitySaved:
                      newCities.any((city) => city.id == state.data!.id)));
            }
          } catch (e) {
            print("Failed to update cache: $e");
          }
        }
      }

      // Gestion de l'événement ToggleSearching
      else if (event is ToggleSearching) {
        // Change l'état de recherche (actif/inactif)
        emit(state.copyWith(isSearching: !state.isSearching));
      }
    });
  }
}
