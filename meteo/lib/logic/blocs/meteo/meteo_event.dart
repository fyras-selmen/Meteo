part of 'meteo_bloc.dart';

sealed class MeteoEvent extends Equatable {
  const MeteoEvent();
}

class FetchMeteoEvent extends MeteoEvent {
  final double long;
  final double lat;
  final int id;
  const FetchMeteoEvent(
      {required this.long, required this.lat, required this.id});

  @override
  List<Object?> get props => [long, lat, id];
}

class FetchCitiesEvent extends MeteoEvent {
  const FetchCitiesEvent();

  @override
  List<Object?> get props => [];
}

class AddCityEvent extends MeteoEvent {
  const AddCityEvent();

  @override
  List<Object?> get props => [];
}

class DeleteCityEvent extends MeteoEvent {
  final int id;
  const DeleteCityEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
