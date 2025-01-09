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

const String apiKey = '8d9b31bca6d4e1fc33a7137f179099de';
