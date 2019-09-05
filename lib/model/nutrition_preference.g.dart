// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNutritionPreference _$UserNutritionPreferenceFromJson(
    Map<String, dynamic> json) {
  return UserNutritionPreference(
      json['id'] as int,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      _$enumDecodeNullable(
          _$NutritionPreferenceEnumMap, json['nutritionPreference']),
      json['recordTime'] == null
          ? null
          : DateTime.parse(json['recordTime'] as String),
      (json['specialDates'] as String),
      (json['tdee'] as num)?.toDouble(),
      (json['bmr'] as num)?.toDouble(),
      (json['recommendedProtein'] as num)?.toDouble(),
      (json['recommendedCrabs'] as num)?.toDouble(),
      (json['recommendedFat'] as num)?.toDouble());
}

Map<String, dynamic> _$UserNutritionPreferenceToJson(
        UserNutritionPreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'nutritionPreference':
          _$NutritionPreferenceEnumMap[instance.nutritionPreference],
      'recordTime': instance.recordTime?.toIso8601String(),
      'specialDates': instance.specialDates,
      'tdee': instance.tdee,
      'bmr': instance.bmr,
      'recommendedProtein': instance.recommendedProtein,
      'recommendedCrabs': instance.recommendedCrabs,
      'recommendedFat': instance.recommendedFat
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

const _$NutritionPreferenceEnumMap = <NutritionPreference, dynamic>{
  NutritionPreference.CARB_CYCLE: 'CARB_CYCLE',
  NutritionPreference.FIVE_TWO: 'FIVE_TWO',
  NutritionPreference.ONE_PLUS_ONE: 'ONE_PLUS_ONE',
  NutritionPreference.EIGHT_HOUR_INTAKE: 'EIGHT_HOUR_INTAKE',
  NutritionPreference.NORMAL: 'NORMAL',
  NutritionPreference.MUSCLE_GAIN: 'MUSCLE_GAIN'
};

NutritionRecord _$NutritionRecordFromJson(Map<String, dynamic> json) {
  return NutritionRecord(
      json['id'] as int,
      (json['materials'] as List)?.map((e) => e as String)?.toList(),
      json['name'] as String,
      json['recorder'] == null
          ? null
          : User.fromJson(json['recorder'] as Map<String, dynamic>),
      (json['protein'] as num)?.toDouble(),
      (json['carbohydrate'] as num)?.toDouble(),
      (json['fat'] as num)?.toDouble(),
      (json['estimateCals'] as num)?.toDouble());
}

Map<String, dynamic> _$NutritionRecordToJson(NutritionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'materials': instance.materials,
      'name': instance.name,
      'recorder': instance.recorder,
      'protein': instance.protein,
      'carbohydrate': instance.carbohydrate,
      'fat': instance.fat,
      'estimateCals': instance.estimateCals
    };
