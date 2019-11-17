// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      json['id'],
      json['title'] as String,
      json['content'] as String,
      json['postBy'] == null
          ? null
          : User.fromJson(json['postBy'] as Map<String, dynamic>),
      json['postAt'] == null ? null : DateTime.parse(json['postAt'] as String),
      json['recommendedCount'] as int,
      (json['replies'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['relatedPics'] as List)
          ?.map((e) => e == null
              ? null
              : PostMaterial.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['topic'] as String);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'postBy': instance.postBy,
      'postAt': instance.postAt?.toIso8601String(),
      'recommendedCount': instance.recommendedCount,
      'replies': instance.replies,
      'relatedPics': instance.relatedPics,
      'topic': instance.topic
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      json['id'],
      json['content'] as String,
      json['postBy'] == null
          ? null
          : User.fromJson(json['postBy'] as Map<String, dynamic>),
      json['postAt'] == null ? null : DateTime.parse(json['postAt'] as String),
      json['recommendedCount'] as int,
      (json['replies'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['belongTo'] == null
          ? null
          : Post.fromJson(json['belongTo'] as Map<String, dynamic>),
      json['replyTo'] == null
          ? null
          : Comment.fromJson(json['replyTo'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'postBy': instance.postBy,
      'postAt': instance.postAt?.toIso8601String(),
      'recommendedCount': instance.recommendedCount,
      'replies': instance.replies,
      'belongTo': {
        'id':instance.belongTo?.id
      },
      'replyTo': instance.replyTo
    };

PostMaterial _$PostMaterialFromJson(Map<String, dynamic> json) {
  return PostMaterial(
      json['storedAt'] as String,
      json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String));
}

Map<String, dynamic> _$PostMaterialToJson(PostMaterial instance) =>
    <String, dynamic>{
      'storedAt': instance.storedAt,
      'uploadedAt': instance.uploadedAt?.toIso8601String()
    };

Recommend _$RecommendFromJson(Map<String, dynamic> json) {
  return Recommend(
      json['recommendBy'] == null
          ? null
          : User.fromJson(json['recommendBy'] as Map<String, dynamic>),
      json['recommendTargetId'] as int,
      _$enumDecodeNullable(_$UserEventTypeEnumMap, json['target']),
      json['targetOwner'] == null
          ? null
          : User.fromJson(json['targetOwner'] as Map<String, dynamic>),
      (json['recommendScore'] as num)?.toDouble());
}

Map<String, dynamic> _$RecommendToJson(Recommend instance) => <String, dynamic>{
      'recommendBy': instance.recommendBy,
      'recommendTargetId': instance.recommendTargetId,
      'target': _$UserEventTypeEnumMap[instance.target],
      'targetOwner': instance.targetOwner,
      'recommendScore': instance.recommendScore
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
  UserEventType.BeRecommended: 'BeRecommended',
  UserEventType.Exercise: 'Exercise',
  UserEventType.Movement: 'Movement',
  UserEventType.Movement_Material: 'Movement_Material',
  UserEventType.TrainingPlan: 'TrainingPlan'
};
