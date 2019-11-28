import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/pages/general/session_util.dart';
import 'package:workout_helper/pages/session/exercise_set_line.dart';
import 'package:workout_helper/service/session_service.dart';

class ExercisePreview extends StatefulWidget {
  final Exercise exercise;

  const ExercisePreview({Key key, this.exercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExercisePreviewState();
  }
}

class ExercisePreviewState extends State<ExercisePreview> {
  int expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    int index = -1;

    Map<Movement, List<ExerciseSet>> movementMap =
        SessionService.groupExerciseSetViaMovement(widget.exercise.plannedSets);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.grey[200],
        width: MediaQuery.of(context).size.width * 0.999,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
            child: ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  if (isExpanded) {
                    expandedIndex = -1;
                  } else {
                    expandedIndex = index;
                  }
                  setState(() {});
                },
                children: [
              ...movementMap.keys.map((movement) {
                index += 1;
                if (movement.exerciseType == ExerciseType.cardio) {
                  return SessionUtil.getCardioPanel(
                      movement,
                      movementMap[movement],
                      index == expandedIndex,
                      ListTile(title: Text(movement.name)));
                }
                int sequence = -1;
                return ExpansionPanel(
                    isExpanded: index == expandedIndex,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(movement.name),
                      );
                    },
                    body: Card(
                      child: ListView(shrinkWrap: true, children: <Widget>[
                        ...movementMap[movement].map((ExerciseSet exerciseSet) {
                          sequence += 1;
                          return exerciseSetToListTile(exerciseSet, sequence);
                        })
                      ]),
                    ));
              })
            ])),
      ),
    );
  }

  Widget exerciseSetToListTile(ExerciseSet es, int index) {
    es.sequence = index;
    return ExerciseSetLine(
        workingSet: es,
        completed: false,
        onDeletedClicked: (String id) {},
        onCompletedClicked: (ExerciseSet es) {});
  }
}
