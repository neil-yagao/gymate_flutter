import 'package:uuid/uuid.dart';

class Question {
  final String question;
  final List<String> options;
  String selectedOption;
  bool isMultiple = false;
  Question prev;

  String mark;

  Question(this.question, this.options, this.mark);
}

var uuid = Uuid();

enum SupportedTrainingType { BODYBUILDING, POWERLIFTING, CROSSFIT }
enum MovementType { SINGLE, REDUCE, GIANT }
enum MuscleGroup {
  SHOULDER,
  TRAP,

  CHEST,
  ARM,
  BICEPS,
  TRICEPS,
  FOREARM,

  BACK,
  LATS,
  MIDDLE_BACK,
  LOWER_BACK,

  ABS,

  LEG,
  QUADS,
  GLUTES,
  HAMSTRING,
  CALVES
}

class ExerciseSet {
  String id;
  int sequence;

  ExerciseSet() {
    id = uuid.v4().toString();
  }

  int get hashCode {
    return this.id.hashCode;
  }

  bool operator ==(Object other) {
    if (other is ExerciseSet) {
      return this.id == other.id;
    }
    return false;
  }
}

///单个动作作为一组
class SingleMovementSet extends ExerciseSet {
  Movement movement;

  int expectingRepeatsPerSet;
  double expectingWeight;

  SingleMovementSet(SingleMovementSet set) {
    if (set != null) {
      this.movement = set.movement;
      this.expectingWeight = set.expectingWeight;
      this.expectingRepeatsPerSet = set.expectingRepeatsPerSet;
      this.sequence = set.sequence;
    }
  }
}

abstract class Cloneable<T> {
  void clone(T t);
}

///训练动作
class Movement implements Cloneable<Movement> {
  String id;
  String name;
  String description;
  String picReference;
  String videoReference;

  List<MuscleGroup> involvedMuscle;

  //all time in seconds
  int recommendRestingTimeBetweenSet;

  @override
  String toString() {
    return name;
  }

  @override
  void clone(Movement movement) {
    this.id = movement.id;
    this.name = movement.name;
    this.description = movement.description;
    this.picReference = movement.picReference;
    this.involvedMuscle = movement.involvedMuscle;
    this.recommendRestingTimeBetweenSet =
        movement.recommendRestingTimeBetweenSet;
    this.videoReference = movement.videoReference;
  }

  int get hashCode {
    return this.id.hashCode;
  }

  bool operator ==(Object other) {
    if (other is Movement) {
      return this.id == other.id;
    }
    return false;
  }
}

///递减组
class ReduceSet extends SingleMovementSet {
  double reduceWeight;
  double reduceTo;
  int intervalTime;

  ReduceSet(ReduceSet set) : super(null) {
    if (set != null) {
      this.movement = set.movement;
      this.reduceWeight = set.reduceWeight;
      this.reduceTo = set.reduceTo;
      this.sequence = set.sequence;
    }
  }

  void copyFromRegularSet(SingleMovementSet regularSet) {
    this.expectingRepeatsPerSet = regularSet.expectingRepeatsPerSet;
    this.expectingWeight = regularSet.expectingWeight;
    this.movement = regularSet.movement;
  }
}

///巨人组
class GiantSet extends ExerciseSet {
  Set<SingleMovementSet> movements = Set();
  int intervalTimeSecond;

  GiantSet(GiantSet set) {
    if (set != null) {
      this.movements = set.movements;
      this.intervalTimeSecond = set.intervalTimeSecond;
    }
  }

  Movement extractMovementBasicInfo() {
    Movement combinedMovement = Movement();
    combinedMovement.id =
        movements.map((SingleMovementSet m) => m.movement.id).join('/');
    combinedMovement.name = "超级组：" +
        movements.map((SingleMovementSet m) => m.movement.name).join('/');
    return combinedMovement;
  }
}

///单次训练模板
class Exercise {
  String id;

  List<MuscleGroup> muscleTarget;

  String name;

  String description;

  List<ExerciseSet> plannedSets;

  int recommendRestingTimeBetweenMovement;
}

///训练计划
class TrainingPlan {
  String id;

  List<Exercise> schedule;

  String planGoal;

  SupportedTrainingType planType;

  int totalTrainingWeeks;

  int sessionPerWeek;

  String extraNote;

  String createdBy;
}

///单次训练记录
class Session {
  String id;

  Exercise matchingExercise;

  List<CompletedExerciseSet> accomplishedSets;

  DateTime accomplishedTime;

  Session() {
    matchingExercise = Exercise();
    accomplishedSets = List();
  }
}

///单个动作完成的组数
class CompletedExerciseSet {

  String id;

  ExerciseSet accomplishedSet;

  int repeats;

  ///default using KG
  double weight;

  int restAfterAccomplished;

  DateTime completedTime;

}

class SessionMaterial {

  String id;

  String filePath;

  bool isVideo;

  String sessionId;

  SessionMaterial(){
    id = uuid.v4().toString();
  }

}

