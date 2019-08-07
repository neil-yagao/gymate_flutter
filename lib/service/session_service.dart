import 'dart:collection';

import 'package:uuid/uuid.dart';
import 'package:workout_helper/model/db_models.dart';
import 'package:workout_helper/model/entities.dart' ;

class SessionRepositoryService {
  var _idGenerator = Uuid();

  ExerciseDatabase db = ExerciseDatabase();

  Session createNewSessionFromExercise(Exercise exercise) {
    if (exercise.id == 'today') {
      return getTodaySession();
    }
    var session = Session();
    session.id = _idGenerator.v4();
    session.matchingExercise = exercise;
    if (session.matchingExercise.plannedSets == null) {
      session.matchingExercise.plannedSets = List();
    }
    return session;
  }

  Session createEmptySession() {
    var session = Session();
    session.id = _idGenerator.v4();
    return session;
  }

  ///session is null meaning user do not involved in any plan
  ///if user involved in any plan but today is rest day,
  ///this will return proper resting session
  Session getTodaySession() {
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

  void saveCompletedSet(Session session, CompletedExerciseSet ces){
    if(session.accomplishedSets == null){
      session.accomplishedSets = List();
    }
    ces.completedTime = DateTime.now();
    session.accomplishedSets.add(ces);
  }

  void addSessionMaterial(SessionMaterial material){
    db.addSessionMaterial(material);
  }

  Future<List<SessionMaterial>> getSessionMaterialsBySessionId(String id){
    return db.getSessionMaterialsBySessionId(id);
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
      } else {
        //giant set
        GiantSet gs = es;
        if (!maps.containsKey(gs.extractMovementBasicInfo())) {
          maps.putIfAbsent(gs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[gs.extractMovementBasicInfo()].add(es);
      }
    });
    return maps;
  }
}
