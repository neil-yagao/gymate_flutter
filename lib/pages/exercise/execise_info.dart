import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';
import 'package:workout_helper/service/plan_service.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';


class ExerciseInfo extends StatefulWidget {
  final List<UserPlannedExercise> plannedExercise;

  const ExerciseInfo({Key key, this.plannedExercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExerciseInfoState(plannedExercise);
  }
}

class ExerciseInfoState extends State<ExerciseInfo> {
  final List<UserPlannedExercise> plannedExercise;

  PlanService _trainingPlanService;

  ExerciseInfoState(this.plannedExercise);

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ExerciseService _exerciseService;

  List<Exercise> _exercises = List();

  int expandedIndex = -1;

  User _currentUser;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _trainingPlanService = PlanService(_key);
    _exerciseService = ExerciseService(_key);
    List<Future<Exercise>> exercisesFuture = List();
    plannedExercise.forEach((UserPlannedExercise upe) {
      exercisesFuture.add(_exerciseService.getExercise(upe.exercise.id));
    });
    Future.wait(exercisesFuture).then((List<Exercise> exercise) {
      setState(() {
        _exercises = exercise;
        expandedIndex = exercise.length - 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String date =
        DateFormat('yyyy-MM-dd').format(plannedExercise[0].executeDate);
    int index = -1;
    return Scaffold(
      key: _key,
      appBar: DefaultAppBar.build(context,
        title: date + "计划",
      ),
      body: SingleChildScrollView(
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
          ..._exercises.map((exercise) {
            Map<Movement, List<ExerciseSet>> movementMap =
                SessionService.groupExerciseSetViaMovement(
                    exercise.plannedSets);
            index += 1;
            return ExpansionPanel(
                isExpanded: index == expandedIndex,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(exercise.name),
                  );
                },
                body: Card(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ...movementMap.keys.map((movement) {
                        return ListTile(
                          title: Text(movement.name),
                          trailing: Text(
                              movementMap[movement].length.toString() + "组"),
                        );
                      }),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              "与今天的计划交换",
                              style: Typography.dense2018.subhead,
                            ),
                            onPressed: () {
                              UserPlannedExercise matchedExercise =
                                  plannedExercise.firstWhere(
                                      (upe) => upe.exercise.id == exercise.id);
                              _trainingPlanService
                                  .switchPlannedExerciseWithTodayExercise(
                                      _currentUser.id, matchedExercise)
                                  .then((_) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text("交换成功!",style: Typography.dense2018.subhead,),
                                          ),
                                        ),
                                      );
                                    }).then((_) {
//                                  NavigationUtil
//                                      .replaceUsingDefaultFadingTransition(
//                                          context, HomePage());
                                });
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ));
          })
        ],
      )),
    );
  }
}
