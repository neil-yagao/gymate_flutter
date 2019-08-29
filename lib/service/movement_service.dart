import 'package:dio/dio.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/enum_to_string.dart';
import 'package:workout_helper/service/basic_dio.dart';

class MovementService {

  Dio dio = DioInstance.getInstance(null);

  Future<List<Movement>> getMovements(ExerciseType exerciseType) async {
    return dio.get('/movements',queryParameters:{
      "exerciseType": EnumToString.parse(exerciseType)
    }).then((Response rs){
      List<Movement> movements = List();
      (rs.data as List).forEach((value){
        movements.add(Movement.fromJson(value));
      });
      return movements;
    });
  }

  Future<List<MovementOneRepMax>> getMovementOneRepMax(int userId){
    return dio.get('/movements/' + userId.toString() + "/one_rep_max").then((Response r){
      List<MovementOneRepMax> result = List();
      (r.data as List).forEach((value){
        result.add(MovementOneRepMax.fromJson(value));
      });
      return result;
    });

  }
}
