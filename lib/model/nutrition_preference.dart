import 'entities.dart';



class UserNutritionPreference {
  User user;

  NutritionPreference nutritionPreference;

  DateTime recordTime;

  List<String> specialDates;

  double recommendedCals;

  double recommendedProtein;

  double recommendedCrabs;

  double recommendedFat;
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