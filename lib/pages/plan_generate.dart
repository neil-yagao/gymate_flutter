import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'component/training_plan_detail.dart';

class PlanGenerate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanGenerateState();
  }
}

class PlanGenerateState extends State<PlanGenerate> {
  List<Exercise> _selectedExercises = List();

  List<Exercise> _templates = List();

  ExerciseService _service = ExerciseService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedExercises = List();
    _service
        .getUserExerciseTemplate(
            Provider.of<CurrentUserStore>(context).currentUser.id)
        .then((List<Exercise> exercises) {
      setState(() {
        _templates = exercises;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已保存的模板"),
      ),
      body: SafeArea(
        child: ListView(
          children: _templates
              .where((Exercise e) => e.name != null)
              .map((Exercise e) {
            return ListTile(
              dense: true,
              leading: _selectedExercises.contains(e)
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Text(""),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(e.name),
                  ),
                  Expanded(
                    child: Text(e.plannedSets.length.toString() + "个动作"),
                  )
                ],
              ),
              subtitle: Text(e.description),
              onTap: () {
                setState(() {
                  if (_selectedExercises.contains(e)) {
                    _selectedExercises.remove(e);
                  } else {
                    _selectedExercises.add(e);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              textColor: _selectedExercises.length > 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              child: Text("创建计划"),
              onPressed: () {
                NavigationUtil.pushUsingDefaultFadingTransition(context,
                    TrainingPlanDetail(exerciseTemplate: _selectedExercises));
              },
            )
          ],
        ),
      ),
    );
  }
}
