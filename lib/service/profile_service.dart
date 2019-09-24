import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/enum_to_string.dart';

import 'basic_dio.dart';

class ProfileService {

  ExerciseDatabase db = ExerciseDatabase();

  Dio dio;
  ProfileService(GlobalKey<ScaffoldState> defaultState) {
    dio = DioInstance.getInstance(defaultState);
  }

  Future<List<UserBodyIndex>> loadUserIndexes(String userId) async {
    List<UserBodyIndex> localUserIndexes = List();
    return dio.get('/body-index/' + userId).then((Response t) {
      (t.data as List).forEach((u) {
        UserBodyIndex index = UserBodyIndex.fromJson(u);
        if (index.unit == null) {
          index.unit = mapBodyIndexInfo()[index.bodyIndex].unit;
        }
        localUserIndexes.add(index);
        //db.insertBodyIndex(index, userId);
      });
      return localUserIndexes;
    });
  }

  void createUserIndex(UserBodyIndex userBodyIndex, String userId) {
    dio.post('/body-index/' + userId, data: {
      'bodyIndex': EnumToString.parse(userBodyIndex.bodyIndex),
      'value': userBodyIndex.value
    });
    db.insertBodyIndex(userBodyIndex, userId);
  }

  Future<Map<String, dynamic>> loadUserTrainingService(String userId) async {
    return dio.get("/user/" + userId + "/training_summary").then((Response r) {
      return r.data as Map<String, dynamic>;
    });
  }
}
