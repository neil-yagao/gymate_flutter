import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/exercise_set_line.dart';
import 'package:workout_helper/pages/component/movement_bottomsheet.dart';
import 'package:workout_helper/service/session_service.dart';

import 'component/session_action_menu.dart';
import 'component/session_completed.dart';

class UserSession extends StatefulWidget {
  UserSession(this.exerciseId);

  final String exerciseId;

  @override
  State<StatefulWidget> createState() {
    return UserSessionState(this.exerciseId);
  }
}

class UserSessionState extends State<UserSession> {
  SessionRepositoryService sessionRepositoryService =
      SessionRepositoryService();

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              leaveSession(context);
            }),
        title: Text(_currentSession.matchingExercise.name == null ||
                _currentSession.matchingExercise.name.isEmpty
            ? "快速开始"
            : _currentSession.matchingExercise.name),
        actions: [
          SessionActionMenu(
            onSelected: (SessionOption option) {
              print('option' + option.toString());
              switch (option) {
                case SessionOption.EDITING:
                  setState(() {
                    _currentPanel = -1;
                    _editing = true;
                  });
                  break;
                case SessionOption.SAVE_TEMPLATE:
                  // TODO: Handle this case.
                  break;
                case SessionOption.SHARE_TEMPLATE:
                  // TODO: Handle this case.
                  Share.share('check out my website https://example.com');
                  break;
              }
            },
          )
        ]);
  }

  void leaveSession(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  UserSessionState(this.exerciseId);

  final String exerciseId;

  Session _currentSession;

  Set<String> completedExercise = Set();

  int _currentPanel;

  bool _editing = false;

  List<ExerciseSet> _tempRemovingSets = List();

  List<Movement> _removingMovement = List();

  @override
  void initState() {
    super.initState();
    Exercise exercise = Exercise();
    exercise.id = this.exerciseId;
    _currentSession =
        sessionRepositoryService.createNewSessionFromExercise(exercise);
    _currentSession.matchingExercise.plannedSets = List();
  }

  int completedSets(List<ExerciseSet> set) {
    int count = 0;
    set.forEach((ExerciseSet es) {
      if (completedExercise.contains(es.id)) {
        count++;
      }
    });
    return count;
  }

  Widget buildContent(BuildContext context) {
    LinkedHashMap<Movement, List<ExerciseSet>> maps = LinkedHashMap();
    _currentSession.matchingExercise.plannedSets.forEach((ExerciseSet es) {
      if (es is SingleMovementSet) {
        if (!maps.containsKey(es.movement)) {
          maps.putIfAbsent(es.movement, () {
            return [];
          });
        }
        maps[es.movement].add(es);
      } else {
        //giant set
        GiantSet gs = es;
        if (!maps.containsKey(gs.extractMovementBasicInfo())) {
          maps.putIfAbsent(gs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[gs.extractMovementBasicInfo()].add(es);
      }
    });
    List<ExpansionPanel> movements = [];
    int currentIndex = 0;
    maps.forEach((Movement movement, List<ExerciseSet> sets) {
      int index = 0;
      int movementCompletedSet = completedSets(sets);
      Icon tailingIcon;
      if (movementCompletedSet == 0) {
        tailingIcon = Icon(Icons.crop_square);
      } else if (movementCompletedSet == sets.length) {
        tailingIcon = Icon(
          Icons.check_box,
          color: Colors.green,
        );
      } else {
        tailingIcon = Icon(
          Icons.indeterminate_check_box,
          color: Colors.amberAccent,
        );
      }
      ExpansionPanel panel = ExpansionPanel(
          isExpanded: _currentPanel == currentIndex,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                leading: _editing
                    ? IconButton(
                        padding: EdgeInsets.all(0),
                        icon: _removingMovement.contains(movement)
                            ? Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              )
                            : Icon(Icons.crop_square, color: Colors.grey),
                        onPressed: () {
                          if (_editing) {
                            //find all movement index
                            setState(() {
                              if (_removingMovement.contains(movement)) {
                                _removingMovement.remove(movement);
                              } else {
                                _removingMovement.add(movement);
                              }
                              List<ExerciseSet> sets = maps[movement];
                              _tempRemovingSets.addAll(sets);
                            });
                          }
                        },
                      )
                    : null,
                title: Text(movement.name),
                trailing: tailingIcon);
          },
          body: Column(
              children: sets.map((ExerciseSet es) {
            es.sequence = index;
            index++;
            return ExerciseSetLine(
                workingSet: es,
                onDeletedClicked: (String id) {
                  int findIndex = _currentSession.matchingExercise.plannedSets
                      .indexWhere((ExerciseSet e) => e.id == id);
                  if (findIndex >= 0) {
                    setState(() {
                      _currentSession.matchingExercise.plannedSets
                          .removeAt(findIndex);
                      _currentPanel = -1;
                    });
                  }
                },
                onCompletedClicked: (ExerciseSet es) {
                  setState(() {
                    this.completedExercise.add(es.id);
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return SessionCompleted(
                          finishedSet: es,
                        );
                      });
                });
          }).toList()));
      movements.add(panel);
      currentIndex++;
    });
    if (movements.isEmpty) {
      return Card();
    }

    return Container(
      child: SingleChildScrollView(
          child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (isExpanded) {
                    _currentPanel = -1;
                  } else {
                    _currentPanel = index;
                  }
                });
              },
              children: movements)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(child: buildContent(context)),
      floatingActionButton: _editing
          ? Text(
              'invisible',
              style: TextStyle(color: Colors.transparent),
            )
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MovementBottomSheet(
                        onSubmitted: (List<ExerciseSet> m) {
                          print(m);
                          setState(() {
                            _currentPanel = -1;
                            _currentSession.matchingExercise.plannedSets
                                .addAll(m);
                          });
                        },
                      );
                    });
              },
              tooltip: "添加动作",
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Row buildBottomNavigationBar(BuildContext context) {
    bool allCompleted = completedExercise.length ==
            _currentSession.matchingExercise.plannedSets.length &&
        completedExercise.length != 0;
    return _editing
        ? Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _currentSession.matchingExercise.plannedSets
                            .removeWhere((ExerciseSet es) {
                          return _tempRemovingSets.indexOf(es) >= 0;
                        });
                        _editing = false;
                        _tempRemovingSets = List();
                        _removingMovement = List();
                      });
                    },
                    color: Colors.transparent,
                    textColor: Theme.of(context).primaryColor,
                    child: Text('确定')),
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _editing = false;
                      });
                    },
                    color: Colors.transparent,
                    textColor: Colors.grey[500],
                    child: Text('取消')),
              ),
            ],
          )
        : allCompleted
            ? Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _currentSession.matchingExercise.plannedSets
                              .removeWhere((ExerciseSet es) {
                            return _tempRemovingSets.indexOf(es) >= 0;
                          });
                          _editing = false;
                          _tempRemovingSets = List();
                          _removingMovement = List();
                        });
                      },
                      color: Colors.transparent,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _editing = false;
                          });
                        },
                        color: Colors.transparent,
                        textColor: Colors.green,
                        child: Text('完成训练')),
                  ),
                ],
              )
            : null;
  }
}
