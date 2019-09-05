import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
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
  void didChangeDependencies() {
    _planService = PlanService(defaultState);
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
                        _selectedPlan = t;
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
                        _selectedPlan = null;
                      });
                    },
                  ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(t.name),
                ),
                Expanded(
                  child: Text(t.trainingCycleDays.toString() +
                      "天一个循环,每个循环训练" +
                      t.sessionPerTrainingCycle.toString() +
                      "天"),
                )
              ],
            ),
            subtitle: Text(t.extraNote),
            trailing: Text(t.planGoal),
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
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text("应用计划"),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
