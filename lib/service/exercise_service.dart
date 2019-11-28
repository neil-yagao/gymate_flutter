import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/enum_to_string.dart';
import 'package:workout_helper/service/basic_dio.dart';

class ExerciseService {
  Dio dio = DioInstance.getInstance(null);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  ExerciseDatabase db = ExerciseDatabase();

  ExerciseService(this._scaffoldKey);

  Future<List<Exercise>> getUserExerciseTemplate(int userId) {
    return dio
        .get("/exercise/template/" + userId.toString())
        .then((Response r) {
      List<Exercise> template = List();
      (r.data as List).forEach((value) {
        template.add(parseExercise(value));
      });
      return template;
    });
  }


  Future<Exercise> getUserPlannedExercise(userId, date) async{
      UserPlannedExercise plannedExercise = await db.queryForPlannedExerciseByUserAndDate(userId, date);
      if(plannedExercise.exercise == null){
        return null;
      }
      return getExercise(plannedExercise.exercise.id);
  }

  Future<List<ExerciseSet>> appendToExercise(
      Exercise exercise, List<ExerciseSet> ess) {
    List<ExerciseSet> singleMovements = ess
        ?.map((ExerciseSet es) {
          es.id = '';
          return es;
        })
        ?.where(
            (ExerciseSet es) => es is SingleMovementSet && !(es is ReduceSet))
        ?.toList();

    List<ExerciseSet> giantSets =
        ess?.where((ExerciseSet es) => es is GiantSet)?.map((ExerciseSet es) {
      GiantSet gs = GiantSet('', es.sequence, Set<SingleMovementSet>(),
          (es as GiantSet).intervalTimeSecond);
      (es as GiantSet).movements.forEach((SingleMovementSet sms) {
        gs.movements.add(SingleMovementSet('', sms.sequence, sms.movement,
            sms.expectingRepeatsPerSet, sms.expectingWeight, sms.unit));
      });
      return gs;
    })?.toList();

    List<ExerciseSet> reduceSets =
        ess?.where((ExerciseSet es) => es is ReduceSet)?.map((ExerciseSet es) {
      es.id = '';
      return es;
    })?.toList();

    List<ExerciseSet> hiitSets =
        ess?.where((ExerciseSet es) => es is HIITSet)?.map((ExerciseSet es) {
      HIITSet hs = HIITSet('', es.sequence, List<SingleMovementSet>(),
          (es as HIITSet).exerciseTime, (es as HIITSet).restTime);
      (es as HIITSet).movements.forEach((SingleMovementSet sms) {
        hs.movements.add(SingleMovementSet('', sms.sequence, sms.movement,
            sms.expectingRepeatsPerSet, sms.expectingWeight, sms.unit));
      });

      return hs;
    })?.toList();

    List<ExerciseSet> cardioSets =
        ess?.where((ExerciseSet es) => es is CardioSet)?.map((ExerciseSet es) {
      es.id = '';
      return es;
    })?.toList();
    List<Future> futures = [];
    if(exercise.plannedSets == null) {
      exercise.plannedSets = List();
    }
    if (singleMovements.length > 0) {
      futures.add(dio
          .put('/exercise/' + exercise.id + '/single_movements',
              data: singleMovements)
          .then((Response r) {
        (r.data as List<dynamic>).forEach((value) {
          exercise.plannedSets.add(SingleMovementSet.fromJson(value));
        });
        return;
      }));
    }
    if (reduceSets.length > 0) {
      futures.add(dio
          .put('/exercise/' + exercise.id + '/reduce_movements',
              data: reduceSets)
          .then((Response r) {
        (r.data as List<dynamic>).forEach((value) {
          exercise.plannedSets.add(ReduceSet.fromJson(value));
        });
        return;
      }));
    }
    if (giantSets.length > 0) {
      futures.add(dio
          .put('/exercise/' + exercise.id + '/giant_movements', data: giantSets)
          .then((Response r) {
        (r.data as List<dynamic>).forEach((value) {
          exercise.plannedSets.add(GiantSet.fromJson(value));
        });
        return;
      }));
    }
    if (hiitSets.length > 0) {
      futures.add(dio
          .put('/exercise/' + exercise.id + '/hiit_movements', data: hiitSets)
          .then((Response r) {
        (r.data as List<dynamic>).forEach((value) {
          exercise.plannedSets.add(HIITSet.fromJson(value));
        });
        return;
      }));
    }
    if (cardioSets.length > 0) {
      futures.add(dio
          .put('/exercise/' + exercise.id + '/cardio_movements',
              data: cardioSets)
          .then((Response r) {
        (r.data as List<dynamic>).forEach((value) {
          exercise.plannedSets.add(CardioSet.fromJson(value));
        });
        return;
      }));
    }
    return Future.wait(futures).then((_) {
      return exercise.plannedSets;
    });
  }

  Future removeFromExercise(Exercise exercise, List<ExerciseSet> ess) {
    Map<String, List<int>> deletingExercises = Map();
    ess.forEach((es) {
      if (es is SingleMovementSet) {
        if (deletingExercises["single"] == null) {
          deletingExercises["single"] = [];
        }
        deletingExercises['single'].add(int.parse(es.id));
      }
      if (es is ReduceSet) {
        if (deletingExercises["reduce"] == null) {
          deletingExercises["reduce"] = [];
        }
        deletingExercises['reduce'].add(int.parse(es.id));
      }
      if (es is GiantSet) {
        if (deletingExercises["giant"] == null) {
          deletingExercises["giant"] = [];
        }
        deletingExercises['giant'].add(int.parse(es.id));
      }
      if (es is HIITSet) {
        if (deletingExercises["hiit"] == null) {
          deletingExercises["hiit"] = [];
        }
        deletingExercises['hiit'].add(int.parse(es.id));
      }
      if (es is CardioSet) {
        if (deletingExercises["cardio"] == null) {
          deletingExercises["cardio"] = [];
        }
        deletingExercises['cardio'].add(int.parse(es.id));
      }
    });
    return dio
        .delete("/exercise/" + exercise.id + "/sets", data: deletingExercises)
        .then((_) {
      exercise.plannedSets.removeWhere((ExerciseSet es) {
        return ess.indexOf(es) >= 0;
      });
    });
  }

  static Exercise parseExercise(Map<String, dynamic> map) {
    Exercise exercise = Exercise.empty();
    exercise.id = map['id'].toString();
    exercise.name = map['name'];
    List<MuscleGroup> muscleGroup = List();
    ((map['muscleTarget'] as String).split(","))?.forEach(
        (e) => muscleGroup.add(EnumToString.fromString(MuscleGroup.values, e)));
    exercise.muscleTarget = muscleGroup;
    exercise.description = map['description'];
    exercise.recommendRestingTimeBetweenMovement =
        map['recommendRestingTimeBetweenMovement'];
    exercise.plannedSets = List();
    //singleMovementSets，giantSets，reduceSets，hiitSets，cardioSets
    (map['singleMovementSets'] as List).forEach((es) {
      exercise.plannedSets.add(SingleMovementSet.fromJson(es));
    });
    (map['giantSets'] as List).forEach((es) {
      exercise.plannedSets.add(GiantSet.fromJson(es));
    });
    (map['reduceSets'] as List).forEach((es) {
      exercise.plannedSets.add(ReduceSet.fromJson(es));
    });
    (map['hiitSets'] as List).forEach((es) {
      exercise.plannedSets.add(HIITSet.fromJson(es));
    });
    (map['cardioSets'] as List).forEach((es) {
      exercise.plannedSets.add(CardioSet.fromJson(es));
    });
    return exercise;
  }

  Future shareExerciseTo(Exercise exercise,int from,String to){
    return dio.put('/exercise/share/' + from.toString() + "/" + to,data: {
      'id':exercise.id
    });
  }

  Future<Exercise> getExercise(String exerciseId){
    return dio.get('/exercise/' + exerciseId).then((r){
      if(r.data != null){
        return parseExercise(r.data);
      }
      return Exercise.empty();
    });
  }
}
