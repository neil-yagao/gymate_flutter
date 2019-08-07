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
    CompletedExerciseSet set = CompletedExerciseSet();
    set.accomplishedSet = this.finishedSet;
    set.id = uuid.v4().toString();
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
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "完成数量：",
                  style: Typography.dense2018.subtitle,
                ),
              ),
            ),
            Expanded(
                child: IconButton(
              iconSize: 15,
              icon: Icon(Icons.remove),
              onPressed: () {
                if (int.parse(number.text) > 0) {
                  number.text = (int.parse(number.text) - 1).toString();
                  this.emittingCompletedInfo();
                }
              },
            )),
            Expanded(
                child: TextField(
              textAlign: TextAlign.center,
              controller: number,
              keyboardType: TextInputType.numberWithOptions(),
            )),
            Expanded(
                child: IconButton(
              iconSize: 15,
              icon: Icon(Icons.add),
              onPressed: () {
                number.text = (int.parse(number.text) + 1).toString();
                this.emittingCompletedInfo();
              },
            )),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "完成重量：",
                  style: Typography.dense2018.subtitle,
                ),
              ),
            ),
            Expanded(
                child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '-0.5',
                style: Typography.dense2018.button,
              ),
              onPressed: () {
                if (double.parse(weight.text) > 0) {
                  weight.text = (double.parse(weight.text) - 0.5).toString();
                  this.emittingCompletedInfo();
                }
              },
            )),
            Expanded(
                child: TextField(
              controller: weight,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(isDense: true, suffixText: 'KG'),
            )),
            Expanded(
                child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text('+0.5', style: Typography.dense2018.button),
              onPressed: () {
                weight.text = (double.parse(weight.text) + 0.5).toString();
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
