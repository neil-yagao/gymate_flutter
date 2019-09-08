import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/plan_service.dart';

class TrainingPlanSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TrainingPlanSelectionState();
  }
}

class TrainingPlanSelectionState extends State<TrainingPlanSelection> {
  PlanService _planService;

  GlobalKey<ScaffoldState> defaultState = GlobalKey<ScaffoldState>();

  List<TrainingPlan> _availablePlans = List();

  TrainingPlan _selectedPlan;

  @override
  void initState(){
    super.initState();
    _planService = PlanService(defaultState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _planService.getAllTrainingPlans().then((List<TrainingPlan> plans) {
      setState(() {
        _availablePlans = plans;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("训练计划选择"),
      ),
      body: SafeArea(
        key: defaultState,
          child: ListView(
        children: _availablePlans.map((TrainingPlan t) {
          return ListTile(
            leading: _selectedPlan == t
                ? InkWell(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPlan = null;
                      });
                    },
                  )
                : InkWell(
                    child: Icon(
                      Icons.check,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPlan = t;
                      });
                    },
                  ),
            title: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(t.name),
                ),
                Expanded(
                  child: Text(t.planGoal),
                )
              ],
            ),
            subtitle: Text(t.extraNote),
            trailing: Text(
              "练" +
                  t.sessionPerTrainingCycle.toString() +
                  "休" +
                  (t.trainingCycleDays - t.sessionPerTrainingCycle).toString(),
              style: Typography.dense2018.caption,
            ),
            isThreeLine: t.extraNote.length > 20,
            onTap: () {},
          );
        }).toList(growable: true),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                textColor: _selectedPlan == null
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                child: Text(
                  "应用计划",style: Typography.dense2018.caption,
                ),
                onPressed: () {
                  User user = Provider.of<CurrentUserStore>(context).currentUser;
                  _planService.applyPlanToUser(_selectedPlan, user.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
