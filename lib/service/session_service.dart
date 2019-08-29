import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart';

import 'basic_dio.dart';

class SessionService {
  ExerciseDatabase db = ExerciseDatabase();

  Dio dio = DioInstance.getInstance(null);

  Future<Session> createNewSessionFromExercise(
      Exercise exercise, String userId) async {
    if (exercise.id == 'today') {
      return getTodaySession();
    }
    return dio
        .post("/session/" + userId, data: generateExerciseTemplate(exercise))
        .then((Response t) {
      Session session = Session();
      session.accomplishedSets = List();
      exercise.id =
          (t.data as Map<String, dynamic>)['matchingExercise']['id'].toString();
      session.matchingExercise = exercise;
      if (session.matchingExercise.plannedSets == null) {
        session.matchingExercise.plannedSets = List();
      }
      session.id = (t.data as Map<String, dynamic>)['id'].toString();
      return session;
    });
  }

  ///session is null meaning user do not involved in any plan
  ///if user involved in any plan but today is rest day,
  ///this will return proper resting session
  Future<Session> getTodaySession() async {
    return null;
//    Session session = Session();
//    session.id = _idGenerator.v4();
//    session.matchingExercise = Exercise();
//    session.matchingExercise.name = "腿部训练";
//    session.matchingExercise.description = "一共五个动作，共20组，约耗时40分钟";
//    if (session.matchingExercise.plannedSets == null) {
//      session.matchingExercise.plannedSets = List();
//    }
//    return session;
  }

  void saveCompletedSet(Session session, CompletedExerciseSet ces) {
    if (session.accomplishedSets == null) {
      session.accomplishedSets = List();
    }
    ces.completedTime = DateTime.now();
    session.accomplishedSets.add(ces);
  }

  void addSessionMaterial(SessionMaterial material) {
    db.addSessionMaterial(material);
  }

  Future<List<SessionMaterial>> getSessionMaterialsBySessionId(String id) {
    return db.getSessionMaterialsBySessionId(id);
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
      'id':currentSession.id,
      'matchingExerciseTemplateId':currentSession.matchingExercise.id,
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
    };

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
    if(currentSession == null){
      return;
    }
    dio.delete("/session/" + currentSession.id);
  }

  Future<List<Session>> getUserCompletedSessions(int userId) async {
    return dio.get('/session/user/' + userId.toString()).then((Response r){
      List<Session> sessions = List();
      (r.data as List).forEach((value){
        sessions.add(Session.fromJson(value));
      });
      return sessions;
    });
  }
}
