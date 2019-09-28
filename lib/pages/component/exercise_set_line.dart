import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_helper/model/entities.dart';

class ExerciseSetLine extends StatefulWidget {
  final ExerciseSet workingSet;
  final Function(String) onDeletedClicked;
  final Function(ExerciseSet) onCompletedClicked;
  final bool hasCompleted;

  const ExerciseSetLine(
      {Key key,
      @required this.workingSet,
      this.onDeletedClicked,
      this.onCompletedClicked,
      this.hasCompleted = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExerciseSetLineState(
        workingSet, onDeletedClicked, onCompletedClicked,this.hasCompleted);
  }
}

class ExerciseSetLineState extends State<ExerciseSetLine> {
  bool completed = false;

  final ExerciseSet workingSet;
  final Function(String) onDeletedClicked;
  final Function(ExerciseSet) onCompletedClicked;

  ExerciseSetLineState(
      this.workingSet, this.onDeletedClicked, this.onCompletedClicked, this.completed);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Slidable(
      enabled: !completed,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
          color: completed ? Color.fromRGBO(0, 0, 0, 0.05) : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: completed
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
              child: Text((workingSet.sequence + 1).toString()),
              foregroundColor: completed ? Colors.grey[700] : Colors.white,
            ),
            title: buildSingleRow(workingSet, completed),
            trailing: IconButton(
                color: Colors.transparent,
                icon: Icon(
                  Icons.done,
                  color:
                      completed ? Colors.green : Color.fromRGBO(0, 0, 0, 0.2),
                ),
                onPressed: () {
                  setState(() {
                    completed = true;
                    if (onCompletedClicked != null) {
                      onCompletedClicked(workingSet);
                    }
                  });
                }),
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            onDeletedClicked(workingSet.id);
          },
        ),
      ],
    );
  }

  Widget buildSingleRow(ExerciseSet es, bool completed) {
    TextStyle textStyle;
    if (completed) {
      textStyle = TextStyle(color: Colors.grey[700], fontSize: 12);
    } else {
      textStyle = TextStyle(fontSize: 12);
    }
    if (es is ReduceSet) {
      String subtitle = "递减" +
          ((es.expectingWeight - es.reduceTo) / es.reduceWeight)
              .floor()
              .toString() +
          "组 每组减少" +
          es.reduceWeight.toString() +
          es.unit == null?"KG":es.unit;

      return ListTile(
        dense: true,
        title: exerciseContent(es, textStyle),
        subtitle: Text(subtitle),
      );
    } else if (es is SingleMovementSet) {
      return ListTile(
          dense: true,
          title: exerciseContent(es, textStyle));
    } else {
      //giant Set
      GiantSet giantSet = es as GiantSet;
      List<Widget> superSetWidget = List();
      giantSet.movements.forEach((SingleMovementSet sms) {
        superSetWidget.add(exerciseContent(sms, textStyle));
        superSetWidget.add(Divider());
      });
      superSetWidget = superSetWidget.sublist(0, superSetWidget.length - 1);
      return ListTile(
          dense: true,
          title: Column(
        children: superSetWidget,
      ));
    }
  }

  Widget exerciseContent(SingleMovementSet es, TextStyle textStyle) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          es.movement.name,
          style: textStyle,
        )),
        Expanded(
          child: Text(
            es.expectingRepeatsPerSet.toString() +
                ' X   ' +
                es.expectingWeight.toString() +
                es.unit,
            style: textStyle,
          ),
        )
      ],
    );
  }
}
//              ],
