import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

class PlanSchedule extends StatefulWidget {
  final List<Exercise> schedule;

  int totalCycleDay;

  final bool isEditable;

  PlanScheduleState currentState = PlanScheduleState();

  PlanSchedule({Key key, this.schedule, this.totalCycleDay, this.isEditable})
      : super(key: key);

  void fileRestExercise(int cycleDay) {
    this.totalCycleDay = cycleDay;
    currentState.fillWithRestExercise();
  }

  @override
  State<StatefulWidget> createState() {
    return currentState;
  }
}

class PlanScheduleState extends State<PlanSchedule> {
  List<Exercise> filedExerciseTemplate = List();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int exerciseIndex = 0;
    fillWithRestExercise();
    return ReorderableListView(
      header: Text(
        "包含的模板",
        style: Typography.dense2018.subhead,
      ),
      onReorder: (oldIndex, newIndex) {
        Exercise old = filedExerciseTemplate[oldIndex];
        if (oldIndex > newIndex) {
          for (int i = oldIndex; i > newIndex; i--) {
            filedExerciseTemplate[i] = filedExerciseTemplate[i - 1];
          }
          filedExerciseTemplate[newIndex] = old;
        } else {
          for (int i = oldIndex; i < newIndex - 1; i++) {
            filedExerciseTemplate[i] = filedExerciseTemplate[i + 1];
          }
          filedExerciseTemplate[newIndex - 1] = old;
        }
        setState(() {});
      },
      children: <Widget>[
        ...this.filedExerciseTemplate.map((Exercise e) {
          return ListTile(
            key: Key(e.id),
            leading: Text("第" + (++exerciseIndex).toString() + "天"),
            dense: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(e.name),
                ),
                Expanded(
                  child: Text(e.plannedSets.length.toString() + "组训练"),
                )
              ],
            ),
            subtitle: Text(e.description),
            trailing: widget.isEditable
                ? IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      /// only duplicate when exercise is not rest
                      /// and still not filling trainingCycles
                      if (e.plannedSets.length > 0 &&
                          widget.schedule.length < widget.totalCycleDay) {
                        widget.schedule.add(e);
                        fillWithRestExercise();
                      }
                    })
                : null,
          );
        }),
      ],
    );
  }

  void fillWithRestExercise() {
    List<Exercise> filledExercises = List();
    if (widget == null) {
      return;
    }
    filledExercises.addAll(widget.schedule);
    for (int i = 0; i < widget.totalCycleDay - widget.schedule.length; i++) {
      Exercise restingExercise = getRestingExercise(i);
      filledExercises.add(restingExercise);
    }

    ///replace null with rest
    for (int i = 0; i < filledExercises.length; i++) {
      if (filledExercises.elementAt(i) == null) {
        filledExercises[i] = getRestingExercise(i);
      }
    }
    setState(() {
      filedExerciseTemplate = filledExercises;
    });
  }

  Exercise getRestingExercise(int i) {
    Exercise restingExercise = Exercise.empty();
    restingExercise.id = (0 - i).toString();
    restingExercise.name = "休息";
    restingExercise.plannedSets = List();
    restingExercise.description = "休息是为了更好的训练";
    return restingExercise;
  }
}
