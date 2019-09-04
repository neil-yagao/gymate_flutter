import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'entities.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
class Question {
  final String question;
  final List<String> options;
  String selectedOption;
  bool isMultiple = false;
  Question prev;

  String mark;

  Question(this.question, this.options, this.mark);
}

@JsonSerializable()
class User {
  int id;
  String name;
  String alias;
  String token;
  String avatar;
  String groupName;

  User(this.id, this.name, this.alias, this.token, this.avatar, this.groupName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
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

enum BodyIndex {
  /**
   * 体脂
   * 单位：Percentage
   */
  BODY_FAT,

  /**
      体重
      单位：KG
   */
  WEIGHT,

  /**
      身高
      单位：cm
   */
  HEIGHT,

  /**
      臂围
      单位：cm
   */
  ARM_RADIUS,

  /**
      大腿围
      单位：cm
   */
  LEG_RADIUS,

  /**
      腰围
      单位：cm
   */
  ABS_RADIUS,

  /**
      臀围
      单位：cm
   */
  GLUTES_RADIUS,

  /**
      胸围
      单位：cm
   */
  CHEST_RADIUS,

  AGE
}

@JsonSerializable()
class UserBodyIndex {
  BodyIndex bodyIndex;
  double value;
  String unit;
  DateTime recordTime;

  UserBodyIndex(this.bodyIndex, this.value, this.unit, this.recordTime);

  factory UserBodyIndex.fromJson(Map<String, dynamic> json) =>
      _$UserBodyIndexFromJson(json);

  Map<String, dynamic> toJson() => _$UserBodyIndexToJson(this);
}

abstract class ExerciseSet {
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

  Map<String, dynamic> toJson();
}

///单个动作作为一组
class SingleMovementSet extends ExerciseSet {
  Movement movement;

  int expectingRepeatsPerSet;
  double expectingWeight;

  factory SingleMovementSet.fromJson(Map<String, dynamic> json) =>
      _$SingleMovementSetFromJson(json);

  Map<String, dynamic> toJson() => _$SingleMovementSetToJson(this);

  SingleMovementSet(String id, int sequence, this.movement,
      this.expectingRepeatsPerSet, this.expectingWeight) {
    this.id = id;
    this.sequence = sequence;
  }

  SingleMovementSet.fromOther(SingleMovementSet set) {
    if (set != null) {
      this.movement = set.movement;
      this.expectingWeight = set.expectingWeight;
      this.expectingRepeatsPerSet = set.expectingRepeatsPerSet;
      this.sequence = set.sequence;
    }
  }

  SingleMovementSet.defaultZero();

  @override
  bool operator ==(Object other) {
    if (other is SingleMovementSet) {
      return this.id == other.id && this.movement == other.movement;
    }
    return false;
  }

  @override
  int get hashCode {
    return this.id.hashCode;
  }
}

abstract class Cloneable<T> {
  void clone(T t);
}

enum ExerciseType { lifting, hiit, cardio }

///训练动作
@JsonSerializable()
class Movement implements Cloneable<Movement> {
  String id;
  String name;
  String description;
  String picReference;
  String videoReference;

  ExerciseType exerciseType;

  List<MuscleGroup> involvedMuscle;

  //all time in seconds
  int recommendRestingTimeBetweenSet;

  Movement(
      this.id,
      this.name,
      this.description,
      this.picReference,
      this.videoReference,
      this.exerciseType,
      this.involvedMuscle,
      this.recommendRestingTimeBetweenSet);

  Movement.empty();

  factory Movement.fromJson(Map<String, dynamic> json) =>
      _$MovementFromJson(json);

  Map<String, dynamic> toJson() => _$MovementToJson(this);

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
      return this.id == other.id && this.name == other.name;
    }
    return false;
  }
}

///递减组
@JsonSerializable()
class ReduceSet extends SingleMovementSet {
  double reduceWeight;
  double reduceTo;
  int intervalTime;

  ReduceSet(
      String id,
      int sequence,
      Movement movement,
      int expectingRepeatsPerSet,
      double expectingWeight,
      this.reduceWeight,
      this.reduceTo,
      this.intervalTime)
      : super(id, sequence, movement, expectingRepeatsPerSet, expectingWeight);

  ReduceSet.fromObject(ReduceSet set) : super.fromOther(null) {
    if (set != null) {
      this.movement = set.movement;
      this.reduceWeight = set.reduceWeight;
      this.reduceTo = set.reduceTo;
      this.sequence = set.sequence;
    }
  }

  factory ReduceSet.fromJson(Map<String, dynamic> json) =>
      _$ReduceSetFromJson(json);

  Map<String, dynamic> toJson() => _$ReduceSetToJson(this);

  void copyFromRegularSet(SingleMovementSet regularSet) {
    this.expectingRepeatsPerSet = regularSet.expectingRepeatsPerSet;
    this.expectingWeight = regularSet.expectingWeight;
    this.movement = regularSet.movement;
  }
}

///巨人组
@JsonSerializable()
class GiantSet extends ExerciseSet {
  Set<SingleMovementSet> movements = Set();
  int intervalTimeSecond;

  factory GiantSet.fromJson(Map<String, dynamic> json) =>
      _$GiantSetFromJson(json);

  Map<String, dynamic> toJson() => _$GiantSetToJson(this);

  GiantSet(String id, int sequence, this.movements, this.intervalTimeSecond) {
    this.id = id;
    this.sequence = sequence;
  }

  GiantSet.fromObject(GiantSet set) {
    if (set != null) {
      this.movements = set.movements;
      this.intervalTimeSecond = set.intervalTimeSecond;
    }
  }

  Movement extractMovementBasicInfo() {
    Movement combinedMovement = Movement.empty();
    combinedMovement.id =
        movements.map((SingleMovementSet m) => m.movement.id).join('/');
    combinedMovement.name = "超级组：" +
        movements.map((SingleMovementSet m) => m.movement.name).join('/');
    combinedMovement.exerciseType = ExerciseType.lifting;
    return combinedMovement;
  }
}

@JsonSerializable()
class HIITSet extends ExerciseSet {
  List<SingleMovementSet> movements = List();
  int exerciseTime;
  int restTime;

  HIITSet(String id, int sequence, this.movements, this.exerciseTime,
      this.restTime) {
    this.id = id;
    this.sequence = sequence;
  }

  factory HIITSet.fromJson(Map<String, dynamic> json) =>
      _$HIITSetFromJson(json);

  Map<String, dynamic> toJson() => _$HIITSetToJson(this);

  Movement extractMovementBasicInfo() {
    Movement combinedMovement = Movement.empty();
    combinedMovement.id =
        movements.map((SingleMovementSet m) => m.movement.id).join('/');
    combinedMovement.name = "HIIT第" + sequence.toString() + "组";
    combinedMovement.exerciseType = ExerciseType.hiit;
    return combinedMovement;
  }

  HIITSet.empty();
}

@JsonSerializable()
class CardioSet extends ExerciseSet {
  String movementName;
  CardioType movement;

  int exerciseTime;
  double exerciseDistance;

  double exerciseCals;

  CardioSet(String id, int sequence, this.movementName, this.movement,
      this.exerciseTime, this.exerciseDistance, this.exerciseCals) {
    this.id = id;
    this.sequence = sequence;
  }

  CardioSet.empty();

  factory CardioSet.fromJson(Map<String, dynamic> json) =>
      _$CardioSetFromJson(json);

  Map<String, dynamic> toJson() => _$CardioSetToJson(this);
}

enum CardioType { walking, running, cycle, swimming, rowing }

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
  int id;

  String name;

  List<Exercise> schedule;

  String planGoal;

  int totalTrainingCycle;

  int sessionPerTrainingCycle;

  int trainingCycleDays;

  String extraNote;

  int createdBy;

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

  Session.fromJson(value) {
    this.id = value["id"].toString();
    this.matchingExercise = Exercise();
    this.matchingExercise.id = value['matchingExerciseId'].toString();
    this.accomplishedSets = List();
    this.accomplishedTime = DateTime.parse(value['accomplishedTime']);
    (value['accomplishedSets'] as List).forEach((ces) {
      CompletedExerciseSet set = CompletedExerciseSet.empty();
      set.id = ces['id'];
      set.repeats = ces['repeats'];
      set.weight = ces['weight'];
      set.restAfterAccomplished = ces['restAfterAccomplished'];
      set.completedTime = DateTime.parse(ces['completedTime']);
      if (ces['accomplishedSetType'] == 'SingleMovementSet') {
        set.accomplishedSet =
            SingleMovementSet.fromJson(ces['accomplishedSet']);
      } else if (ces['accomplishedSetType'] == 'ReduceSet') {
        set.accomplishedSet = ReduceSet.fromJson(ces['accomplishedSet']);
      } else if (ces['accomplishedSetType'] == 'SingleMovementSet') {
        set.accomplishedSet = GiantSet.fromJson(ces['accomplishedSet']);
      } else if (ces['accomplishedSetType'] == 'SingleMovementSet') {
        set.accomplishedSet = CardioSet.fromJson(ces['accomplishedSet']);
      } else if (ces['accomplishedSetType'] == 'SingleMovementSet') {
        set.accomplishedSet = HIITSet.fromJson(ces['accomplishedSet']);
      }
      this.accomplishedSets.add(set);
    });
  }
}

///单个动作完成的组数
class CompletedExerciseSet {
  int id;

  ExerciseSet accomplishedSet;

  int repeats;

  ///default using KG
  double weight;

  int restAfterAccomplished;

  DateTime completedTime;

  CompletedExerciseSet(this.id, this.accomplishedSet, this.repeats, this.weight,
      this.restAfterAccomplished, this.completedTime);

  CompletedExerciseSet.empty();
}

class SessionMaterial {
  String id;

  String filePath;

  bool isVideo;

  String sessionId;

  SessionMaterial() {
    id = uuid.v4().toString();
  }
}

Map<BodyIndex, BodyIndexSpecification> mapBodyIndexInfo() {
  Map<BodyIndex, BodyIndexSpecification> bodyIndexMap = {};

  BodyIndex.values.forEach((BodyIndex bi) {
    switch (bi) {
      case BodyIndex.BODY_FAT:
        bodyIndexMap[bi] = BodyIndexSpecification("体脂", "%", bi);
        break;
      case BodyIndex.WEIGHT:
        bodyIndexMap[bi] = BodyIndexSpecification("体重", "KG", bi);
        break;
      case BodyIndex.HEIGHT:
        bodyIndexMap[bi] = BodyIndexSpecification("身高", "cm", bi);
        break;
      case BodyIndex.ARM_RADIUS:
        bodyIndexMap[bi] = BodyIndexSpecification("臂围", "cm", bi);
        break;
      case BodyIndex.LEG_RADIUS:
        bodyIndexMap[bi] = BodyIndexSpecification("腿围", "cm", bi);
        break;
      case BodyIndex.ABS_RADIUS:
        bodyIndexMap[bi] = BodyIndexSpecification("腰围", "cm", bi);
        break;
      case BodyIndex.GLUTES_RADIUS:
        bodyIndexMap[bi] = BodyIndexSpecification("臀围", "cm", bi);
        break;
      case BodyIndex.CHEST_RADIUS:
        bodyIndexMap[bi] = BodyIndexSpecification("胸围", "cm", bi);
        break;
      case BodyIndex.AGE:
        // TODO: Handle this case.
        bodyIndexMap[bi] = BodyIndexSpecification("年龄", "岁", bi);
        break;
    }
  });
  return bodyIndexMap;
}

class BodyIndexSpecification {
  String name;
  String unit;
  BodyIndex index;

  BodyIndexSpecification(this.name, this.unit, this.index);
}

@JsonSerializable()
class MovementOneRepMax {
  String userId;
  Movement movement;
  double oneRepMax;
  DateTime practiseTime;

  MovementOneRepMax(
      this.userId, this.movement, this.oneRepMax, this.practiseTime);

  factory MovementOneRepMax.fromJson(Map<String, dynamic> json) =>
      _$MovementOneRepMaxFromJson(json);

  Map<String, dynamic> toJson() => _$MovementOneRepMaxToJson(this);
}
