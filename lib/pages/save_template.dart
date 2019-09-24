import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/session_service.dart';

class SaveTemplate extends StatefulWidget {
  final Exercise exerciseToSave;

  const SaveTemplate({Key key, @required this.exerciseToSave})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaveTemplateState(exerciseToSave);
  }
}

class SaveTemplateState extends State<SaveTemplate> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  List<MuscleGroup> involvedGroup = List();

  SessionService _sessionRepositoryService;

  bool _selectingMuscleGroup = false;

  bool _exerciseTemplate = true;

  final Exercise exerciseToSave;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  SaveTemplateState(this.exerciseToSave);

  @override
  void initState(){
    super.initState();
    _sessionRepositoryService = SessionService(_key);
  }

  @override
  Widget build(BuildContext context) {
    Map<Movement, List<ExerciseSet>> movementMap =
    SessionService.groupExerciseSetViaMovement(
        exerciseToSave.plannedSets);
    return Scaffold(
      appBar: AppBar(
        title: Text("保存模板"),
      ),
      body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "模板名称",
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "模板说明",
                  ),
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool expand) {
                  setState(() {
                    if (index == 1) {
                      _selectingMuscleGroup = !expand;
                      _exerciseTemplate = false;
                    } else {
                      _exerciseTemplate = !expand;
                      _selectingMuscleGroup = false;
                    }
                  });
                },
                children: [
                  ExpansionPanel(
                      isExpanded: _exerciseTemplate,
                      body: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.16,
                        child: ListView(
                          children: movementMap.entries
                              .map((MapEntry<Movement, List<ExerciseSet>> me) {
                            String subTitle = getExerciseDescription(me.value);
                            return ListTile(
                              title: Text(
                                me.key.name,
                                style: Typography.dense2018.subtitle,
                              ),
                              subtitle:
                              subTitle == null ? null : Text(subTitle),
                              trailing: Text(me.value.length.toString() + "组"),
                            );
                          }).toList(),
                        ),
                      ),
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          dense: true,
                          title: Text(
                            "模板概况",
                            style: Typography.dense2018.subhead,
                          ),
                          onTap: () {
                            setState(() {
                              _exerciseTemplate = !_exerciseTemplate;
                              _selectingMuscleGroup = false;
                            });
                          },
                        );
                      }),
                  ExpansionPanel(
                    isExpanded: _selectingMuscleGroup,
                    body: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      child: ListView(
                          children: MuscleGroup.values.map((MuscleGroup mg) {
                            return CheckboxListTile(
                              dense: true,
                              value: involvedGroup.contains(mg),
                              title: Text(mg.toString()),
                              onChanged: (bool add) {
                                if (add) {
                                  setState(() {
                                    involvedGroup.add(mg);
                                  });
                                } else {
                                  setState(() {
                                    involvedGroup.remove(mg);
                                  });
                                }
                              },
                            );
                          }).toList()),
                    ),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        dense: true,
                        title: Text(
                          "涉及肌群",
                          style: Typography.dense2018.subhead,
                        ),
                        onTap: () {
                          setState(() {
                            _selectingMuscleGroup = !_selectingMuscleGroup;
                            _exerciseTemplate = false;
                          });
                        },
                      );
                    },
                  )
                ],
              )
            ],
          ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).maybePop();
              }),
          FlatButton(
              child: Text('确认'),
              textColor: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                exerciseToSave.muscleTarget = involvedGroup;
                exerciseToSave.name = name.text;
                exerciseToSave.description = description.text;
                _sessionRepositoryService.saveSessionAsTemplate(
                    exerciseToSave, Provider
                    .of<CurrentUserStore>(context)
                    .currentUser
                    .id.toString()).then((_){
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }

  String getExerciseDescription(List<ExerciseSet> es) {
    String result = null;
    int reduceCount = 0;
    int superSetCount = 0;
    es.forEach((ExerciseSet es) {
      if (es is ReduceSet) {
        reduceCount++;
      }
      if (es is GiantSet) {
        superSetCount++;
      }
    });
    if (reduceCount > 0) {
      result = "包含递减组" + reduceCount.toString() + "组";
    } else if (superSetCount > 0) {
      result = "超级组";
    }
    return result;
  }
}
