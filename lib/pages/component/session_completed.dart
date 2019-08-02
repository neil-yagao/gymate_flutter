import 'package:flutter/material.dart';
import 'package:workout_helper/general/flip_panel.dart';
import 'package:workout_helper/model/entities.dart';

class SessionCompleted extends StatefulWidget {
  final ExerciseSet finishedSet;

  const SessionCompleted({Key key, this.finishedSet}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SessionCompletedState(finishedSet);
  }
}

class SessionCompletedState extends State<SessionCompleted> {
  final ExerciseSet finishedSet;

  bool countdownEnds = false;

  TextEditingController number;
  TextEditingController weight;

  SessionCompletedState(this.finishedSet);

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
    }
  }

  FlipClock buildCountdown() {
    return FlipClock.countdown(
      duration: Duration(seconds: 10),
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
                }
              },
            )),
            Expanded(
                child: TextField(
              textAlign: TextAlign.center,
              controller: number,
            )),
            Expanded(
                child: IconButton(
              iconSize: 15,
              icon: Icon(Icons.add),
              onPressed: () {
                number.text = (int.parse(number.text) + 1).toString();
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
                }
              },
            )),
            Expanded(
                child: TextField(
              controller: weight,
              textAlign: TextAlign.center,
              decoration: InputDecoration(isDense: true, suffixText: 'KG'),
            )),
            Expanded(
                child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text('+0.5', style: Typography.dense2018.button),
              onPressed: () {
                weight.text = (double.parse(weight.text) + 0.5).toString();
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
            Expanded(flex: 2, child: buildCountdown()),
          ],
        ),
      ]),
    )));
  }
}
