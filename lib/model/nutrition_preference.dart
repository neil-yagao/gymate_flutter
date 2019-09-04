import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'entities.dart';

part 'nutrition_preference.g.dart';

@JsonSerializable()
class UserNutritionPreference extends MacroNutrition {
  int id;

  User user;

  NutritionPreference nutritionPreference;

  DateTime recordTime;

  String specialDates;

  ///bmr * (1.2[0]/1.375[1-3]/1.55[3-5]/1.72[6-7]/1.9)
  double tdee;

  ///10 * weight + 6.25 * height - 5 * age + 5/-161
  /// 370 + (21.6 * LBM)
  double bmr;

  double recommendedProtein;

  double recommendedCrabs;

  double recommendedFat;

  UserNutritionPreference(
      this.id,
      this.user,
      this.nutritionPreference,
      this.recordTime,
      this.specialDates,
      this.tdee,
      this.bmr,
      this.recommendedProtein,
      this.recommendedCrabs,
      this.recommendedFat);

  UserNutritionPreference.empty();

  factory UserNutritionPreference.fromJson(Map<String, dynamic> json) =>
      _$UserNutritionPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserNutritionPreferenceToJson(this);

  @override
  double getCrabs() {
    // TODO: implement getCrabs
    return recommendedCrabs;
  }

  @override
  double getFats() {
    // TODO: implement getFats
    return recommendedFat;
  }

  @override
  double getProtein() {
    // TODO: implement getProtein
    return recommendedProtein;
  }

  String getNutritionPreferenceName() {
    String dayOfTheWeek = DateFormat("EEE").format(DateTime.now());
    final date = DateTime.now();
    final diff = DateTime.now().difference(new DateTime(date.year, 1, 1, 0, 0));
    int dayOfTheYear = diff.inDays;
    switch (nutritionPreference) {
      case NutritionPreference.CARB_CYCLE:
        return "碳水循环(" + (specialDates.contains(dayOfTheWeek) ? "高碳水" : "低碳水") + ")";
      case NutritionPreference.FIVE_TWO:
        return "5 + 2(" +
            (specialDates.contains(dayOfTheWeek) ? "无摄入日" : "正常摄入") +
            ")";
      case NutritionPreference.ONE_PLUS_ONE:
        // TODO: Handle this case.
        return "1 + 1(" + (dayOfTheYear % 2==0?"正常摄入日":"低摄入日")+ ")";
      case NutritionPreference.EIGHT_HOUR_INTAKE:
        // TODO: Handle this case.
        return "8/16循环";
      case NutritionPreference.NORMAL:
        return "正常摄入计划";
      case NutritionPreference.MUSCLE_GAIN:
        // TODO: Handle this case.
        return "增肌摄入计划";
    }
    return '';
  }
}

enum NutritionPreference {
  /**
   * two day high carb
   */
  CARB_CYCLE,

  /**
   * two day zero intake
   */
  FIVE_TWO,

  /**
   * another day 25% cal
   */
  ONE_PLUS_ONE,

  /**
   * no special but time reminding
   */
  EIGHT_HOUR_INTAKE,

  /**
   * p:c:f 4:4:2
   */
  NORMAL,

  /**
   * p:c:f 3:5:2 + 500KCals
   */
  MUSCLE_GAIN
}

@JsonSerializable()
class NutritionRecord extends MacroNutrition {

  int id;

  List<String> materials;

  String name;

  User recorder;

  /**
   * unit in gram
   */
  double protein;

  double carbohydrate;

  double fat;

  /**
   * unit in KCal
   */
  double estimateCals;

  NutritionRecord(this.id, this.materials, this.name, this.recorder, this.protein,
      this.carbohydrate, this.fat, this.estimateCals);

  NutritionRecord.empty();

  factory NutritionRecord.fromJson(Map<String, dynamic> json) =>
      _$NutritionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionRecordToJson(this);

  @override
  double getCrabs() {
    // TODO: implement getCrabs
    return carbohydrate;
  }

  @override
  double getFats() {
    // TODO: implement getFats
    return fat;
  }

  @override
  double getProtein() {
    // TODO: implement getProtein
    return protein;
  }
}

abstract class MacroNutrition {
  double getProtein();

  double getCrabs();

  double getFats();
}
