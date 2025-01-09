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

    // Variable pour éviter de déclencher plusieurs fois la logique
    var triggered = false;

    try {
      // Déclenche l'événement pour récupérer les villes favorites
      meteoBloc.add(const FetchCitiesEvent());

      // Écoute les changements d'état du MeteoBloc
      meteoBlocSubscription = meteoBloc.stream.listen((state) async {
        if (!triggered) {
          triggered =
              true; // Marque comme déclenché pour éviter les répétitions
          var currentLocation = await getCurrentLocation();
          // Vérifie si des données sont disponibles dans le cache
          if (await CacheManager.containsKey("data")) {
            if (meteoBloc.state.status == MeteoStatus.success) {
              // Si des villes favorites existent, récupère les données météo pour la dernière ville
              if (meteoBloc.state.favoriteCities!.isNotEmpty) {
                meteoBloc.add(FetchMeteoEvent(
                    id: meteoBloc.state.favoriteCities!.last.id,
                    long: 0,
                    lat: 0));
              } else {
                // Sinon, récupère la localisation actuelle et utilise-la pour obtenir les données météo

                if (currentLocation != null) {
                  meteoBloc.add(FetchMeteoEvent(
                      id: 0,
                      long: currentLocation.longitude,
                      lat: currentLocation.latitude));
                }
              }
            }
          } else {
            // Si aucune donnée n'est trouvée dans le cache, utilise la localisation actuelle

            if (currentLocation != null) {
              meteoBloc.add(FetchMeteoEvent(
                  id: 0,
                  long: currentLocation.longitude,
                  lat: currentLocation.latitude));
            }
          }
        }

        // Si les données météo ont été récupérées avec succès, navigue vers l'écran d'accueil
        if (meteoBloc.state.status == MeteoStatus.fetched) {
          NavigationService().replaceTo('/home');
          meteoBlocSubscription!
              .cancel(); // Annule l'abonnement au flux pour éviter d'autres écoutes
        }
      });
    } catch (exception) {
      // Log l'exception en cas d'erreur
      log(exception.toString());
    }
  }

  // Méthode pour obtenir la position actuelle de l'utilisateur
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // Retourne null si le service est désactivé
    }

    // Vérifie et demande les permissions de localisation si nécessaire
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Retourne null si les permissions sont refusées
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // Retourne null si les permissions sont refusées de manière permanente
    }

    // Retourne la position actuelle si toutes les conditions sont remplies
    return await Geolocator.getCurrentPosition();
  }
}
