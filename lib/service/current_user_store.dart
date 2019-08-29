import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/entities.dart';

import 'basic_dio.dart';

class CurrentUserStore extends ChangeNotifier {
  Dio dio;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  User currentUser;

  AliCloudOSS _aliCloudOSS = AliCloudOSS();

  CurrentUserStore(this._scaffoldKey) {
    dio = DioInstance.getInstance(_scaffoldKey);
  }

  Future<User> doLogin(String username, String password) async {
    Map<String, dynamic> params = Map();
    params['username'] = username;
    params['password'] = Password.hash(password, PBKDF2());
    Response userResponse;
    try {
      userResponse = await dio.get("/user/login", queryParameters: params);
      currentUser = User.fromJson(userResponse.data);
      notifyListeners();
      return currentUser;
    } catch (error) {
      return null;
    }
  }

  Future<User> register(
      String name, String password, String cell, String verifyCode) async {
    Response register = await dio.post('/user/register', data: {
      'name': name,
      'alias': name,
      'password': Password.hash(password, new PBKDF2()),
      'username': cell,
      'mobile': cell,
      'mobileVerify': verifyCode
    });

    if (register.statusCode == 200) {
      this.currentUser = User.fromJson(register.data);
      notifyListeners();
    }
    return currentUser;
  }

  void setCurrentUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  void updateUserAvatar(File file) async {
    _aliCloudOSS
        .doUpload(currentUser.id.toString(), "avatar", file.path, file)
        .then((String fileLocation) {
      print(fileLocation);
      dio.post("/user/" + currentUser.id.toString() + "/avatar",
          data: {}, queryParameters: {'location': fileLocation});
      currentUser.avatar = fileLocation;
      notifyListeners();
    });
  }
}
