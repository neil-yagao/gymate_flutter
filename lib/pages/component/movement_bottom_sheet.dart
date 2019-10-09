import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'bottom_sheet_util.dart';
import 'label_radio.dart';

const MovementTypeLabelMap = {
  MovementType.SINGLE: "常规组",
  MovementType.REDUCE: '递减组',
  MovementType.GIANT: '超级组'
};

class MovementBottomSheet extends StatefulWidget {
  final Function(List<ExerciseSet> newMovement) onSubmitted;

  final GlobalKey<ScaffoldState> scaffoldKey;

  const MovementBottomSheet({Key key, this.onSubmitted, this.scaffoldKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovementBottomSheetState(this.onSubmitted, this.scaffoldKey);
  }
}

class MovementBottomSheetState extends State<MovementBottomSheet> {
  MovementType _movementType = MovementType.SINGLE;

  final GlobalKey<ScaffoldState> scaffoldKey;

  MovementService service;

  MovementBottomSheetUtil movementBottomSheetUtil;

  TextEditingController expectingSetController =
      TextEditingController(text: '1');

  GiantSet _giantSet = GiantSet.fromObject(null);
  SingleMovementSet _regularSet = SingleMovementSet.fromOther(null);
  ReduceSet _reduceSet = ReduceSet.fromObject(null);

  String _currentWeight = "KG";

  final Function(List<ExerciseSet> newMovement) onSubmitted;

  MovementBottomSheetState(this.onSubmitted, this.scaffoldKey);

  @override
  void initState() {
    super.initState();
    service = MovementService(null);
    service.getMovements(ExerciseType.lifting).then((List<Movement> movements) {
      setState(() {
        movementBottomSheetUtil = MovementBottomSheetUtil(movements);
      });
    });
  }

  List<ExerciseSet> appendSets() {
    if (expectingSetController.text.isEmpty) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("训练组数不能为0")));
      throw Error();
    }
    if (_regularSet.movement == null) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("训练动作不能为空")));
      throw Error();
    }
    if (_regularSet.expectingWeight == null || _regularSet.expectingWeight <= 0) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("训练重量不正确")));
      throw Error();
    }
    if(_regularSet.expectingRepeatsPerSet == null || _regularSet.expectingRepeatsPerSet <=0 ){
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("每组重复次数不能为空")));
      throw Error();
    }
    if (_reduceSet.expectingWeight != null && _reduceSet.expectingWeight >= _reduceSet.reduceTo) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("递减组重量不正确")));
      throw Error();
    }
    switch (_movementType) {
      case MovementType.SINGLE:
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = SingleMovementSet.fromOther(_regularSet);
          instance.unit = _currentWeight;
          return instance;
        });
      case MovementType.REDUCE:
        _reduceSet.movement = _regularSet.movement;
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = ReduceSet.fromObject(_reduceSet);
          instance.copyFromRegularSet(_regularSet);
          instance.unit = _currentWeight;
          return instance;
        });
      case MovementType.GIANT:
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = GiantSet.fromObject(_giantSet);
          return instance;
        });
    }
    return [];
  }

  List<Widget> buildMovementDefinition(MovementType type) {
    switch (type) {
      case MovementType.SINGLE:
        // TODO: Handle this case.
        return [
          Column(
              mainAxisSize: MainAxisSize.min, children: basicMovementWidget())
        ];
      case MovementType.REDUCE:
        // TODO: Handle this case.
        return [
          Column(mainAxisSize: MainAxisSize.min, children: [
            ...basicMovementWidget(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration:
                          InputDecoration(labelText: '每组递减', suffixText: "KG"),
                      onChanged: (String value) {
                        _reduceSet.reduceWeight = double.parse(value);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 16, bottom: 8),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration:
                          InputDecoration(labelText: '递减至', suffixText: "KG"),
                      onChanged: (String value) {
                        _reduceSet.reduceTo = double.parse(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ])
        ];
      case MovementType.GIANT:
        return [
          ..._giantSet.movements.map((SingleMovementSet sm) {
            return ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              title: Text(sm.movement.name),
              dense: true,
            );
          }),
          Column(mainAxisSize: MainAxisSize.min, children: [
            ...basicMovementWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text("增加"),
                    onPressed: () {
                      if (expectingSetController.text.isEmpty) {
                        scaffoldKey.currentState
                            .showSnackBar(SnackBar(content: Text("重复组数不能为0")));
                        throw Error();
                      }
                      if (_regularSet.movement == null) {
                        scaffoldKey.currentState
                            .showSnackBar(SnackBar(content: Text("训练动作不能为空")));
                        throw Error();
                      }
                      setState(() {
                        _regularSet.unit = _currentWeight;
                        this._giantSet.movements.add(_regularSet);
                        _regularSet = SingleMovementSet.fromOther(null);
                      });
                    },
                  ),
                )
              ],
            )
          ])
        ];
    }
    return [];
  }

  List<Widget> basicMovementWidget() {
    if (movementBottomSheetUtil == null) {
      return [];
    }
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: movementBottomSheetUtil.buildMovementSearchBar((Movement data) {
          setState(() {
            this._regularSet.movement = data;
            this._regularSet.movement.exerciseType = ExerciseType.lifting;
          });
        }, TextEditingController()),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(labelText: '重复组数'),
                controller: expectingSetController,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration:
                    InputDecoration(labelText: '每组个数', hintText: "8~12个"),
                onChanged: (String value) {
                  setState(() {
                    this._regularSet.expectingRepeatsPerSet = int.parse(value);
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: '计划重量',
                    suffix: InkWell(
                      child: Text(_currentWeight),
                      onTap: () {
                        if (_currentWeight == "KG") {
                          _currentWeight = "%1RM";
                        } else if (_currentWeight == "%1RM") {
                          _currentWeight = "自重";
                        } else if (_currentWeight == "自重") {
                          _currentWeight = "KG";
                        }
                        setState(() {});
                      },
                    )),
                onChanged: (String value) {
                  setState(() {
                    this._regularSet.expectingWeight = double.parse(value);
                    this._regularSet.unit = _currentWeight;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget build(BuildContext buildContext) {
    var mediaQuery = MediaQuery.of(context);

    return Center(
      child: Card(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: AnimatedContainer(
          padding: mediaQuery.viewInsets,
          duration: const Duration(milliseconds: 300),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "训练动作",
                    style: Typography.dense2018.headline,
                  )
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  ...MovementType.values.map((MovementType t) => Expanded(
                        child: LabeledRadio<MovementType>(
                          value: t,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          label: Text(
                            MovementTypeLabelMap[t],
                            style: Typography.dense2018.body1,
                          ),
                          groupValue: _movementType,
                          onChanged: (MovementType value) {
                            setState(() {
                              _movementType = value;
                            });
                          },
                        ),
                      ))
                ],
              ),
              Divider(),
              ...buildMovementDefinition(_movementType),
              Divider(),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '加入训练',
                    style: Typography.dense2018.title,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  this.onSubmitted(appendSets());
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
