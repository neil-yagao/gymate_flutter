import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/plan_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'package:workout_helper/pages/home/home_page.dart';
import 'package:workout_helper/pages/exercise/plan_schedule.dart';

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

  PlanSchedule schedule;

  @override
  void initState() {
    super.initState();
    planService = PlanService(defaultState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentUser = Provider.of<CurrentUserStore>(context).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    //fillWithRestExercise();
    // TODO: implement build
    schedule = PlanSchedule(
      totalCycleDay: int.parse(_trainingCycleDays.text),
      schedule: exerciseTemplate,
      isEditable: true,
    );
    return Scaffold(
        key: defaultState,
        appBar: DefaultAppBar.build(context,
          title: "计划信息",
          actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.all(0),
              textColor: Theme.of(context).primaryColor,
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
                      if (val.isEmpty) {
                        return;
                      }
                      if (int.parse(val) < exerciseTemplate.length) {
                        _trainingCycleDays.text =
                            exerciseTemplate.length.toString();
                      }
                      setState(() {
                        schedule.fileRestExercise(
                            int.parse(_trainingCycleDays.text));
                      });
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
              child: schedule,
            ),
          )
        ])));
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
