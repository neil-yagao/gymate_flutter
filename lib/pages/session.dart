import 'dart:async';
import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/camera_page.dart';
import 'package:workout_helper/pages/component/exercise_set_line.dart';
import 'package:workout_helper/pages/component/movement_bottom_sheet.dart';
import 'package:workout_helper/pages/save_template.dart';
import 'package:workout_helper/pages/session_report.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';
import 'package:workout_helper/service/session_service.dart';

import 'component/cardio_bottom_sheet.dart';
import 'component/hiit_bottom_sheet.dart';
import 'component/hiit_clock.dart';
import 'component/hiit_exercise_line.dart';
import 'component/session_action_menu.dart';
import 'component/session_completed.dart';
import 'component/session_materials_grid.dart';
import 'exercise_template_selection.dart';

class UserSession extends StatefulWidget {
  UserSession(this.exerciseId);

  final String exerciseId;

  @override
  State<StatefulWidget> createState() {
    return UserSessionState(this.exerciseId);
  }
}

class UserSessionState extends State<UserSession> {
  SessionService sessionRepositoryService = SessionService();

  UserSessionState(this.exerciseId);

  ExerciseService exerciseService = ExerciseService();

  final String exerciseId;

  Session _currentSession;

  Set<String> completedExercise = Set();

  int _currentPanel;

  bool _editing = false;

  List<ExerciseSet> _tempRemovingSets = List();

  List<Movement> _removingMovement = List();

  List<SessionMaterial> sessionMaterials = List();

  int _currentExerciseIndex = 0;

  bool _isClockShow = false;

  Timer t;

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
        title: Text(_currentSession == null ||
                _currentSession.matchingExercise.name == null ||
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
                  _saveAsTemplate();
                  break;
//                case SessionOption.SHARE_TEMPLATE:
                // TODO: Handle this case.
//                  Share.share('check out my website https://example.com');
//                  break;
                case SessionOption.CREATE_FROM_TEMPLATE:
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ExerciseTemplateSelection();
                  })).then((e) {
                    if (e != null) {
                      sessionRepositoryService
                          .createNewSessionFromExercise(
                              e,
                              Provider.of<CurrentUserStore>(context)
                                  .currentUser
                                  .id
                                  .toString())
                          .then((Session session) {
                        setState(() {
                          _currentSession = session;
                        });
                      });
                    }
                  });
                  break;
              }
            },
          )
        ]);
  }

  ///jump to the new page to resolve save this template
  void _saveAsTemplate() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SaveTemplate(
              exerciseToSave: _currentSession.matchingExercise,
            )));
  }

  void leaveSession(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
    sessionRepositoryService.removeSession(_currentSession);
  }

  @override
  void initState() {
    super.initState();
    if (_currentSession != null) {
      sessionRepositoryService
          .getSessionMaterialsBySessionId(_currentSession.id)
          .then((List<SessionMaterial> sessionMaterials) {
        setState(() {
          this.sessionMaterials = sessionMaterials;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Exercise exercise = Exercise();
    exercise.id = this.exerciseId;
    if (_currentSession != null) {
      return;
    }
    sessionRepositoryService
        .createNewSessionFromExercise(exercise,
            Provider.of<CurrentUserStore>(context).currentUser.id.toString())
        .then((Session session) {
      setState(() {
        _currentSession = session;
      });
    }).catchError((error) {
      print(error);
      Navigator.maybePop(context);
    });
  }

  int completedLiftingSetsCount(List<ExerciseSet> set) {
    int count = 0;
    set.forEach((ExerciseSet es) {
      if (completedExercise.contains(es.id)) {
        count++;
      }
    });
    return count;
  }

  Widget buildContent(BuildContext context) {
    if (_currentSession == null) {
      return Card();
    }
    LinkedHashMap<Movement, List<ExerciseSet>> maps =
        SessionService.groupExerciseSetViaMovement(
            _currentSession.matchingExercise.plannedSets);
    List<ExpansionPanel> movements = [];
    int currentIndex = 0;
    bool canAutoProcess = false;
    maps.forEach((Movement movement, List<ExerciseSet> sets) {
      ExpansionPanel panel;
      if (movement.exerciseType == ExerciseType.lifting) {
        panel = getLiftingPanel(currentIndex, sets, movement);
      } else if (movement.exerciseType == ExerciseType.hiit) {
        panel = getHiitPanel(currentIndex, movement, sets);
        canAutoProcess = true;
      } else if (movement.exerciseType == ExerciseType.cardio) {
        panel = getCardioPanel(movement, sets);
      }

      movements.add(panel);
      currentIndex++;
    });
    if (movements.isEmpty) {
      return Card();
    }

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                if (isExpanded) {
                  _currentPanel = -1;
                } else {
                  _currentPanel = index;
                }
              });
            },
            children: movements),
        canAutoProcess
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: RaisedButton(
                  onPressed: () {
                    startHiitSession();
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("开始"),
                ),
              )
            : Text("")
      ],
    ));
  }

  ExpansionPanel getLiftingPanel(
      int currentIndex, List<ExerciseSet> sets, Movement movement) {
    int index = 0;

    return ExpansionPanel(
        isExpanded: _currentPanel == currentIndex,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return expansionPanelHeader(movement, sets);
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
                SessionCompleted sc = SessionCompleted(
                  finishedSet: es,
                  updateCompletedInfo: (CompletedExerciseSet ces) {
                    sessionRepositoryService.saveCompletedSet(
                        _currentSession, ces);
                  },
                );
                showDialog(
                    context: context,
                    builder: (BuildContext c) {
                      return sc;
                    }).then((value) {
                  sc.emitCompletedInfo();
                });
              });
        }).toList()));
  }

  ListTile expansionPanelHeader(Movement movement, List<ExerciseSet> sets) {
    int movementCompletedSet = 0;
    Icon tailingIcon;
    //decide the icon of complete status
    if (movement.exerciseType == ExerciseType.lifting) {
      movementCompletedSet = completedLiftingSetsCount(sets);
      if (movementCompletedSet == 0) {
        tailingIcon = Icon(Icons.crop_square);
      } else if (movementCompletedSet == sets.length) {
        tailingIcon = allCompletedIcon();
      } else {
        tailingIcon = partialCompletedIcon();
      }
    } else if (movement.exerciseType == ExerciseType.hiit) {
      (sets.elementAt(0) as HIITSet).movements.forEach((SingleMovementSet sms) {
        if (completedExercise.contains(sms.id)) {
          movementCompletedSet++;
        }
        if (movementCompletedSet == 0) {
          tailingIcon = Icon(Icons.crop_square);
        } else if (movementCompletedSet ==
            (sets.elementAt(0) as HIITSet).movements.length) {
          tailingIcon = allCompletedIcon();
        } else {
          tailingIcon = partialCompletedIcon();
        }
      });
    } else {
      tailingIcon = allCompletedIcon();
    }

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
                        _tempRemovingSets
                            .removeWhere((ExerciseSet es) => sets.contains(es));
                      } else {
                        _removingMovement.add(movement);
                        _tempRemovingSets.addAll(sets);
                      }
                    });
                  }
                },
              )
            : null,
        title: Text(movement.name),
        trailing: tailingIcon);
  }

  Icon partialCompletedIcon() {
    return Icon(
      Icons.indeterminate_check_box,
      color: Colors.amberAccent,
    );
  }

  Icon allCompletedIcon() {
    return Icon(
      Icons.check_box,
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(child: buildContent(context)),
      floatingActionButton: buildActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildActionButton() {
    return _editing
        ? Text(
            'invisible',
            style: TextStyle(color: Colors.transparent),
          )
        : SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            child: Icon(Icons.add),
//            animatedIcon: AnimatedIcons.menu_close,
//            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            overlayColor: Colors.grey,
            overlayOpacity: 0.5,
            tooltip: '添加运动',
            children: [
              SpeedDialChild(
                  child: Icon(CustomIcon.leak_remove),
                  backgroundColor: Colors.blue[800],
                  label: '力量训练',
                  labelStyle: Typography.dense2018.subhead,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MovementBottomSheet(
                            onSubmitted: (List<ExerciseSet> m) {
                              appendToCurrentSession(m);
                            },
                          );
                        });
                  }),
              SpeedDialChild(
                child: Icon(CustomIcon.heartbeat),
                backgroundColor: Colors.blue[600],
                label: 'HIIT',
                labelStyle: Typography.dense2018.subhead,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return HIITBottomSheet(
                          onSubmitted: (List<ExerciseSet> sets) {
                            appendToCurrentSession(sets);
                            Navigator.of(context).maybePop();
                          },
                        );
                      });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.directions_run),
                backgroundColor: Colors.blue[400],
                label: '有氧运动',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CardioBottomSheet(logExercise: (ExerciseSet es) {
                          appendToCurrentSession([es]).then((_) {
                            completedExercise.add(es.id);
                            CompletedExerciseSet ces =
                                CompletedExerciseSet.empty();
                            ces.accomplishedSet = es;
                            sessionRepositoryService.saveCompletedSet(
                                _currentSession, ces);
                          });
                        });
                      })
                },
              ),
            ],
          );
  }

  Future<void> appendToCurrentSession(List<ExerciseSet> sets) async {
    return exerciseService
        .appendToExercise(_currentSession.matchingExercise, sets)
        .then((List<ExerciseSet> es) {
      setState(() {
        _currentPanel = -1;
      });
    });
  }

  Row buildBottomNavigationBar() {
    bool allCompleted =
        completedExercise.length > 0 && completedExercise.length != 0;
    return _editing
        ? editingNavigatorBar()
        : allCompleted
            ? Row(
                children: <Widget>[
                  Expanded(
                    child: buildMaterialPart(),
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _editing = false;
                            sessionRepositoryService
                                .completedSession(
                                    _currentSession,
                                    Provider.of<CurrentUserStore>(context)
                                        .currentUser
                                        .id
                                        .toString())
                                .then((_) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SessionReport(
                                          completedSession: _currentSession)));
                            });
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

  Row editingNavigatorBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
              onPressed: () {
                exerciseService
                    .removeFromExercise(
                        _currentSession.matchingExercise, _tempRemovingSets)
                    .then((_) {
                  setState(() {
                    _editing = false;
                    _tempRemovingSets = List();
                    _removingMovement = List();
                  });
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
    );
  }

  Widget buildMaterialPart() {
    FlatButton cameraButton = FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CameraExampleHome(
                    "session/" + _currentSession.id, (String uploadedFile) {
                  SessionMaterial sessionMaterial = SessionMaterial();
                  sessionMaterial.isVideo = false;
                  sessionMaterial.filePath = uploadedFile;
                  sessionMaterial.sessionId = _currentSession.id;
                  sessionRepositoryService.addSessionMaterial(sessionMaterial);
                })));
      },
      color: Colors.transparent,
      child: Icon(
        Icons.camera_alt,
        color: Theme.of(context).primaryColor,
      ),
    );
    if (sessionMaterials.length != 0) {
      return cameraButton;
    } else {
      return Row(
        children: <Widget>[
          Expanded(flex: 2, child: cameraButton),
          Expanded(
            child: Badge(
              badgeContent: Text('0'),
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SessionMaterialsGrid(
                              sessionId: _currentSession.id,
                            )));
                  },
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  )),
            ),
          )
        ],
      );
    }
  }

  ExpansionPanel getHiitPanel(
      int currentIndex, Movement movement, List<ExerciseSet> sets) {
    return ExpansionPanel(
        isExpanded: _currentPanel == currentIndex,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return expansionPanelHeader(movement, sets);
        },
        body: Column(children: buildHiitListTiles(sets)));
  }

  List<Widget> buildHiitListTiles(List<ExerciseSet> sets) {
    List<Widget> result = List();
    int index = 0;
    sets.forEach((ExerciseSet es) {
      HIITSet set = es as HIITSet;
      set.movements.forEach((SingleMovementSet sms) {
        result.add(HIITExerciseLine(sms, ++index, set.exerciseTime,
            this.completedExercise.contains(sms.id)));
      });
    });
    return result;
  }

  void startHiitSession() {
    HIITSet hiitSet =
        _currentSession.matchingExercise.plannedSets[0] as HIITSet;
    setState(() {
      _currentPanel = 0;
      _currentExerciseIndex = 0;
    });
    showHiitClock(hiitSet.movements.elementAt(0), hiitSet);
    t = Timer.periodic(
        Duration(seconds: hiitSet.restTime + hiitSet.exerciseTime + 3), (at) {
      if (_currentPanel >=
          _currentSession.matchingExercise.plannedSets.length) {
        t.cancel();
        return;
      }
      HIITSet newHiitSet =
          _currentSession.matchingExercise.plannedSets[_currentPanel];
      SingleMovementSet currentMovement =
          newHiitSet.movements.elementAt(_currentExerciseIndex);
      if (_isClockShow) {
        return;
      }
      setState(() {
        _isClockShow = true;
      });
      showHiitClock(currentMovement, hiitSet);
    });
  }

  void showHiitClock(SingleMovementSet currentMovement, HIITSet hiitSet) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return HiitClock(
            sms: currentMovement,
            exerciseTime: hiitSet.exerciseTime,
            restTime: hiitSet.restTime,
            exerciseRestLoopEndCallback: () {
              if (_currentExerciseIndex < hiitSet.movements.length - 1) {
                setState(() {
                  _currentExerciseIndex++;
                  _isClockShow = false;
                });
              } else {
                setState(() {
                  _currentPanel++;
                  _currentExerciseIndex = 0;
                  _isClockShow = false;
                });
              }
              this.completedExercise.add(currentMovement.id);
              CompletedExerciseSet ces = CompletedExerciseSet.empty();
              ces.accomplishedSet = hiitSet;
              ces.completedTime = DateTime.now();
              ces.repeats = hiitSet.exerciseTime;
              ces.restAfterAccomplished = hiitSet.restTime;
              sessionRepositoryService.saveCompletedSet(_currentSession, ces);
              Navigator.of(context).maybePop();
            },
          );
        });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  ExpansionPanel getCardioPanel(Movement movement, List<ExerciseSet> sets) {
    return ExpansionPanel(
        isExpanded: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return expansionPanelHeader(movement, sets);
        },
        body: ListView(
            shrinkWrap: true,
            children: sets.map((ExerciseSet es) {
              CardioSet cs = es as CardioSet;
              return ListTile(
                  dense: true,
                  leading: IconButton(
                    color: Colors.transparent,
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: null,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      Expanded(
                        child: Text(cs.movementName),
                      ),
                      Expanded(
                        child: Text(cs.exerciseDistance.toString() + "KM"),
                      ),
                      Expanded(
                        child: Text(cs.exerciseTime.toString() + "分钟"),
                      ),
                      Expanded(
                        child: Text(
                            "约" + cs.exerciseCals.floor().toString() + "kCal"),
                      ),
                    ],
                  ));
            }).toList()));
  }
}
