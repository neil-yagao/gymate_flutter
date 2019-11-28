import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//const String BASE_URL = "http://192.168.3.197:9090";
const String BASE_URL = "http://192.168.10.144:9090";
BaseOptions _options = new BaseOptions(
  baseUrl: BASE_URL + "/api",
//  baseUrl: 'https://www.lifting.ren/api',
  connectTimeout: 20000,
  receiveTimeout: 20000,
);

class DioInstance {
  static Dio _dio;
  static GlobalKey<ScaffoldState> _scaffoldKey;

  static int DEFAULT_PAGE_SIZE = 10;

  static void _init() {
    if (_dio == null) {
      _dio = Dio(_options);
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        return options; //continue
      }, onResponse: (Response response) {
        debugPrint("response from request: " + response.request.uri.toString());
        return response; // continue
      }, onError: (DioError e) {
        debugPrint(e.toString());
        if (_scaffoldKey == null) {
          return null;
        }
        if (e.response != null && e.response.data != null) {
          Map<String, dynamic> errorMap = e.response.data as Map;
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(errorMap["message"])));
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("网络出现问题" + e.response?.data?.toString())));
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
