import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';

import 'basic_dio.dart';

class SessionService {
  ExerciseDatabase db = ExerciseDatabase();

  Dio dio;

  SessionService(GlobalKey<ScaffoldState> key) {
    dio = DioInstance.getInstance(key);
  }

  Future<Session> createNewSessionFromExercise(
      Exercise exercise, String userId) async {
    if (exercise != null && exercise.id == 'today') {
      return getTodaySession(int.parse(userId));
    }
    return dio
        .post("/session/" + userId, data: generateExerciseTemplate(exercise))
        .then((Response t) {
      Session session = Session();
      session.accomplishedSets = List();
      Exercise matchingExercise =
          toExercise((t.data as Map<String, dynamic>)['matchingExercise']);
      session.matchingExercise = matchingExercise;
      if (session.matchingExercise.plannedSets == null) {
        session.matchingExercise.plannedSets = List();
      }
      session.id = (t.data as Map<String, dynamic>)['id'].toString();
      return session;
    });
  }

  Exercise toExercise(Map<String, dynamic> data) {
    Exercise result = Exercise.fromJson(data);
    result.plannedSets = List();
    if (data['singleMovementSets'] != null) {
      (data['singleMovementSets'] as List).forEach(
          (m) => result.plannedSets.add(SingleMovementSet.fromJson(m)));
    }
    if (data['reduceSets'] != null) {
      (data['reduceSets'] as List)
          .forEach((m) => result.plannedSets.add(ReduceSet.fromJson(m)));
    }
    if (data['giantSets'] != null) {
      (data['giantSets'] as List)
          .forEach((m) => result.plannedSets.add(GiantSet.fromJson(m)));
    }
    if (data['hiitSets'] != null) {
      (data['hiitSets'] as List)
          .forEach((m) => result.plannedSets.add(HIITSet.fromJson(m)));
    }
    if (data['cardioSets'] != null) {
      (data['cardioSets'] as List)
          .forEach((m) => result.plannedSets.add(CardioSet.fromJson(m)));
    }
    result.plannedSets.sort((a, b) => a.sequence.compareTo(b.sequence));
    return result;
  }

  Future<Session> getTodaySession(int userId) async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    UserPlannedExercise plannedExercise =
        await db.queryForPlannedExerciseByUserAndDate(userId, date);
    if (plannedExercise.exercise == null) {
      return null;
    }
    Session session = await createNewSessionFromExercise(
        plannedExercise.exercise, userId.toString());
    session.matchingPlannedExerciseId = plannedExercise.id;
    if (plannedExercise.hasBeenExecuted) {
      session.accomplishedTime = plannedExercise.executeDate;
    }
    return session;
  }

  void saveCompletedSet(Session session, CompletedExerciseSet ces) {
    if (session.accomplishedSets == null) {
      session.accomplishedSets = List();
    }
    ces.completedTime = DateTime.now();
    session.accomplishedSets.add(ces);
  }

  Future<SessionMaterial> addSessionMaterial(SessionMaterial material) {
    return dio.post('/session/' + material.sessionId + "/material",data:material.toJson()).then((r) {
      if (r.data != null) {
        return SessionMaterial.fromJson(r.data);
      }
      throw NullThrownError();
    });
  }

  Future<List<SessionMaterial>> getSessionMaterialsBySessionId(String id) {
    return dio.get('/session/' + id + "/material").then((r) {
      List<SessionMaterial> materials = List();
      if (r.data != null) {
        (r.data as List)
            .forEach((m) => materials.add(SessionMaterial.fromJson(m)));
      }
      return materials;
    });
  }

  Future saveSessionAsTemplate(Exercise exercise, String userId) {
    var exerciseDate = generateExerciseTemplate(exercise);
    return dio.post("/exercise/template/" + userId, data: exerciseDate);
  }

  static LinkedHashMap<Movement, List<ExerciseSet>> groupExerciseSetViaMovement(
      List<ExerciseSet> sets) {
    LinkedHashMap<Movement, List<ExerciseSet>> maps = LinkedHashMap();
    sets.forEach((ExerciseSet es) {
      if (es is SingleMovementSet) {
        if (!maps.containsKey(es.movement)) {
          maps.putIfAbsent(es.movement, () {
            return [];
          });
        }
        maps[es.movement].add(es);
      } else if (es is GiantSet) {
        //giant set
        GiantSet gs = es;
        if (!maps.containsKey(gs.extractMovementBasicInfo())) {
          maps.putIfAbsent(gs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[gs.extractMovementBasicInfo()].add(es);
      } else if (es is HIITSet) {
        HIITSet hs = es;
        if (!maps.containsKey(hs.extractMovementBasicInfo())) {
          maps.putIfAbsent(hs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[hs.extractMovementBasicInfo()].add(hs);
      } else if (es is CardioSet) {
        Movement cardioMovement = Movement.empty();
        cardioMovement.id = uuid.v4();
        cardioMovement.name = es.movementName;
        cardioMovement.exerciseType = ExerciseType.cardio;
        maps[cardioMovement] = [es];
      }
    });
    return maps;
  }

  Future completedSession(Session currentSession, String userId) {
    Map<String, dynamic> data = {
      'id': currentSession.id,
      'matchingExerciseTemplateId': currentSession.matchingExercise.id,
      'matchingExerciseTemplate': {'id': currentSession.matchingExercise.id},
      'accomplishedSets':
          currentSession.accomplishedSets.map((CompletedExerciseSet ces) {
        return {
          'accomplishedSetId': ces.accomplishedSet.id,
          'accomplishedSetType': ces.accomplishedSet.runtimeType.toString(),
          'repeats': ces.repeats,
          'restAfterAccomplished': ces.restAfterAccomplished,
          'weight': ces.weight,
          'completedTime': ces.completedTime.toIso8601String() + "Z"
        };
      }).toList(),
      'accomplishedTime': DateTime.now().toIso8601String() + "Z",
      'matchingPlannedExerciseId': currentSession.matchingPlannedExerciseId
    };
    if (currentSession.matchingPlannedExerciseId != null) {
      db.updateUserPlannedExercise(currentSession.matchingPlannedExerciseId);
    }
    return dio.put("/session/" + userId, data: data);
  }

  ///      'description': exercise.description,
  ///      'singleMovementSets': exercise.plannedSets
  ///          ?.where(
  ///              (ExerciseSet es) => es is SingleMovementSet && !(es is ReduceSet))
  ///          ?.toList(),
  ///      'giantSets': exercise.plannedSets
  ///          ?.where((ExerciseSet es) => es is GiantSet)
  ///          ?.toList(),
  ///      'reduceSets': exercise.plannedSets
  ///          ?.where((ExerciseSet es) => es is ReduceSet)
  ///          ?.toList(),
  ///      'hiitSets': exercise.plannedSets
  ///          ?.where((ExerciseSet es) => es is HIITSet)
  ///          ?.toList(),
  ///      'cardioSets': exercise.plannedSets
  ///          ?.where((ExerciseSet es) => es is CardioSet)
  ///          ?.toList(),
  static Map<String, dynamic> generateExerciseTemplate(Exercise exercise) {
    Map<String, dynamic> data = {
      'muscleTarget': exercise.muscleTarget
          ?.map((MuscleGroup mg) => mg.toString())
          ?.join(","),
      'name': exercise.name,
      'description': exercise.description,
      'recommendRestingTimeBetweenMovement': 45,
    };
    if (exercise.id != null &&
        exercise.id != 'today' &&
        exercise.id != 'randomId') {
      data['id'] = exercise.id;
    }
    return data;
  }

  void removeSession(Session currentSession) {
    if (currentSession == null) {
      return;
    }
    dio.delete("/session/" + currentSession.id);
  }

  Future<List<Session>> getUserCompletedSessions(int userId) async {
    return dio.get('/session/user/' + userId.toString()).then((Response r) {
      List<Session> sessions = List();
      (r.data as List).forEach((value) {
        sessions.add(Session.fromJson(value));
      });
      return sessions;
    });
  }

  Future<List> getUserLatestExerciseDate(List<User> users) {
    return dio.get('/session/latest', queryParameters: {
      "users": users.map((user) => user.id).join(","),
    }).then((r) {
      if (r.data != null) {
        return r.data;
      }
      return List();
    });
  }
}
