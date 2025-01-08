part of 'splash_screen_cubit.dart';

sealed class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashScreenLoading extends SplashScreenState {
  const SplashScreenLoading();

  @override
  List<Object> get props => [];
}

class SplashScreenFetchingWeather extends SplashScreenState {
  const SplashScreenFetchingWeather();

  @override
  List<Object> get props => [];
}

class SplashScreenLoaded extends SplashScreenState {
  const SplashScreenLoaded();

  @override
  List<Object> get props => [];
}
