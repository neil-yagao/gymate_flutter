import 'package:flutter/material.dart';
import 'package:workout_helper/general/flip_panel.dart';
import 'package:workout_helper/model/entities.dart';

import 'flip_count_down_util.dart';

const int MAX_RESTING_MINS = 20;

class SessionCompleted extends StatefulWidget {
  final ExerciseSet finishedSet;

  final int startSecond;
  double savedWeight;
  int savedRepeat;

  SessionCompletedState scs;

  SessionCompleted({
    Key key,
    this.finishedSet,
    this.startSecond,
    this.savedWeight,
    this.savedRepeat,
  }) : super(key: key) {
    scs = SessionCompletedState(finishedSet);
  }

  CompletedExerciseSet emitCompletedInfo() {
    return scs.emittingCompletedInfo();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return scs;
  }
}

class SessionCompletedState extends State<SessionCompleted> {
  final ExerciseSet finishedSet;

  bool countdownEnds = false;

  TextEditingController number;
  TextEditingController weight;

  List<TextEditingController> giantSetNumbers = new List();
  List<TextEditingController> giantSetWeights = new List();

  DateTime createTime;

  SessionCompletedState(this.finishedSet);

  @override
  void initState() {
    super.initState();

    if (finishedSet is SingleMovementSet) {
      number = new TextEditingController(
          text: widget.savedRepeat == null
              ? (finishedSet as SingleMovementSet)
                  .expectingRepeatsPerSet
                  .toString()
              : widget.savedRepeat.toString());
      weight = new TextEditingController(
          text: widget.savedWeight == null
              ? (finishedSet as SingleMovementSet).expectingWeight.toString()
              : widget.savedWeight.toString());
    } else {
      // giant set
      (finishedSet as GiantSet).movements.forEach((sms) {
        TextEditingController giantSetNumber = new TextEditingController(
            text: sms.expectingRepeatsPerSet.toString());
        giantSetNumbers.add(giantSetNumber);
        TextEditingController giantSetWeight =
            new TextEditingController(text: sms.expectingWeight.toString());
        giantSetWeights.add(giantSetWeight);
      });
    }
    createTime = DateTime.now();
  }

  FlipClock restingCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    restingCount = FlipCountDownUtil.buildRestingCount(
      widget.startSecond,
      () => setState(() {
        Navigator.of(context).maybePop();
      }),
      context,
    );
  }

  CompletedExerciseSet emittingCompletedInfo() {
    CompletedExerciseSet set = CompletedExerciseSet.empty();
    set.accomplishedSet = this.finishedSet;
    set.id = DateTime.now().millisecondsSinceEpoch;
    if (finishedSet is GiantSet) {
      double totalVolume = 0;
      int totalRepeats = 0;

      for (int i = 0; i < giantSetNumbers.length; i++) {
        SingleMovementSet sms =
            (finishedSet as GiantSet).movements.elementAt(i);
        int finishedRepeats = int.parse(giantSetNumbers.elementAt(i).text);
        double finishedWeight = double.parse(giantSetWeights.elementAt(i).text);
        sms.expectingRepeatsPerSet = finishedRepeats;
        sms.expectingWeight = finishedWeight;
        totalVolume += finishedRepeats * finishedWeight;
        totalRepeats += finishedRepeats;
      }
      set.weight = totalVolume;
      set.repeats = totalRepeats;
    } else {
      set.weight = double.parse(weight.text);
      set.repeats = int.parse(number.text);
    }
    set.restAfterAccomplished =
        DateTime.now().difference(createTime).inSeconds + widget.startSecond;
    return set;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ...getCompletedList(),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    "休息间隔：",
                    style: Typography.dense2018.subtitle,
                  ),
                ),
              ),
              Expanded(flex: 2, child: restingCount),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).maybePop("minimize");
                  },
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Icon(Icons.check, color: Colors.greenAccent),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
            ],
          )
        ]),
      )),
    );
  }

  List<Widget> getCompletedList() {
    if (finishedSet is SingleMovementSet)
      return [
        countRow(number),
        weightRow(weight),
      ];
    else {
      List<Widget> widgets = [];
      int index = 0;
      (finishedSet as GiantSet).movements.forEach((sms) {
        widgets.add(Text(
          sms.movement.name,
          style: Typography.dense2018.subtitle,
        ));
        widgets.add(countRow(giantSetNumbers.elementAt(index)));
        widgets.add(weightRow(giantSetWeights.elementAt(index)));
        index++;
      });
      return widgets;
    }
  }

  Row weightRow(TextEditingController weight) {
    return Row(
      children: <Widget>[
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '-10',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            if (double.parse(weight.text) > 10) {
              weight.text = (double.parse(weight.text) - 10).toString();
            }
          },
        )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '-5',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            if (double.parse(weight.text) > 5) {
              weight.text = (double.parse(weight.text) - 5).toString();
            }
          },
        )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '-2.5',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            if (double.parse(weight.text) > 2.5) {
              weight.text = (double.parse(weight.text) - 2.5).toString();
            }
          },
        )),
        Expanded(
            flex: 2,
            child: TextField(
              controller: weight,
              onTap: () {
                weight.selection = TextSelection(
                    baseOffset: 0, extentOffset: weight.text.length);
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(isDense: true, suffixText: 'KG'),
            )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text('+2.5', style: Typography.dense2018.button),
          onPressed: () {
            weight.text = (double.parse(weight.text) + 2.5).toString();
            this.emittingCompletedInfo();
          },
        )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text('+5', style: Typography.dense2018.button),
          onPressed: () {
            weight.text = (double.parse(weight.text) + 5).toString();
          },
        )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text('+10', style: Typography.dense2018.button),
          onPressed: () {
            weight.text = (double.parse(weight.text) + 10).toString();
          },
        )),
      ],
    );
  }

  Row countRow(TextEditingController number) {
    return Row(
      children: <Widget>[
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '-5',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            if (double.parse(number.text) >= 5) {
              number.text = (int.parse(number.text) - 5).toString();
            }
          },
        )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '-1',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            if (int.parse(number.text) > 0) {
              number.text = (int.parse(number.text) - 1).toString();
            }
          },
        )),
        Expanded(
            flex: 2,
            child: TextField(
              textAlign: TextAlign.center,
              controller: number,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(suffixText: "个"),
            )),
        Expanded(
            child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            '+1',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            number.text = (int.parse(number.text) + 1).toString();
          },
        )),
        Expanded(
            child: FlatButton(
          child: Text(
            '+5',
            style: Typography.dense2018.button,
          ),
          onPressed: () {
            number.text = (int.parse(number.text) + 5).toString();
          },
        )),
      ],
    );
  }
}
