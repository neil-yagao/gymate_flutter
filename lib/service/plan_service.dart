import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

import 'basic_dio.dart';

class PlanService {
  Dio instance;

  PlanService(GlobalKey<ScaffoldState> defaultState) {
    instance = DioInstance.getInstance(defaultState);
  }

  Future createTrainingPlan(TrainingPlan tp) {
    return instance.post('/plan', data: {
      'name': tp.name,
      'planGoal': tp.planGoal,
      'schedule':
          tp.schedule.map((Exercise e) => {'id': int.parse(e.id)}).toList(),
      'totalTrainingCycle': tp.totalTrainingCycle,
      'sessionPerTrainingCycle': tp.sessionPerTrainingCycle,
      'trainingCycleDays': tp.trainingCycleDays,
      'extraNote': tp.extraNote,
      'createdBy': tp.createdBy
    }).then((Response t) {
      return t.data as Map<String, dynamic>;
    });
  }

  Future<List<TrainingPlan>> getAllTrainingPlans() {
    return instance.get('/plan').then((Response t) {
      List<TrainingPlan> availablePlans = List();
      (t.data as List)
          .forEach((p) => availablePlans.add(TrainingPlan.fromJson(p)));
      return availablePlans;
    });
  }

  Future<Map<String, Exercise>> applyPlanToUser(
      TrainingPlan selectedPlan, int id) {
    return instance
        .post('/plan/' + selectedPlan.id.toString() + "/apply/" + id.toString())
        .then((Response r) {
      Map<String, Exercise> appliedResult = Map();
      (r.data as List).forEach((d ){
        Exercise exerciseToExecute = Exercise.empty();
        if(d['exercise'] == null){
          exerciseToExecute.id = "resting";
         exerciseToExecute.name = "休息日";
         exerciseToExecute.description = "休息是为了更好的训练，建议进行有氧恢复";
        }else {
          exerciseToExecute = Exercise.fromJson(d['exercise']);
        }
        appliedResult[d['plannedExecutionDate']] = exerciseToExecute;
      });
      print(appliedResult);
      return appliedResult;
    });
  }
}
