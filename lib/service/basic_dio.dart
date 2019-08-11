import 'package:dio/dio.dart';

BaseOptions _options = new BaseOptions(
  baseUrl: "http://localhost:8080/api",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

class DioInstance {
  static Dio _dio;

  static void _init() {
    if (_dio == null) {
      _dio = Dio(_options);
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        return options; //continue
      }, onResponse: (Response response) {
        print(response);
        return response; // continue
      }, onError: (DioError e) {
        print("error" + e.toString());
        return e; //continue
      }));
    }
  }

  static Dio getInstance() {
    _init();
    return _dio;
  }
}

