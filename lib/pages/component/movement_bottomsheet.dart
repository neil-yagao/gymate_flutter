import 'package:flutter/material.dart';
import 'package:workout_helper/general/autocomplete.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'label_radio.dart';

const MovementTypeLabelMap = {
  MovementType.SINGLE: "常规组",
  MovementType.REDUCE: '递减组',
  MovementType.GIANT: '超级组'
};

class MovementBottomSheet extends StatefulWidget {
  final Function(List<ExerciseSet> newMovement) onSubmitted;

  const MovementBottomSheet({Key key, this.onSubmitted}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovementBottomSheetState(this.onSubmitted);
  }
}

class MovementBottomSheetState extends State<MovementBottomSheet> {
  MovementType _movementType = MovementType.SINGLE;

  MovementService service = MovementService();
  TextEditingController expectingSetController =
      TextEditingController(text: '1');

  GiantSet _giantSet = GiantSet(null);
  SingleMovementSet _regularSet = SingleMovementSet(null);
  ReduceSet _reduceSet = ReduceSet(null);

  final Function(List<ExerciseSet> newMovement) onSubmitted;

  MovementBottomSheetState(this.onSubmitted);

  List<ExerciseSet> appendSets() {
    switch (_movementType) {
      case MovementType.SINGLE:
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = SingleMovementSet(_regularSet);
          return instance;
        });
      case MovementType.REDUCE:
        _reduceSet.movement = _regularSet.movement;
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = ReduceSet(_reduceSet);
          instance.copyFromRegularSet(_regularSet);
          return instance;
        });
      case MovementType.GIANT:
        return List.generate(int.parse(expectingSetController.text),
            (int index) {
          var instance = GiantSet(_giantSet);
          return instance;
        });
    }
    return [];
  }

  AutoCompleteTextField<Movement> buildMovementSearchBar() {
    return AutoCompleteTextField<Movement>(
      itemBuilder: (BuildContext context, Movement suggestion) {
        return ListTile(
            title: Text(suggestion.name, style: Typography.dense2018.caption));
      },
      itemFilter: (Movement suggestion, String query) =>
          suggestion.name.indexOf(query) >= 0,
      suggestions: service.getMovements(),
      itemSorter: (Movement a, Movement b) {
        return a.name.compareTo(b.name);
      },
      clearOnSubmit: false,
      itemSubmitted: (Movement data) {
        setState(() {
          this._regularSet.movement = data;
        });
      },
      decoration:
          InputDecoration(labelText: "训练动作", suffixIcon: Icon(Icons.search)),
    );
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
                      setState(() {
                        this._giantSet.movements.add(_regularSet);
                        _regularSet = SingleMovementSet(null);
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
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildMovementSearchBar(),
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
                decoration:
                    InputDecoration(labelText: '计划重量', suffixText: "KG"),
                onChanged: (String value) {
                  setState(() {
                    this._regularSet.expectingWeight = double.parse(value);
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
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
    );
  }
}
