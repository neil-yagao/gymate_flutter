import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

class ExerciseTemplateSelection extends StatefulWidget {
  final String title;
  final List<Exercise> templates;

  const ExerciseTemplateSelection({Key key, this.title, this.templates}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExerciseTemplateSelectionState(this.title);
  }
}

class ExerciseTemplateSelectionState extends State<ExerciseTemplateSelection> {

  Exercise _selectedExercise;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();

  String title;

  ExerciseTemplateSelectionState(this.title) {
    if (title == null) {
      this.title = "选择已保存的模板";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          _selectedExercise == null?Text(""):FlatButton(
            textColor: Colors.white,
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop(_selectedExercise);
            },
          )
        ],
      ),
      body: SafeArea(
          child: ListView(
        children:
            widget.templates.where((Exercise e) => e.name != null).map((Exercise e) {
          return ListTile(
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
            leading: _selectedExercise != null && _selectedExercise.id == e.id
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : Text(""),
            onTap: () {
              setState(() {
                _selectedExercise = e;
              });
            },
          );
        }).toList(),
      )),
    );
  }
}
