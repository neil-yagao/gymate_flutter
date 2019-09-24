import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'bottom_sheet_util.dart';

class HIITBottomSheet extends StatefulWidget {

  final Function(List<ExerciseSet> newMovement) onSubmitted;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HIITBottomSheet({Key key, this.onSubmitted, this.scaffoldKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HIITBottomSheetState(onSubmitted,this.scaffoldKey);
  }
}

/// HIIT is more or less like super set
class HIITBottomSheetState extends State<HIITBottomSheet> {
  final Map<double, String> _RATIO_LABEL_MAP = {
    0.0: "1:2",
    1.0: "1:1",
    2.0: "2:1",
    3.0: "3:1",
    4.0: "4:1"
  };

  final Function(List<ExerciseSet> newMovement) onSubmitted;

  List<SingleMovementSet> _predefineRoutine = List();

  SingleMovementSet _regularSet = SingleMovementSet.fromOther(null);

  MovementService service = MovementService(null);

  MovementBottomSheetUtil movementBottomSheetUtil;

  TextEditingController timeUnit = TextEditingController(text: "30");

  TextEditingController repeatTimes = TextEditingController(text: '3');

  TextEditingController extraWeight = TextEditingController(text: '0');

  TextEditingController movement = TextEditingController();

  double ratio = 1.0;

  HIITBottomSheetState(this.onSubmitted, this.scaffoldKey);

  final GlobalKey<ScaffoldState> scaffoldKey;


  @override
  void initState() {
    super.initState();
    service.getMovements(ExerciseType.hiit).then((List<Movement> movements) {
      setState(() {
        movementBottomSheetUtil = MovementBottomSheetUtil(movements);
      });
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    if (movementBottomSheetUtil == null) {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
      );
    }
    return Center(
        child: Card(
            child: ListView(
              shrinkWrap: true, children: <Widget>[
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "训练设计",
                  style: Typography.dense2018.headline,
                )
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      textAlign: TextAlign.right,
                      controller: timeUnit,
                      decoration: InputDecoration(
                          isDense: true,
                          prefixText: "时间",
                          hintText: "30~60",
                          suffixText: "秒"),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Slider(
                        label: "训练：休息（" + _RATIO_LABEL_MAP[ratio] + ")",
                        value: ratio,
                        min: 0,
                        max: 4,
                        divisions: 4,
                        onChanged: (double value) {
                          ///ratio mean exercise/resting
                          ///0 stands for 1/2
                          ///1 stands for 1/1
                          ///2 stands for 2/1
                          ///3 stands for 3/1
                          ///4 stands for 4/1
                          setState(() {
                            ratio = value;
                          });
                        }),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      textAlign: TextAlign.right,
                      controller: repeatTimes,
                      decoration: InputDecoration(
                          isDense: true,
                          prefixText: "循环",
                          hintText: "2~5",
                          suffixText: "次"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0,),
                        child: movementBottomSheetUtil.buildMovementSearchBar(
                                (Movement data) {
                              setState(() {
                                this._regularSet.movement = data;
                                this._regularSet.movement.exerciseType =
                                    ExerciseType.hiit;
                              });
                            }, movement
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          textAlign: TextAlign.right,
                          controller: extraWeight,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixText: "额外重量",
                              suffixText: "KG"),
                        ),
                      ),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    onPressed: () {
                      if (_regularSet.movement == null) {
                        scaffoldKey.currentState
                            .showSnackBar(SnackBar(content: Text("训练动作不能为空")));
                        throw Error();
                      }
                      setState(() {
                        _regularSet.expectingWeight =
                            double.parse(extraWeight.text);
                        _regularSet.unit = "KG";
                        _regularSet.expectingRepeatsPerSet = -1;
                        _regularSet.sequence = _predefineRoutine.length + 1;
                        _predefineRoutine.add(_regularSet);
                        _regularSet = SingleMovementSet.fromOther(null);
                        movement.text = '';
                      });
                    },
                    child: Text("添加"),
                  ),
                )
              ],
            ),
            Divider(),
            ...buildMovementRoutine(),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () {
              List<ExerciseSet> hiitSets = List.generate(
                  int.parse(repeatTimes.text), (int index) {
                HIITSet template = HIITSet.empty();
                template.id = Random(index).nextDouble().toString();
                template.sequence = index + 1;
                List<SingleMovementSet> smss = List();
                _predefineRoutine.forEach((SingleMovementSet sms){
                  SingleMovementSet nsms = SingleMovementSet.fromOther(sms);
                  nsms.id = uuid.v4();
                  smss.add(nsms);
                });
                template.movements = smss;
                int exerciseTime = int.parse(timeUnit.text);
                int restTime = int.parse(timeUnit.text);
                if(ratio == 0 ){
                  restTime *= 2;
                }else {
                  exerciseTime *= ratio.round();
                }
                template.exerciseTime = exerciseTime;
                template.restTime = restTime;
                return template;
              });
              onSubmitted(hiitSets);
            },
            color: Colors.green,
            textColor: Colors.white,
            child: Text("创建训练"),
          ),
        )
        ])),
    );
  }

  List<Widget> buildMovementRoutine() {
    if (_predefineRoutine.isEmpty) {
      return [
        Container(
          height: 100,
          child: Center(
              child: Text(
                "建议添加至少3个动作！",
                style: Typography.dense2018.headline,

              )),
        )
      ];
    }
    return _predefineRoutine.map((SingleMovementSet sm) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 30),
          title: Text(sm.movement.name),
          dense: true,
          trailing: InkWell(
            onTap: () {
              setState(() {
                int removingIndex = _predefineRoutine.indexWhere((
                    SingleMovementSet sms) {
                  return sms.movement == sm.movement;
                });
                _predefineRoutine.removeAt(removingIndex);
              });
            },
            child: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }).toList();
  }
}
