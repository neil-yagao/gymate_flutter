import 'package:flutter/material.dart';
import 'package:workout_helper/model/nutrition_preference.dart';

// ignore: must_be_immutable
class MacroNutritionPanel extends StatelessWidget {
  final MacroNutrition userNutritionPreference;

  List<Widget> _extraWidget;

  MacroNutritionPanel(this.userNutritionPreference, List<Widget> widgets){
    if(widgets == null){
      this._extraWidget = List();
    }else{
      this._extraWidget = widgets;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "蛋白质：",
                style: Typography.dense2018.subtitle
                    .merge(TextStyle(fontStyle: FontStyle.italic)),
              )),
              Expanded(
                child: Text(
                  userNutritionPreference.getProtein().floor().toString() +
                      " g",
                  style: Typography.dense2018.subtitle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text("碳水化合物：",
                      style: Typography.dense2018.subtitle
                          .merge(TextStyle(fontStyle: FontStyle.italic)))),
              Expanded(
                child: Text(
                  userNutritionPreference.getCrabs().floor().toString() + " g",
                  style: Typography.dense2018.subtitle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 5, right: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text("脂肪：",
                      style: Typography.dense2018.subtitle
                          .merge(TextStyle(fontStyle: FontStyle.italic)))),
              Expanded(
                child: Text(
                  userNutritionPreference.getFats().floor().toString() + " g",
                  style: Typography.dense2018.subtitle,
                ),
              )
            ],
          ),
        ),
        ..._extraWidget
      ],
    );
  }
}
