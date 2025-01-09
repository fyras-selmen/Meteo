part of 'meteo_bloc.dart';

enum MeteoStatus { loading, success, error, fetched }

class MeteoState extends Equatable {
  final MeteoStatus status;
  final bool isSearching;
  final bool isCitySaved;
  final Meteo? data;

  final List<Meteo>? favoriteCities;
  const MeteoState(
      {this.status = MeteoStatus.loading,
      this.data,
      this.isSearching = false,
      this.isCitySaved = false,
      this.favoriteCities});

  MeteoState copyWith(
      {MeteoStatus? status,
      int? id,
      Meteo? data,
      bool? isSearching,
      bool? isCitySaved,
      Iterable<City>? cities,
      List<Meteo>? favoriteCities}) {
    return MeteoState(
        status: status ?? this.status,
        data: data ?? this.data,
        isCitySaved: isCitySaved ?? this.isCitySaved,
        isSearching: isSearching ?? this.isSearching,
        favoriteCities: favoriteCities ?? this.favoriteCities);
  }

  @override
  List<Object?> get props =>
      [status, data, favoriteCities, isSearching, isCitySaved];
}
