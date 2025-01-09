import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/logic/cubits/splash_screen/splash_screen_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/background.jpg"), context);
    final SplashScreenCubit splashScreenCubit = SplashScreenCubit();
    return Scaffold(
      body: BlocBuilder<SplashScreenCubit, SplashScreenState>(
        bloc: splashScreenCubit,
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(46.0),
                    child: Image.asset(
                      'assets/icons/logo.png',
                    ),
                  ),
                  const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
