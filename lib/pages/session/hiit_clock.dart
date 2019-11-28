import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

class HiitClock extends StatefulWidget {
  final SingleMovementSet sms;
  final int exerciseTime;

  final int restTime;

  final Function exerciseRestLoopEndCallback;

  const HiitClock(
      {Key key,
      this.sms,
      this.exerciseTime,
      this.restTime,
      this.exerciseRestLoopEndCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HiitClockState(this.sms, this.exerciseTime, this.restTime,
        this.exerciseRestLoopEndCallback);
  }
}

class HiitClockState extends State<HiitClock> {
  double _value = 0;
  int _second;
  double division;
  bool exercisePhase = true;

  final SingleMovementSet sms;
  final int exerciseTime;
  final int restTime;
  final Function exerciseRestLoopEndCallback;

  Timer t;

  HiitClockState(this.sms, this.exerciseTime, this.restTime,
      this.exerciseRestLoopEndCallback) {
    _second = exerciseTime;
    division = 1 / exerciseTime;
  }

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _value += division;
        _second--;
        if(_second < 0 && exercisePhase){//turn to resting
          exercisePhase = false;
          _second = restTime;
          division = 1/restTime;
          _value = 0;
        }else if(_second <= 0 && !exercisePhase){
          this.exerciseRestLoopEndCallback();
        }
      });
    });
  }

  @override
  void dispose(){
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: ListView(
              shrinkWrap: true,
              addRepaintBoundaries: true,
              padding: const EdgeInsets.all(8.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      exercisePhase?sms.movement.name:"休息",
                      style: Typography.dense2018.headline,
                    ),
                  ],
                ),
                Divider(),
                Container(
                  height: MediaQuery.of(context).size.width - 40,
                  child: Stack(fit: StackFit.expand, children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        semanticsLabel: "label",
                        semanticsValue: "sValue",
                        value: _value,
                      ),
                    ),
                    Center(
                        child: Text(
                      _second.toString() + "秒",
                      style: Typography.dense2018.display4,
                    ))
                  ]),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).maybePop();
                    },
                    textColor: Colors.grey,
                    child: Text("取消训练"),
                  )
                ])
              ]),
        ),
      ),
    );
  }
}
