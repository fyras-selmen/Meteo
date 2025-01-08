import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late StreamSubscription connectivitySubscription;

  InternetCubit() : super(InternetInitial()) {
    connectivitySubscription =
        InternetConnectionChecker().onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        emitInternetConnected();
      } else {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected() => emit(InternetConnected());
  void emitInternetDisconnected() => emit(InternetDisconnected());
  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}
