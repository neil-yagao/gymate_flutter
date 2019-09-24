import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/nutrition_preference.dart';

import 'basic_dio.dart';

class NutritionService {
  Dio dio;

  NutritionService(GlobalKey<ScaffoldState> _scaffoldKey){
    dio = DioInstance.getInstance(_scaffoldKey);
  }

  Dio instance = DioInstance.getInstance(null);

  Future<UserNutritionPreference> getUserNutritionPreference(int userId) async {
    return instance.get("/nutrition/" + userId.toString() + "/preference",
        queryParameters: {
          'dayOfTheWeek': DateFormat("EEE").format(DateTime.now()),
        }).then((Response t) {
      if (t.data == "") {
        return null;
      }
      return UserNutritionPreference.fromJson(t.data);
    });
  }

  Future<UserNutritionPreference> createUserNutritionPreference(
      UserNutritionPreference preference) async {
    return instance
        .post("/nutrition/" + preference.user.id.toString() + "/preference",
            data: preference)
        .then((Response t) {
      return UserNutritionPreference.fromJson(t.data);
    });
  }

  Future<List<NutritionRecord>> fetchSuggestionDivision(
      UserNutritionPreference nutritionPreference) async {
    return instance.get(
        "/nutrition/" + nutritionPreference.id.toString() + "/division",
        queryParameters: {
          "dayOfTheWeek": DateFormat("EEE").format(DateTime.now()),
          "userId": nutritionPreference.user.id
        }).then((Response t) {
      List<NutritionRecord> suggestedRecords = List();
      if (t.data is List) {
        (t.data as List).forEach((val) {
          suggestedRecords.add(NutritionRecord.fromJson(val));
        });
      }
      return suggestedRecords;
    });
  }

  Future<NutritionRecord> saveNutritionRecord(
      int userId, NutritionRecord nutritionRecord) {
    return instance
        .post("/nutrition/" + userId.toString() + "/", data: nutritionRecord)
        .then((Response t) {
      if (t.data is Map<String, dynamic>) {
        return NutritionRecord.fromJson(t.data);
      }
      return null;
    });
  }

  Future<List<NutritionRecord>> getUserNutritionRecord(int userId){
    return instance.get('/nutrition/records/' + userId.toString()).then((res){
      List<NutritionRecord> records = List();
      if(res.data != null){
        (res.data as List).forEach((val){
          records.add(NutritionRecord.fromJson(val));
        });
      }
      return records;
    });
  }
}
