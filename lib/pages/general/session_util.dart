import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';

class SessionUtil {
  static ExpansionPanel getCardioPanel(Movement movement, List<ExerciseSet> sets,
      bool isExpanded, Widget header) {
    return ExpansionPanel(
        isExpanded: isExpanded,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return header;
        },
        body: ListView(
            shrinkWrap: true,
            children: sets.map((ExerciseSet es) {
              debugPrint(es.toJson().toString());
              CardioSet cs = es as CardioSet;
              return ListTile(
                  dense: true,
                  leading: IconButton(
                    color: Colors.transparent,
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: null,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: cs.exerciseTime == null || cs.exerciseTime == 0
                        ? [
                      Expanded(
                        child: Text(cs.movementName),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(cs.exerciseDistance.toString() + "步"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("约" +
                            cs.exerciseCals.floor().toString() +
                            "kCal"),
                      ),
                    ]
                        : <Widget>[
                      Expanded(
                        child: Text(cs.movementName),
                      ),
                      Expanded(
                        child:
                        Text(cs.exerciseDistance.toString() + "KM"),
                      ),
                      Expanded(
                        child: Text(cs.exerciseTime.toString() + "分钟"),
                      ),
                      Expanded(
                        child: Text("约" +
                            cs.exerciseCals.floor().toString() +
                            "kCal"),
                      ),
                    ],
                  ));
            }).toList()));
  }
}