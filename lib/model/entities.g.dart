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
    json['grounpName'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'token': instance.token,
      'avatar': instance.avatar,
      'groupName': instance.groupName
    };
