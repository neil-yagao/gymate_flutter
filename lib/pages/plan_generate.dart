import 'package:dio/dio.dart';
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ExerciseService _service;

  User _currentUser;

  String sharedTo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedExercises = List();
    _service = ExerciseService(_scaffoldKey);
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _service
        .getUserExerciseTemplate(
           _currentUser.id)
        .then((List<Exercise> exercises) {
      setState(() {
        _templates = exercises;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
            FlatButton(
              textColor: _selectedExercises.length > 0
                  ? Colors.lightBlueAccent
                  : Colors.grey,
              child: Text("分享给朋友"),
              onPressed: () {
                showSharingAlert();
              },
            )
          ],
        ),
      ),
    );
  }

  showSharingAlert() {
    showDialog<String>(
        context: context,
        builder: (context) {
          String groupCode = '';
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      "请输入朋友的注册手机号",
                      style: Typography.dense2018.subhead
                          .merge(TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (val) {
                        sharedTo = val;
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: FlatButton(
                          child: Text("确定"),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).maybePop(sharedTo);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }).then((mobile) {
          if(_selectedExercises.length > 0){
            List<Future> sharedExercise = List();
            for(Exercise exercise in _selectedExercises){
              sharedExercise.add(_service.shareExerciseTo(exercise, _currentUser.id, mobile));
            }
            Future.wait(sharedExercise).then((_){
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("分享成功")));
            }).catchError((err){
              if(err is DioError) {
                if(err.response.statusCode == 500){
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.response.data['message'])));
                }else {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("网络不给力啊！")));
                }
              }
            });
          }
    });
  }
}
