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
  if (source == null) {
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
  BodyIndex.CHEST_RADIUS: 'CHEST_RADIUS'
};

ExerciseSet _$ExerciseSetFromJson(Map<String, dynamic> json) {
  return ExerciseSet()
    ..id = json['id'] as String
    ..sequence = json['sequence'] as int;
}

Map<String, dynamic> _$ExerciseSetToJson(ExerciseSet instance) =>
    <String, dynamic>{'id': instance.id, 'sequence': instance.sequence};
