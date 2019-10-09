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
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return dio.post("/session/user/" + userId,
        data: generateExerciseTemplate(exercise),
        queryParameters: {'session_date': date}).then((Response t) {
      return extraToSession(t);
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

  Future<Session> getTodaySession(int userId, {bool createNew = true}) async {
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

  Future saveCompletedSet(Session session, CompletedExerciseSet ces) async {
    if (session.accomplishedSets == null) {
      session.accomplishedSets = List();
    }
    ces.completedTime = DateTime.now();
    CompletedExerciseSet previous = session.accomplishedSets.firstWhere(
        (set) => set.accomplishedSet.id == ces.accomplishedSet.id,
        orElse: () => CompletedExerciseSet.empty());
    if (previous.id == null) {
      session.accomplishedSets.add(ces);
    } else {
      int index = session.accomplishedSets.indexOf(previous);
      session.accomplishedSets[index] = ces;
    }
    return dio.post('/session/' + session.id + "/exerciseSet",
        data: cesToJson(ces));
  }

  Future<SessionMaterial> addSessionMaterial(SessionMaterial material) {
    return dio
        .post('/session/' + material.sessionId + "/material",
            data: material.toJson())
        .then((r) {
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

  Future completeSessionExercise(String sessionId, CompletedExerciseSet set) {
    return dio.post("/session/" + sessionId + "/exerciseSet",
        data: cesToJson(set));
  }

  Future completedSession(Session currentSession) {
    Map<String, dynamic> data = {
      'id': currentSession.id,
      'matchingExerciseTemplateId': currentSession.matchingExercise.id,
      'matchingExerciseTemplate': {'id': currentSession.matchingExercise.id},
      'accomplishedSets':
          currentSession.accomplishedSets.map((CompletedExerciseSet ces) {
        return cesToJson(ces);
      }).toList(),
      'accomplishedTime': DateTime.now().toIso8601String() + "Z",
      'matchingPlannedExerciseId': currentSession.matchingPlannedExerciseId
    };
    if (currentSession.matchingPlannedExerciseId != null) {
      db.updateUserPlannedExercise(currentSession.matchingPlannedExerciseId);
    }
    return dio.put("/session/" + currentSession.id, data: data);
  }

  Map<String, Object> cesToJson(CompletedExerciseSet ces) {
    return {
      'accomplishedSetId': ces.accomplishedSet.id,
      'accomplishedSetType': ces.accomplishedSet.runtimeType.toString(),
      'repeats': ces.repeats,
      'restAfterAccomplished': ces.restAfterAccomplished,
      'weight': ces.weight,
      'completedTime': ces.completedTime.toIso8601String() + "Z"
    };
  }

  CompletedExerciseSet fromJsonToPartial(Map<String, Object> json) {
    CompletedExerciseSet ces = CompletedExerciseSet(
        json['id'],
        null,
        json['repeats'],
        json['weight'],
        json['restAfterAccomplished'],
        DateTime.parse(json['completedTime']));

    ///since we only need the id of the accomplish set
    ces.accomplishedSet = SingleMovementSet.empty();
    ces.accomplishedSet.id = json['accomplishedSetId'];
    return ces;
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

  Future<Session> recoverSession(int currentSessionId) {
    return dio.get('/session/' + currentSessionId.toString()).then((r) {
      Session session = extraToSession(r);

      return session;
    });
  }

  Session extraToSession(Response t) {
    Session session = Session();
    session.accomplishedSets = List();
    Exercise matchingExercise =
        toExercise((t.data as Map<String, dynamic>)['matchingExercise']);
    session.matchingExercise = matchingExercise;
    if (session.matchingExercise.plannedSets == null) {
      session.matchingExercise.plannedSets = List();
    }
    var sets = (t.data as Map<String, dynamic>)['accomplishedSets'];
    if (sets is List && sets.isNotEmpty) {
      sets.forEach((set) {
        session.accomplishedSets.add(fromJsonToPartial(set));
      });
    }
    session.id = (t.data as Map<String, dynamic>)['id'].toString();
    return session;
  }

  Future<List<Map<String,dynamic>>> getGroupSessionReport(String userIds,
      DateTime startTime, DateTime endTime) async{
    return dio.get("/session/group-summary",queryParameters: {
      'userIds':userIds,
      'startTime':startTime.toIso8601String()+ "Z",
      'endTime':endTime.toIso8601String()+ "Z"
    }).then((res){
      if(res.data != null){
        return (res.data as List).map((v)=> v as Map<String,dynamic>).toList();
      }
      return [];
    });
  }
}
