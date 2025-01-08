import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
  validateStatus: (_) {
    return true;
  },
));

void configureDio() {
  dio.options.contentType = "application/json";
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
}
