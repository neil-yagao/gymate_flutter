import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';

class ExerciseTemplateSelection extends StatefulWidget {
  final String title;

  const ExerciseTemplateSelection({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExerciseTemplateSelectionState(this.title);
  }
}

class ExerciseTemplateSelectionState extends State<ExerciseTemplateSelection> {
  ExerciseService _service;

  List<Exercise> _template = List();

  Exercise _selectedExercise;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();

  String title;

  ExerciseTemplateSelectionState(this.title) {
    if (title == null) {
      this.title = "选择已保存的模板";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _service = ExerciseService(_scaffoldKey);
    _service
        .getUserExerciseTemplate(
            Provider.of<CurrentUserStore>(context).currentUser.id)
        .then((List<Exercise> exercises) {
      setState(() {
        _template = exercises;
      });
    });
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
            _template.where((Exercise e) => e.name != null).map((Exercise e) {
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
                  child: Text(e.plannedSets.length.toString() + "个动作"),
                )
              ],
            ),
            subtitle: Text(e.description),
            trailing: _selectedExercise != null && _selectedExercise.id == e.id
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
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
