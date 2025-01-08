import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/logic/cubits/internet/internet_cubit.dart';
import 'package:meteo/utils/appNavigator.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(const SplashScreenLoading()) {
    KiwiContainer kc = KiwiContainer();

    final InternetCubit internetCubit = kc.resolve("internetCubit");
    final MeteoBloc meteoBloc = kc.resolve("meteoBloc");

    try {
      internetCubit.stream.listen((event) async {
        if (event is InternetConnected) {
          var currentLocation = await getCurrentLocation();
          if (currentLocation != null) {
            meteoBloc.add(FetchMeteoEvent(
                long: currentLocation.longitude,
                lat: currentLocation.latitude));
          }
          meteoBloc.add(const FetchCitiesEvent());
          meteoBloc.stream.listen((state) async {
            if (state.status == MeteoStatus.success) {
              emit(const SplashScreenLoaded());
              NavigationService().navigateTo('/home');
            } else if (state.status == MeteoStatus.error) {
              /*    await Fluttertoast.showToast(
                  msg: "Failed to load data. Please try again.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0); */
              NavigationService().navigateTo('/home');
            }
          });
        } else {
          emit(const SplashScreenLoading());
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
