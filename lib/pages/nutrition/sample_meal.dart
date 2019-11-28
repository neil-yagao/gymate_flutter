import 'package:flutter/material.dart';
import 'package:workout_helper/model/nutrition_preference.dart';

class SampleMeal extends StatelessWidget {
  final NutritionRecord nutritionRecord;

  SampleMeal({this.nutritionRecord});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int chickenBreast = 0;

    ///30g/ea
    int eggWhite = 0;

    ///3.5g/ea
    double rice = 0;
    chickenBreast = (nutritionRecord.getProtein() / 30).floor();
    eggWhite =
        ((nutritionRecord.getProtein() - 30* chickenBreast) / 3.5).floor();
    rice = nutritionRecord.getCrabs() * 100 / 18;
    double nuts = nutritionRecord.getFats() * 1.5;
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 4),
          child: Text(
            "示例餐,\n鸡胸肉：" +
                chickenBreast.toString() +
                "块," +
                "鸡蛋白：" +
                eggWhite.toString() +
                "个; 坚果类：" +
                nuts.floor().toString() +
                "g；米饭：" +
                rice.floor().toString() +
                "g；叶类蔬菜任意。",
            style: Typography.dense2018.caption
                .merge(TextStyle(fontStyle: FontStyle.italic)),
          ),
        )
      ],
    );
  }
}
