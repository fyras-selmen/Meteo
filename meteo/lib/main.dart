import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/data/dataProviders/my_dio.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/logic/cubits/splash_screen/splash_screen_cubit.dart';
import 'package:meteo/presentation/home_screen/home_screen.dart';
import 'package:meteo/presentation/splash_screen/splash_screen.dart';
import 'package:meteo/utils/appNavigator.dart';

Future<void> main() async {
  // Assure que les widgets Flutter sont initialisés avant d'exécuter l'application
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise la taille de l'écran pour une mise en page réactive
  await ScreenUtil.ensureScreenSize();

  // Configure Dio pour les appels API
  configureDio();

  // Configure le conteneur Kiwi pour l'injection de dépendances
  KiwiContainer kc = KiwiContainer();
  kc.registerSingleton((c) => MeteoBloc(),
      name: 'meteoBloc'); // Enregistre MeteoBloc comme singleton
  kc.registerSingleton((c) => SplashScreenCubit(),
      name:
          'splashScreenCubit'); // Enregistre SplashScreenCubit comme singleton

  // Lance l'application Flutter
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise ScreenUtil pour la mise en page réactive avec une taille de design spécifique
    ScreenUtil.init(context, designSize: const Size(360, 690));

    // Précharge une image pour améliorer les performances (évite le chargement tardif)
    precacheImage(const AssetImage("assets/icons/logo.png"), context);

    // Récupère l'instance de MeteoBloc depuis le conteneur Kiwi
    final MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");

    return MaterialApp(
      navigatorKey: NavigationService()
          .navigatorKey, // Définit la clé du navigateur pour la navigation globale
      initialRoute: '/', // Définit la route initiale de l'application
      routes: {
        '/': (context) =>
            BlocProvider.value(value: meteoBloc, child: const SplashScreen()),
        // Fournit MeteoBloc au SplashScreen via BlocProvider

        '/home': (context) => BlocProvider.value(
              value: meteoBloc,
              child: const HomeScreen(),
            ),
        // Fournit MeteoBloc au HomeScreen via BlocProvider
      },
    );
  }
}
