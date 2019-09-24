import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/plan_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import '../home_page.dart';

class TrainingPlanDetailState extends State<TrainingPlanDetail> {
  /**
   *    private String planGoal;

      private String planType;

      private int totalTrainingTrainingCycle;

      private int sessionPerTrainingCycle;

      private int trainingCycleDays;

      private String extraNote;

      private String trainingDates;
   */

  TextEditingController _planGoal = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _totalTrainingTrainingCycle =
      TextEditingController(text: "12");
  TextEditingController _sessionPerTrainingCycle;
  TextEditingController _trainingCycleDays = TextEditingController(text: "7");
  TextEditingController _extraNote = TextEditingController();

  List<Exercise> exerciseTemplate;

  List<Exercise> filedExerciseTemplate = List();

  GlobalKey<ScaffoldState> defaultState = GlobalKey<ScaffoldState>();

  PlanService planService;

  TrainingPlanDetailState({Key key, this.exerciseTemplate}) {
    _sessionPerTrainingCycle =
        TextEditingController(text: exerciseTemplate.length.toString());
  }

  User currentUser;

  @override
  void initState() {
    super.initState();
    planService = PlanService(defaultState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    fillWithRestExercise();
  }

  @override
  Widget build(BuildContext context) {
    //fillWithRestExercise();
    // TODO: implement build
    int exerciseIndex = 0;
    return Scaffold(
        key: defaultState,
        appBar: AppBar(
          title: Text("计划信息"),
          actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.all(0),
              textColor: Colors.white,
              child: Text(
                "创建",
              ),
              onPressed: () async {
                TrainingPlan proposalTrainingPlan = TrainingPlan.empty();
                proposalTrainingPlan.schedule = filedExerciseTemplate;
                proposalTrainingPlan.createdBy = currentUser;
                proposalTrainingPlan.extraNote = _extraNote.text;
                proposalTrainingPlan.sessionPerTrainingCycle =
                    int.parse(_sessionPerTrainingCycle.text);
                proposalTrainingPlan.totalTrainingCycle =
                    int.parse(_totalTrainingTrainingCycle.text);
                proposalTrainingPlan.planGoal = _planGoal.text;
                proposalTrainingPlan.trainingCycleDays =
                    int.parse(_trainingCycleDays.text);
                proposalTrainingPlan.name = _name.text;
                planService
                    .createTrainingPlan(proposalTrainingPlan)
                    .then((json) {
                  defaultState.currentState
                      .showSnackBar(SnackBar(content: Text("创建计划成功")))
                      .closed
                      .then((_) {
                    if (Navigator.of(context).canPop()) {
                      NavigationUtil.replaceUsingDefaultFadingTransition(
                          context, HomePage());
                    }
                  });
                });
              },
            )
          ],
        ),
        body: SafeArea(
//        child:
            child: ListView(shrinkWrap: true, children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: TextFormField(
              controller: _name,
              decoration: InputDecoration(isDense: true, labelText: "计划名称"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: TextFormField(
              controller: _planGoal,
              decoration: InputDecoration(isDense: true, labelText: "计划目标"),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2, left: 8, right: 4, bottom: 2),
                  child: TextField(
                    onChanged: (val) async {
                      if (int.parse(val) < exerciseTemplate.length) {
                        _trainingCycleDays.text =
                            exerciseTemplate.length.toString();
                      }
                      fillWithRestExercise();
                    },
                    textAlign: TextAlign.center,
                    controller: _trainingCycleDays,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        isDense: true, labelText: "训练周期", suffixText: "天"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2, left: 4, right: 4, bottom: 2),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _sessionPerTrainingCycle,
                    keyboardType: TextInputType.numberWithOptions(),
                    readOnly: true,
                    decoration: InputDecoration(
                        isDense: true, labelText: "每周期训练", suffixText: "天"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2, left: 4, right: 8, bottom: 2),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _totalTrainingTrainingCycle,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        isDense: true, labelText: "总共训练周期", suffixText: "个"),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: TextFormField(
              controller: _extraNote,
              maxLines: 2,
              decoration: InputDecoration(isDense: true, labelText: "计划说明"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ReorderableListView(
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
                            child:
                                Text(e.plannedSets.length.toString() + "个动作"),
                          )
                        ],
                      ),
                      subtitle: Text(e.description),
                      trailing: IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed: () {
                            /// only duplicate when exercise is not rest
                            /// and still not filling trainingCycles
                            if (e.plannedSets.length > 0 &&
                                exerciseTemplate.length <
                                    int.parse(_trainingCycleDays.text)) {
                              exerciseTemplate.add(e);
                              fillWithRestExercise();
                            }
                          }),
                    );
                  }),
                ],
              ),
            ),
          )
        ])));
  }

  void fillWithRestExercise() {
    List<Exercise> filledExercises = List();
    filledExercises.addAll(exerciseTemplate);
    for (int i = 0;
        i < int.parse(_trainingCycleDays.text) - exerciseTemplate.length;
        i++) {
      Exercise restingExercise = Exercise.empty();
      restingExercise.id = (0 - i).toString();
      restingExercise.name = "休息";
      restingExercise.plannedSets = List();
      restingExercise.description = "休息是为了更好的训练";
      filledExercises.add(restingExercise);
    }
    setState(() {
      filedExerciseTemplate = filledExercises;
    });
  }
}

class TrainingPlanDetail extends StatefulWidget {
  final List<Exercise> exerciseTemplate;

  TrainingPlanDetail({Key key, this.exerciseTemplate}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TrainingPlanDetailState(exerciseTemplate: exerciseTemplate);
  }
}
