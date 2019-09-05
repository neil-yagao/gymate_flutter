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
      'totalrainingCycle': tp.totalTrainingCycle,
      'sessionPerTrainingCycle': tp.sessionPerTrainingCycle,
      'trainingCycleDays': tp.trainingCycleDays,
      'extraNote': tp.extraNote,
      'createdBy': {'id': tp.createdBy.id}
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
}
