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
      'createdBy': {'id': tp.createdBy}
    }).then((Response t) {
      return t.data as Map<String, dynamic>;
    });
  }
}
