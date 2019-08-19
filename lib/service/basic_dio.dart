import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

BaseOptions _options = new BaseOptions(
  baseUrl: "http://localhost:9090/api",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

class DioInstance {
  static Dio _dio;
  static GlobalKey<ScaffoldState> _scaffoldKey;

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
        print(e);
        if (e.response.data != null) {
          if (_scaffoldKey == null) {
            return null;
          }
          Map<String, dynamic> errorMap = e.response.data as Map;
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(errorMap["message"])));
        }
        return e;
      }));
    }
  }

  static Dio getInstance(GlobalKey<ScaffoldState> defaultState) {
    _scaffoldKey = defaultState;
    _init();
    return _dio;
  }
}
