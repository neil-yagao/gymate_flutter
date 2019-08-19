import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

class HIITExerciseLine extends StatelessWidget {
  final SingleMovementSet sms;
  final int sequence;
  final int exerciseTime;
  final bool hasCompleted;

  HIITExerciseLine(this.sms, this.sequence, this.exerciseTime,this.hasCompleted);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: hasCompleted ? Color.fromRGBO(0, 0, 0, 0.05) : Colors.white,
        child: ListTile(
          dense: true,
            leading: CircleAvatar(
              backgroundColor: hasCompleted
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
              child: Text(sequence.toString()),
              foregroundColor: hasCompleted ? Colors.grey[700] : Colors.white,
            ),
            title: buildSingleRow(sms),
            trailing: IconButton(
              color: Colors.transparent,
              icon: Icon(
                Icons.done,
                color: hasCompleted ? Colors.green : Color.fromRGBO(0, 0, 0, 0.2),
              ),
            )));
  }

  Widget buildSingleRow(SingleMovementSet workingSet) {
    TextStyle textStyle;
    if (hasCompleted) {
      textStyle = TextStyle(color: Colors.grey[700], fontSize: 12);
    } else {
      textStyle = TextStyle(fontSize: 12);
    }
    String weight = "自重";
    if (workingSet.expectingWeight != 0) {
      weight += " + " + workingSet.expectingWeight.toString() + " KG";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: Text(
          workingSet.movement.name,
          style: textStyle,
        )),
        Expanded(
          child: Text(
            weight,
            style: textStyle,
          ),
        ),
        Expanded(
          child: Text("持续" + exerciseTime.toString() + "秒",
          style: textStyle,),
        )
      ],
    );
  }
}
