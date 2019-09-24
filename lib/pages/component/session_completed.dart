import 'package:flutter/material.dart';
import 'package:workout_helper/general/flip_panel.dart';
import 'package:workout_helper/model/entities.dart';

const int MAX_RESTING_MINS = 20;

class SessionCompleted extends StatefulWidget {
  final ExerciseSet finishedSet;

  final Function(CompletedExerciseSet ces) updateCompletedInfo;
  SessionCompletedState scs;

  SessionCompleted(
      {Key key, this.finishedSet, @required this.updateCompletedInfo})
      : super(key: key) {
    scs = SessionCompletedState(finishedSet, updateCompletedInfo);
  }

  void emitCompletedInfo() {
    scs.emittingCompletedInfo();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return scs;
  }
}

class SessionCompletedState extends State<SessionCompleted> {
  final ExerciseSet finishedSet;

  final Function(CompletedExerciseSet ces) updateCompletedInfo;

  bool countdownEnds = false;

  TextEditingController number;
  TextEditingController weight;

  DateTime createTime;

  SessionCompletedState(this.finishedSet, this.updateCompletedInfo);

  @override
  void initState() {
    super.initState();
    if (finishedSet is SingleMovementSet) {
      number = new TextEditingController(
          text: (finishedSet as SingleMovementSet)
              .expectingRepeatsPerSet
              .toString());
      weight = new TextEditingController(
          text: (finishedSet as SingleMovementSet).expectingWeight.toString());
    } else {
      // giant set
      number = new TextEditingController(
          text: (finishedSet as GiantSet)
              .movements
              .fold(
                  0,
                  (int previousValue, SingleMovementSet sms) =>
                      previousValue + sms.expectingRepeatsPerSet)
              .toString());
      weight = new TextEditingController(
          text: (finishedSet as GiantSet)
              .movements
              .fold(
                  0.0,
                  (double previous, SingleMovementSet sms) =>
                      previous + sms.expectingWeight)
              .toString());
    }

    createTime = DateTime.now();
  }

  FlipClock restingCount;

  FlipClock buildRestingCount() {
    restingCount = FlipClock.simple(
      startTime: DateTime(2018, 0, 0, 0, 0),
      timeLeft: Duration(minutes: MAX_RESTING_MINS),
      digitColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      digitSize: 60,
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      onCountDownEnd: () {
        setState(() {
          Navigator.of(context).maybePop();
        });
      },
    );
    return restingCount;
  }

  void emittingCompletedInfo() {
    CompletedExerciseSet set = CompletedExerciseSet.empty();
    set.accomplishedSet = this.finishedSet;
    set.id = DateTime.now().millisecondsSinceEpoch;
    set.weight = double.parse(weight.text);
    set.repeats = int.parse(number.text);
    set.restAfterAccomplished = createTime.difference(DateTime.now()).inSeconds;
    this.updateCompletedInfo(set);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
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
                  this.emittingCompletedInfo();
                }
              },
            )),
            Expanded(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child:Text(
                    '-1',
                    style: Typography.dense2018.button,
                  ),
              onPressed: () {
                if (int.parse(number.text) > 0) {
                  number.text = (int.parse(number.text) - 1).toString();
                  this.emittingCompletedInfo();
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
                  child:Text(
                    '+1',
                    style: Typography.dense2018.button,
                  ),
              onPressed: () {
                number.text = (int.parse(number.text) + 1).toString();
                this.emittingCompletedInfo();
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
                this.emittingCompletedInfo();
              },
            )),
          ],
        ),
        Row(
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
                  this.emittingCompletedInfo();
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
                  this.emittingCompletedInfo();
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
                  this.emittingCompletedInfo();
                }
              },
            )),
            Expanded(
                flex: 2,
                child: TextField(
                  controller: weight,
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
                this.emittingCompletedInfo();
              },
            )),
            Expanded(
                child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Text('+10', style: Typography.dense2018.button),
              onPressed: () {
                weight.text = (double.parse(weight.text) + 10).toString();
                this.emittingCompletedInfo();
              },
            )),
          ],
        ),
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
            Expanded(flex: 2, child: buildRestingCount()),
          ],
        ),
      ]),
    )));
  }
}
