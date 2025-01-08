import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/data/dataProviders/my_dio.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/logic/cubits/internet/internet_cubit.dart';
import 'package:meteo/logic/cubits/splash_screen/splash_screen_cubit.dart';
import 'package:meteo/utils/appNavigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  configureDio();

  KiwiContainer kc = KiwiContainer();
  kc.registerSingleton((c) => MeteoBloc(), name: 'meteoBloc');
  kc.registerSingleton((c) => SplashScreenCubit(), name: 'splashScreenCubit');
  kc.registerSingleton((c) => InternetCubit(), name: 'internetCubit');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService().navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
