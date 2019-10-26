// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementMaterial _$MovementMaterialFromJson(Map<String, dynamic> json) {
  return MovementMaterial(
      json['id'] as int,
      json['uploadBy'] == null
          ? null
          : User.fromJson(json['uploadBy'] as Map<String, dynamic>),
      json['movement'] == null
          ? null
          : Movement.fromJson(json['movement'] as Map<String, dynamic>),
      json['analysedMovementPlace'] as String,
      (json['weeklyScore'] as num)?.toDouble(),
      json['totalRecommendation'] as int,
      (json['rate'] as num)?.toDouble(),
      (json['rawVideoPlace'] as String),
      json['frontPagePic'] as String
      ,
      DateTime.parse(json['uploadAt'] as String));
}

Map<String, dynamic> _$MovementMaterialToJson(MovementMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadBy': instance.uploadBy,
      'movement': instance.movement,
      'analysedMovementPlace': instance.analysedMovementPlace,
      'weeklyScore': instance.weeklyScore,
      'totalRecommendation': instance.totalRecommendation,
      'rate': instance.rate,
      'rawVideoPlace': instance.rawVideoPlace,
      'frontPagePic': instance.frontPagePic,
      'uploadAt':instance.uploadAt
    };

Movement _$MovementFromJson(Map<String, dynamic> json) {
  return Movement(
      json['id'].toString(),
      json['name'] as String,
      json['description'] as String,
      json['picReference'] as String,
      json['videoReference'] as String,
      _$enumDecodeNullable(_$ExerciseTypeEnumMap, json['exerciseType']),
      (json['involvedMuscle'] as String)
          .split(",")
          ?.map((e) => _$enumDecodeNullable(_$MuscleGroupEnumMap, e))
          ?.toList(),
      json['recommendRestingTimeBetweenSet'] as int,
      json['defaultMaterialId'] as int);
}

Map<String, dynamic> _$MovementToJson(Movement instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'picReference': instance.picReference,
      'videoReference': instance.videoReference,
      'exerciseType': _$ExerciseTypeEnumMap[instance.exerciseType],
      'involvedMuscle': instance.involvedMuscle?.join(","),
      'recommendRestingTimeBetweenSet': instance.recommendRestingTimeBetweenSet
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
              e.value == T.runtimeType.toString() + '.' + source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$ExerciseTypeEnumMap = <ExerciseType, dynamic>{
  ExerciseType.lifting: 'lifting',
  ExerciseType.hiit: 'hiit',
  ExerciseType.cardio: 'cardio'
};

const _$MuscleGroupEnumMap = <MuscleGroup, dynamic>{
  MuscleGroup.SHOULDER: 'SHOULDER',
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
