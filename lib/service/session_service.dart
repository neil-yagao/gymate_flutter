import 'package:workout_helper/model/entities.dart';
import 'package:uuid/uuid.dart';

class SessionRepositoryService {

  var _idGenerator =  Uuid();

  Session createNewSessionFromExercise(Exercise exercise){
    if(exercise.id == 'today'){
      return getTodaySession();
    }
    var session =  Session();
    session.id = _idGenerator.v4();
    session.matchingExercise = exercise;
    if(session.matchingExercise.plannedSets == null){
      session.matchingExercise.plannedSets =  List();
    }
    return session;
  }

  Session createEmptySession(){
    var session =  Session();
    session.id = _idGenerator.v4();
    return session;
  }

  Session getTodaySession(){
    Session session =  Session();
    session.id = _idGenerator.v4();
    session.matchingExercise = Exercise();
    session.matchingExercise.name = "腿部训练";
    session.matchingExercise.description = "一共五个动作，共20组，约耗时40分钟";
    if(session.matchingExercise.plannedSets == null){
      session.matchingExercise.plannedSets =  List();
    }
    return session;
  }
}