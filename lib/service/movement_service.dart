import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/enum_to_string.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/service/basic_dio.dart';

class MovementService {
  Dio dio;

  MovementService(GlobalKey<ScaffoldState> _scaffoldKey) {
    dio = DioInstance.getInstance(_scaffoldKey);
  }

  Future<List<Movement>> getMovements(ExerciseType exerciseType) async {
    return dio.get('/movements', queryParameters: {
      "exerciseType":
          exerciseType == null ? "all" : EnumToString.parse(exerciseType)
    }).then((Response rs) {
      List<Movement> movements = List();
      (rs.data as List).forEach((value) {
        movements.add(Movement.fromJson(value));
      });
      return movements;
    });
  }

  Future<List<MovementOneRepMax>> getUserMovementOneRepMaxRecorders(int userId) {
    return dio
        .get('/movements/' + userId.toString() + "/one_rep_max")
        .then((Response r) {
      List<MovementOneRepMax> result = List();
      (r.data as List).forEach((value) {
        result.add(MovementOneRepMax.fromJson(value));
      });
      return result;
    });
  }

  Future<MovementOneRepMax> getMovementOneRepMax(int recordId) {
    return dio.get("/movements/one_rep_max/" + recordId.toString()).then((res) {
      if (res.data != null) {
        return MovementOneRepMax.fromJson(res.data);
      }
      return null;
    });
  }

  Future<List<MovementMaterial>> getMovementMaterials(String movementId) {
    return dio.get('/movements/' + movementId + '/materials').then((res) {
      List<MovementMaterial> materials = List();
      if (res.data != null) {
        (res.data as List).forEach((t) {
          materials.add(MovementMaterial.fromJson(t));
        });
      }
      return materials;
    });
  }

  Future<MovementMaterial> getMovementMaterial(int id) {
    return dio.get('/movements/material/' + id.toString()).then((res) {
      if (res.data != null) {
        return MovementMaterial.fromJson(res.data);
      }
      return null;
    });
  }

  Future<MovementMaterial> uploadMovementMaterial(
      MovementMaterial material) async {
    return dio
        .post('/movements/material/', data: material.toJson())
        .then((res) {
      if (res.data != null) {
        return MovementMaterial.fromJson(res.data);
      }
      return null;
    });
  }

  Future<UserMovementMaterial> getUserMovementMaterial(int id){
    return dio.get('/movements/user_material/' + id.toString()).then((r){
      if(r.data != null){
        return UserMovementMaterial.fromJson(r.data);
      }
      return null;
    });
  }
}
