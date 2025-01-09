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
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  configureDio();

  KiwiContainer kc = KiwiContainer();
  kc.registerSingleton((c) => MeteoBloc(), name: 'meteoBloc');
  kc.registerSingleton((c) => SplashScreenCubit(), name: 'splashScreenCubit');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    precacheImage(const AssetImage("assets/icons/logo.png"), context);
    final MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");

    return MaterialApp(
      navigatorKey: NavigationService().navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            BlocProvider.value(value: meteoBloc, child: const SplashScreen()),
        '/home': (context) => BlocProvider.value(
              value: meteoBloc,
              child: const HomeScreen(),
            ),
      },
    );
  }
}
