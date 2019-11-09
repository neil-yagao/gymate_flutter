// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEvent _$UserEventFromJson(Map<String, dynamic> json) {
  return UserEvent(
      json['id'] as int,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['relatedRecordId'] as int,
      _$enumDecodeNullable(_$UserEventTypeEnumMap, json['type']),
      (json['extraScore'] as num)?.toDouble(),
      json['happenedAt'] == null
          ? null
          : DateTime.parse(json['happenedAt'] as String))
    ..relatedRecord = json['relatedRecord'];
}

Map<String, dynamic> _$UserEventToJson(UserEvent instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'relatedRecordId': instance.relatedRecordId,
      'type': _$UserEventTypeEnumMap[instance.type],
      'extraScore': instance.extraScore,
      'happenedAt': instance.happenedAt?.toIso8601String(),
      'relatedRecord': instance.relatedRecord
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
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

const _$UserEventTypeEnumMap = <UserEventType, dynamic>{
  UserEventType.Session: 'Session',
  UserEventType.NutritionRecord: 'NutritionRecord',
  UserEventType.OneRepMax: 'OneRepMax',
  UserEventType.Post: 'Post',
  UserEventType.Reply: 'Reply',
  UserEventType.Question: 'Question',
  UserEventType.QuestionReply: 'QuestionReply',
  UserEventType.QuestionApplyAccepted: 'QuestionApplyAccepted',
  UserEventType.Recommended: 'Recommended',
  UserEventType.BeRecommended:'BeRecommended',
  UserEventType.Exercise: 'Exercise',
  UserEventType.Movement: 'Movement',
  UserEventType.Movement_Material: 'Movement_Material',
  UserEventType.TrainingPlan: 'TrainingPlan'
};

Membership _$MembershipFromJson(Map<String, dynamic> json) {
  return Membership(
      (json['currentScore'] as num)?.toDouble(),
      json['memberLevel'] as String,
      json['paidUser'] as String,
      json['validateUntil'] == null
          ? null
          : DateTime.parse(json['validateUntil'] as String));
}

Map<String, dynamic> _$MembershipToJson(Membership instance) =>
    <String, dynamic>{
      'currentScore': instance.currentScore,
      'memberLevel': instance.memberLevel,
      'paidUser': instance.paidUser,
      'validateUntil': instance.validateUntil?.toIso8601String()
    };
