part of 'meteo_bloc.dart';

enum MeteoStatus { loading, success, error, searching }

class MeteoState extends Equatable {
  final MeteoStatus status;

  final Meteo? data;
  final Iterable<City>? cities;
  final List<Meteo>? favoriteCities;
  const MeteoState(
      {this.status = MeteoStatus.loading,
      this.data,
      this.cities,
      this.favoriteCities});

  MeteoState copyWith(
      {MeteoStatus? status,
      int? id,
      Meteo? data,
      Iterable<City>? cities,
      List<Meteo>? favoriteCities}) {
    return MeteoState(
        status: status ?? this.status,
        data: data ?? this.data,
        cities: cities ?? this.cities,
        favoriteCities: favoriteCities ?? this.favoriteCities);
  }

  @override
  List<Object?> get props => [status, data, cities, favoriteCities];
}
