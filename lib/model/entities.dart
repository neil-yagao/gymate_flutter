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
  CHEST_RADIUS
}

@JsonSerializable()

class UserBodyIndex {
  BodyIndex index;
  double value;
  String unit;
  DateTime recordTime;

  UserBodyIndex(this.index, this.value, this.unit, this.recordTime);

}

@JsonSerializable()
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