import 'package:flutter/material.dart';
import 'package:workout_helper/model/nutrition_preference.dart';

class DietPattern extends StatefulWidget {

  final Function(NutritionPreference) onUserSelectingPreference;

  const DietPattern({Key key, @required this.onUserSelectingPreference}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DietPatternState(onUserSelectingPreference);
  }
}

class DietPatternState extends State<DietPattern> {
  NutritionPreference _selectedNutritionPreference =
      NutritionPreference.CARB_CYCLE;

  final Function(NutritionPreference) onUserSelectingPreference;

  bool _processingFasting = false;

  String intermediateFasting = "轻断食";

  DietPatternState(this.onUserSelectingPreference);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
              child: FlatButton(
            textColor:
                _selectedNutritionPreference == NutritionPreference.CARB_CYCLE
                    ? Theme.of(context).primaryColor
                    : Colors.black,
            child: Text("碳水循环"),
            onPressed: () {
              setState(() {
                _selectedNutritionPreference = NutritionPreference.CARB_CYCLE;
                onUserSelectingPreference( NutritionPreference.CARB_CYCLE);
                _processingFasting = false;
              });
            },
          )),
        ),
        Expanded(
          child: Center(
              child: FlatButton(
            textColor: _processingFasting
                ? Theme.of(context).primaryColor
                : Colors.black,
            child: Text(intermediateFasting),
            onPressed: () {
              showDialog<NutritionPreference>(
                  context: context,
                  builder: (context) => IntermediateFastingSelection())
                  .then((preference) {
                onUserSelectingPreference(preference);
                setState(() {
                  this._selectedNutritionPreference = preference;
                  if(preference == NutritionPreference.EIGHT_HOUR_INTAKE){
                    intermediateFasting = "8 + 6";
                  }else if(preference == NutritionPreference.FIVE_TWO){
                    intermediateFasting = "5 + 2";
                  }else {
                    intermediateFasting = "1 + 1";
                  }
                });
              });
              setState(() {
                _selectedNutritionPreference = null;
                _processingFasting = true;
              });
            },
          )),
        ),
        Expanded(
          child: Center(
              child: FlatButton(
            textColor:
                _selectedNutritionPreference == NutritionPreference.MUSCLE_GAIN
                    ? Theme.of(context).primaryColor
                    : Colors.black,
            child: Text("增肌食谱"),
            onPressed: () {
              setState(() {
                onUserSelectingPreference(NutritionPreference.MUSCLE_GAIN);

                _selectedNutritionPreference = NutritionPreference.MUSCLE_GAIN;
                _processingFasting = false;
              });
            },
          )),
        ),
        Expanded(
          child: Center(
              child: FlatButton(
            textColor:
                _selectedNutritionPreference == NutritionPreference.NORMAL
                    ? Theme.of(context).primaryColor
                    : Colors.black,
            child: Text("正常摄入"),
            onPressed: () {
              setState(() {
                onUserSelectingPreference(NutritionPreference.NORMAL);
                _selectedNutritionPreference = NutritionPreference.NORMAL;
                _processingFasting = false;
              });
            },
          )),
        ),
      ],
    );
  }
}

class IntermediateFastingSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IntermediateFastingSelectionState();
  }
}

class IntermediateFastingSelectionState
    extends State<IntermediateFastingSelection> {
  NutritionPreference _currentSelection = NutritionPreference.EIGHT_HOUR_INTAKE;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Card(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              onTap: () {
                setState(() {
                  _currentSelection = NutritionPreference.EIGHT_HOUR_INTAKE;
                });
              },
              leading: Icon(
                Icons.check,
                color:
                    _currentSelection == NutritionPreference.EIGHT_HOUR_INTAKE
                        ? Colors.greenAccent
                        : Colors.transparent,
              ),
              title: Text("8/16计划(lean gain)"),
              subtitle: Text("8小时的摄入窗口，16小时不进食。"),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _currentSelection = NutritionPreference.FIVE_TWO;
                });
              },
              leading: Icon(
                Icons.check,
                color: _currentSelection == NutritionPreference.FIVE_TWO
                    ? Colors.greenAccent
                    : Colors.transparent,
              ),
              title: Text("5 + 2计划"),
              subtitle: Text("一周中选择2个不连续的24小时不摄入。"),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _currentSelection = NutritionPreference.ONE_PLUS_ONE;
                });
              },
              leading: Icon(
                Icons.check,
                color: _currentSelection == NutritionPreference.ONE_PLUS_ONE
                    ? Colors.greenAccent
                    : Colors.transparent,
              ),
              title: Text("1 + 1计划"),
              subtitle: Text("隔天只摄入25%摄入量，第二天正常摄入。"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 10),
                  child: FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      "确定",
                    ),
                    onPressed: () {
                      Navigator.of(context).maybePop(_currentSelection);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
