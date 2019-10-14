import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/plan_service.dart';

import '../execise_info.dart';
import 'exercise_calendar.dart';

class HomeCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeCalendarState();
  }
}

class HomeCalendarState extends State<HomeCalendar> {
  Map<DateTime, List<UserPlannedExercise>> _markedDatesMap = Map();

  PlanService _planService = PlanService(null);
  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;

    _planService
        .getUserPlannedExercise(_currentUser.id)
        .then((List<UserPlannedExercise> plannedExercises) {
      setState(() {
        plannedExercises.forEach((UserPlannedExercise e) {
          _markedDatesMap[e.executeDate] = [e];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExerciseCalendar(
      markedDatesMap: _markedDatesMap,
      onDateSelect: (List<UserPlannedExercise> exercises) {
        if (exercises.isEmpty) {
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ExerciseInfo(
            plannedExercise: exercises,
          );
        }));
      },
    );
  }
}
