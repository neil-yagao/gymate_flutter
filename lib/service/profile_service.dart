import 'package:dio/dio.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/enum_to_string.dart';

import 'basic_dio.dart';

class ProfileService {

  ExerciseDatabase db = ExerciseDatabase();

  Dio dio = DioInstance.getInstance(null);

  Future<List<UserBodyIndex>> loadUserIndexes(String userId) async {
      return db.getUserBodyIndexes(userId);
  }

  void createUserIndex(UserBodyIndex userBodyIndex,String userId){
    dio.post('/body-index/' + userId ,data:{
      'bodyIndex': EnumToString.parse(userBodyIndex.bodyIndex),
      'value':userBodyIndex.value
    });
    db.insertBodyIndex(userBodyIndex,userId);
  }

}