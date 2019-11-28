import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_entites.dart';

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
      return User.empty();
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
      debugPrint(fileLocation);
      dio.post("/user/" + currentUser.id.toString() + "/avatar",
          data: {}, queryParameters: {'location': fileLocation});
      currentUser.avatar = fileLocation;
      notifyListeners();
    });
  }

  Future<UserGroup> createTrainingGroup(String name, String code) async {
    return dio.post('/user-group/', data: {
      'name': name,
      'code': code,
      'createdBy': {'id': currentUser.id}
    }).then((r) {
      if (r.data != null) {
        Map<String, dynamic> groupJson = r.data as Map<String, dynamic>;
        UserGroup group =
            UserGroup(groupJson['id'], groupJson['name'], groupJson['code']);
        currentUser.groupName = group.name;
        group.groupUserNumber = 1;
        notifyListeners();
        return group;
      }
      throw NullThrownError();
    });
  }

  Future<List<UserGroup>> getCurrentUserGroup() {
    return dio.get('/user-group/' + currentUser.id.toString()).then((r) {
      List<UserGroup> userGroups = List();
      if (r.data != null) {
        (r.data as List).forEach((g) {
          Map<String, dynamic> groupJson = g as Map<String, dynamic>;
          UserGroup group =
              UserGroup(groupJson['id'], groupJson['name'], groupJson['code']);
          group.groupUserNumber = groupJson['groupUserNumber'];
          userGroups.add(group);
        });
      }
      return userGroups;
    });
  }

  Future<UserGroup> joinGroup(String code) async {
    return dio
        .put('/user-group/' + code + "/" + currentUser.id.toString())
        .then((r) {
      if (r.data != null) {
        Map<String, dynamic> groupJson = r.data as Map<String, dynamic>;
        UserGroup group =
            UserGroup(groupJson['id'], groupJson['name'], groupJson['code']);
        currentUser.groupName = group.name;
        group.groupUserNumber = 1;
        notifyListeners();
        return group;
      }
      throw NullThrownError();
    }).catchError((error) {
      throw error;
    });
  }

  Future<List<User>> getGroupUsers(int groupId) async {
    return dio.get('/user-group/' + groupId.toString() + "/users").then((r) {
      List<User> users = List();
      if (r.data != null) {
        (r.data as List).forEach((user) {
          users.add(User.fromJson(user));
        });
      }
      return users;
    });
  }

  static Widget getAvatar(User currentUser,{double size = 40.0}) {
    if (currentUser.avatar != null) {
      return CircleAvatar(
        radius: size,
        backgroundImage: NetworkImage(currentUser.avatar),
      );
    } else {
      return CircleAvatar(
        radius: size,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/default_header.png"),
      );
    }
  }

  Future updateCustomMotto(File file) async {
    _aliCloudOSS
        .doUpload(currentUser.id.toString(), "custom_motto", file.path, file)
        .then((String fileLocation) {
      dio.post("/user/" + currentUser.id.toString() + "/custom_motto",
          data: {}, queryParameters: {'location': fileLocation});
      currentUser.customizeMotto = fileLocation;
      notifyListeners();
    });
  }
}
