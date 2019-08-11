import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:workout_helper/model/entities.dart';

import 'basic_dio.dart';

part 'user_persistence_service.g.dart';

class UserPersistenceService = _UserPersistenceService
    with _$UserPersistenceService;

abstract class _UserPersistenceService with Store {
  Dio dio = DioInstance.getInstance();
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @observable
  User currentUser;

  _UserPersistenceService(this._scaffoldKey);

  void doLogin(String username, String password) async {
    Map<String, dynamic> params = Map();
    params['username'] = username;
    params['password'] = password;
    Response<User> userResponse;
    try {
      userResponse =
      await dio.get<User>("/user/login", queryParameters: params);
      currentUser = userResponse.data;

    }catch(error){
      Map<String,dynamic> errorMap = (error as DioError).response.data as Map;
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(errorMap["message"])));
    }
  }
}
