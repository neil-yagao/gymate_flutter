// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['id'] as int,
      json['name'] as String,
      json['alias'] as String,
      json['token'] as String,
      json['avatar'] as String,
      json['groupName'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'token': instance.token,
      'avatar': instance.avatar,
      'groupName': instance.groupName
    };

UserBodyIndex _$UserBodyIndexFromJson(Map<String, dynamic> json) {
  return UserBodyIndex(
      _$enumDecodeNullable(_$BodyIndexEnumMap, json['body_index']),
      (json['value'] as num)?.toDouble(),
      json['unit'] as String,
      json['record_time'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['record_time']));
}

Map<String, dynamic> _$UserBodyIndexToJson(UserBodyIndex instance) =>
    <String, dynamic>{
      'body_index': _$BodyIndexEnumMap[instance.bodyIndex],
      'value': instance.value,
      'unit': instance.unit,
      'record_time': instance.recordTime?.toIso8601String()
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere(
          (e) =>
              e.value == source ||
              e.key.runtimeType.toString() + '.' + e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null || (source is String && source.isEmpty)) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$BodyIndexEnumMap = <BodyIndex, dynamic>{
  BodyIndex.BODY_FAT: 'BODY_FAT',
  BodyIndex.WEIGHT: 'WEIGHT',
  BodyIndex.HEIGHT: 'HEIGHT',
  BodyIndex.ARM_RADIUS: 'ARM_RADIUS',
  BodyIndex.LEG_RADIUS: 'LEG_RADIUS',
  BodyIndex.ABS_RADIUS: 'ABS_RADIUS',
  BodyIndex.GLUTES_RADIUS: 'GLUTES_RADIUS',
  BodyIndex.CHEST_RADIUS: 'CHEST_RADIUS',
  BodyIndex.AGE:'AGE'
};

SingleMovementSet _$SingleMovementSetFromJson(Map<String, dynamic> json) {
  return SingleMovementSet(
      json['id'].toString(),
      json['sequence'] as int,
      json['movement'] == null
          ? null
          : Movement.fromJson(json['movement'] as Map<String, dynamic>),
      json['expectingRepeatsPerSet'] as int,
      (json['expectingWeight'] as num)?.toDouble());
}

Map<String, dynamic> _$SingleMovementSetToJson(SingleMovementSet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'movement': instance.movement,
      'expectingRepeatsPerSet': instance.expectingRepeatsPerSet,
      'expectingWeight': instance.expectingWeight
    };

Movement _$MovementFromJson(Map<String, dynamic> json) {
  return Movement(
      json['id'].toString(),
      json['name'] as String,
      json['description'] as String,
      json['picReference'] as String,
      json['videoReference'] as String,
      _$enumDecodeNullable(_$ExerciseTypeEnumMap, json['exerciseType']),
      (json['involvedMuscle'].toString().split(","))
          ?.map((e) => _$enumDecodeNullable(_$MuscleGroupEnumMap, e))
          ?.toList(),
      json['recommendRestingTimeBetweenSet'] as int);
}

Map<String, dynamic> _$MovementToJson(Movement instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'picReference': instance.picReference,
      'videoReference': instance.videoReference,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType],
      'involvedMuscle': instance.involvedMuscle
          ?.map((e) => _$MuscleGroupEnumMap[e])
          ?.toList()?.join(","),
      'recommendRestingTimeBetweenSet': instance.recommendRestingTimeBetweenSet
    };

const _$ExerciseTypeEnumMap = <ExerciseType, dynamic>{
  ExerciseType.lifting: 'lifting',
  ExerciseType.hiit: 'hiit',
  ExerciseType.cardio: 'cardio'
};

const _$MuscleGroupEnumMap = <MuscleGroup, dynamic>{
  MuscleGroup.SHOULDER: 'SHOULDER',
  MuscleGroup.TRAP: 'TRAP',
  MuscleGroup.CHEST: 'CHEST',
  MuscleGroup.ARM: 'ARM',
  MuscleGroup.BICEPS: 'BICEPS',
  MuscleGroup.TRICEPS: 'TRICEPS',
  MuscleGroup.FOREARM: 'FOREARM',
  MuscleGroup.BACK: 'BACK',
  MuscleGroup.LATS: 'LATS',
  MuscleGroup.MIDDLE_BACK: 'MIDDLE_BACK',
  MuscleGroup.LOWER_BACK: 'LOWER_BACK',
  MuscleGroup.ABS: 'ABS',
  MuscleGroup.LEG: 'LEG',
  MuscleGroup.QUADS: 'QUADS',
  MuscleGroup.GLUTES: 'GLUTES',
  MuscleGroup.HAMSTRING: 'HAMSTRING',
  MuscleGroup.CALVES: 'CALVES'
};

ReduceSet _$ReduceSetFromJson(Map<String, dynamic> json) {
  return ReduceSet(
      json['id'].toString(),
      json['sequence'] as int,
      json['movement'] == null
          ? null
          : Movement.fromJson(json['movement'] as Map<String, dynamic>),
      json['expectingRepeatsPerSet'] as int,
      (json['expectingWeight'] as num)?.toDouble(),
      (json['reduceWeight'] as num)?.toDouble(),
      (json['reduceTo'] as num)?.toDouble(),
      json['intervalTime'] as int);
}

Map<String, dynamic> _$ReduceSetToJson(ReduceSet instance) => <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'movement': instance.movement,
      'expectingRepeatsPerSet': instance.expectingRepeatsPerSet,
      'expectingWeight': instance.expectingWeight,
      'reduceWeight': instance.reduceWeight,
      'reduceTo': instance.reduceTo,
      'intervalTime': instance.intervalTime
    };

GiantSet _$GiantSetFromJson(Map<String, dynamic> json) {
  return GiantSet(
      json['id'].toString(),
      json['sequence'] as int,
      (json['movements'] as List)
          ?.map((e) => e == null
              ? null
              : SingleMovementSet.fromJson(e as Map<String, dynamic>))
          ?.toSet(),
      json['intervalTimeSecond'] as int);
}

Map<String, dynamic> _$GiantSetToJson(GiantSet instance) => <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'movements': instance.movements?.toList(),
      'intervalTimeSecond': instance.intervalTimeSecond
    };

HIITSet _$HIITSetFromJson(Map<String, dynamic> json) {
  return HIITSet(
      json['id'].toString(),
      json['sequence'] as int,
      (json['movements'] as List)
          ?.map((e) => e == null
              ? null
              : SingleMovementSet.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['exerciseTime'] as int,
      json['restTime'] as int);
}

Map<String, dynamic> _$HIITSetToJson(HIITSet instance) => <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'movements': instance.movements,
      'exerciseTime': instance.exerciseTime,
      'restTime': instance.restTime
    };

CardioSet _$CardioSetFromJson(Map<String, dynamic> json) {
  return CardioSet(
      json['id'].toString(),
      json['sequence'] as int,
      json['movementName'] as String,
      _$enumDecodeNullable(_$CardioTypeEnumMap, json['movement']),
      json['exerciseTime'] as int,
      (json['exerciseDistance'] as num)?.toDouble(),
      (json['exerciseCals'] as num)?.toDouble());
}

Map<String, dynamic> _$CardioSetToJson(CardioSet instance) => <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'movementName': instance.movementName,
      'movement': _$CardioTypeEnumMap[instance.movement],
      'exerciseTime': instance.exerciseTime,
      'exerciseDistance': instance.exerciseDistance,
      'exerciseCals': instance.exerciseCals
    };

const _$CardioTypeEnumMap = <CardioType, dynamic>{
  CardioType.walking: 'walking',
  CardioType.running: 'running',
  CardioType.cycle: 'cycle',
  CardioType.swimming: 'swimming',
  CardioType.rowing: 'rowing'
};

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return Exercise(
      json['id'].toString(),
      ( (json['muscleTarget'] as String).split(","))
          ?.map((e) => _$enumDecodeNullable(_$MuscleGroupEnumMap, e))
          ?.toList(),
      json['name'] as String,
      json['description'] as String,
      json['recommendRestingTimeBetweenMovement'] as int);
}

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'muscleTarget':
          instance.muscleTarget?.map((e) => _$MuscleGroupEnumMap[e])?.toList(),
      'name': instance.name,
      'description': instance.description,
      'recommendRestingTimeBetweenMovement':
          instance.recommendRestingTimeBetweenMovement
    };

TrainingPlan _$TrainingPlanFromJson(Map<String, dynamic> json) {
  return TrainingPlan(
      json['id'] as int,
      json['name'] as String,
      json['planGoal'] as String,
      json['totalTrainingCycle'] as int,
      json['sessionPerTrainingCycle'] as int,
      json['trainingCycleDays'] as int,
      json['extraNote'] as String,
      json['createdBy'] == null
          ? null
          : User.fromJson(json['createdBy'] as Map<String, dynamic>))
    ..schedule = (json['schedule'] as List)
        ?.map((e) =>
            e == null ? null : Exercise.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TrainingPlanToJson(TrainingPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schedule': instance.schedule,
      'planGoal': instance.planGoal,
      'totalTrainingCycle': instance.totalTrainingCycle,
      'sessionPerTrainingCycle': instance.sessionPerTrainingCycle,
      'trainingCycleDays': instance.trainingCycleDays,
      'extraNote': instance.extraNote,
      'createdBy': instance.createdBy
    };

MovementOneRepMax _$MovementOneRepMaxFromJson(Map<String, dynamic> json) {
  return MovementOneRepMax(
      json['userId'] as String,
      json['movement'] == null
          ? null
          : Movement.fromJson(json['movement'] as Map<String, dynamic>),
      (json['oneRepMax'] as num)?.toDouble(),
      json['practiseTime'] == null
          ? null
          : DateTime.parse(json['practiseTime'] as String));
}

Map<String, dynamic> _$MovementOneRepMaxToJson(MovementOneRepMax instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'movement': instance.movement,
      'oneRepMax': instance.oneRepMax,
      'practiseTime': instance.practiseTime?.toIso8601String()
    };
