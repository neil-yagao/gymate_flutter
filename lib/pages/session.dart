import 'dart:async';
import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:workout_helper/util/navigation_util.dart';

import 'component/cardio_bottom_sheet.dart';
import 'component/chewie_network_item.dart';
import 'component/hiit_bottom_sheet.dart';
import 'component/hiit_clock.dart';
import 'component/hiit_exercise_line.dart';
import 'component/session_action_menu.dart';
import 'component/session_completed.dart';
import 'component/session_materials_grid.dart';
import 'exercise_template_selection.dart';
import 'home_page.dart';

const String CURRENT_SESSION_KEY = "current_session";

class UserSession extends StatefulWidget {
  UserSession(this.exerciseId);

  final String exerciseId;

  @override
  State<StatefulWidget> createState() {
    return UserSessionState(this.exerciseId);
  }
}

class UserSessionState extends State<UserSession> {
  SessionService sessionRepositoryService;

  UserSessionState(this.exerciseId);

  ExerciseService exerciseService;

  final String exerciseId;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Session _currentSession;

  Set<String> completedExercise = Set();

  int _currentPanel;

  bool _editing = false;

  List<ExerciseSet> _tempRemovingSets = List();

  List<Movement> _removingMovement = List();

  List<SessionMaterial> sessionMaterials = List();

  int _currentExerciseIndex = 0;

  bool _isClockShow = false;

  List<ChewieController> controllers = List();

  SharedPreferences _preferences;

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
    showDialog<String>(
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Text(
                      "退出将删除本次所有的训练记录，是否确定?",
                      style: Typography.dense2018.subhead,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.grey,
                        child: Text("返回"),
                        onPressed: () {
                          Navigator.of(context).maybePop("cancel");
                        },
                      ),
                      FlatButton(
                        textColor: Colors.redAccent,
                        child: Text("确定退出"),
                        onPressed: () {
                          _preferences.remove(CURRENT_SESSION_KEY);
                          sessionRepositoryService
                              .removeSession(_currentSession);
                          NavigationUtil.replaceUsingDefaultFadingTransition(
                              context, HomePage());
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    sessionRepositoryService = SessionService(_scaffoldKey);
    if (_currentSession != null) {
      sessionRepositoryService
          .getSessionMaterialsBySessionId(_currentSession.id)
          .then((List<SessionMaterial> sessionMaterials) {
        setState(() {
          this.sessionMaterials = sessionMaterials;
        });
      });
    }
    exerciseService = ExerciseService(_scaffoldKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Exercise exercise = Exercise.empty();
    exercise.id = this.exerciseId;
    if (_currentSession != null) {
      return;
    }
    SharedPreferences.getInstance().then((prefs) {
      _preferences = prefs;
      int currentSessionId = prefs.getInt(CURRENT_SESSION_KEY);
      if (currentSessionId == null) {
        sessionRepositoryService
            .createNewSessionFromExercise(
                exercise,
                Provider.of<CurrentUserStore>(context)
                    .currentUser
                    .id
                    .toString())
            .then((Session session) {
          setState(() {
            _currentSession = session;
          });
        }).catchError((error) {
          print("error in session:" + error.toString());
          Navigator.maybePop(context);
        });
      } else {
        sessionRepositoryService
            .recoverSession(currentSessionId)
            .then((session) {
          if (session.accomplishedSets.isNotEmpty) {
            showDialog<String>(
                context: context,
                builder: (context) {
                  return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "检测到上次未结束的训练，是否继续上次的训练？",
                              style: Typography.dense2018.subtitle,
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).maybePop("Cancel");
                                },
                                textColor: Theme.of(context).primaryColor,
                                child: Text("忽略上次训练"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).maybePop("OK");
                                },
                                child: Text("恢复"),
                                textColor: Colors.green,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).then((action) {
              if (action == "OK") {
                setState(() {
                  session.accomplishedSets.forEach((ces) {
                    completedExercise.add(ces.accomplishedSet.id);
                  });
                  _currentSession = session;
                });
              } else {
                prefs.remove(CURRENT_SESSION_KEY);
              }
            });
          }
        });
      }
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
        panel = getCardioPanel(currentIndex, movement, sets);
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
        body: Column(children: [
          ...sets.map((ExerciseSet es) {
            es.sequence = index;
            index++;
            return ExerciseSetLine(
                workingSet: es,
                hasCompleted: completedExercise.contains(es.id),
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
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return sc;
                      }).then((value) {
                    CompletedExerciseSet ces = sc.emitCompletedInfo();
                    _preferences.setInt(
                        CURRENT_SESSION_KEY, int.parse(_currentSession.id));
                    sessionRepositoryService.saveCompletedSet(
                        _currentSession, ces);
                    sets.forEach((s) {
                      if (s is SingleMovementSet) {
                        s.expectingWeight = ces.weight;
                        s.expectingRepeatsPerSet = ces.repeats;
                        s.unit = "KG";
                      } else if (s is GiantSet) {
                        for (int i = 0; i < s.movements.length; i++) {
                          SingleMovementSet nonFinishedSet =
                              s.movements.elementAt(i);
                          SingleMovementSet finishedSet =
                              (ces.accomplishedSet as GiantSet)
                                  .movements
                                  .elementAt(i);
                          nonFinishedSet.expectingWeight =
                              finishedSet.expectingWeight;
                          nonFinishedSet.expectingRepeatsPerSet =
                              finishedSet.expectingRepeatsPerSet;
                          nonFinishedSet.unit = "KG";
                        }
                      }
                    });

                    setState(() {});
                  });
                });
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  "再来一组",
                ),
                onPressed: () {
                  appendToCurrentSession([sets.elementAt(0)], remainOpen: true);
                },
              )
            ],
          )
        ]));
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
        title: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.play_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(movement.name)
                ],
              ),
              onTap: () {
                ExerciseSet set = sets.elementAt(0);
                Widget dialogWidget;
                if (set is GiantSet) {
                  dialogWidget = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ...set.movements.map((SingleMovementSet s) {
                        return showMovementVideo(s.movement);
                      })
                    ],
                  );
                } else if (set is HIITSet) {
                  dialogWidget = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ...set.movements.map((SingleMovementSet s) {
                        return showMovementVideo(s.movement);
                      })
                    ],
                  );
                } else if (!(set is CardioSet)) {
                  dialogWidget = showMovementVideo(movement);
                }
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return dialogWidget;
                    }).then((_) {});
              },
            )),
        trailing: tailingIcon);
  }

  Widget showMovementVideo(Movement movement) {
    return ChewieNetworkItem(url: movement.videoReference);
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
      key: _scaffoldKey,
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
            backgroundColor: Colors.white,
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
//            animatedIcon: AnimatedIcons.menu_close,
//            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            overlayColor: Colors.grey,
            overlayOpacity: 0.5,
            tooltip: '添加运动',
            children: [
              SpeedDialChild(
                  child: Icon(CustomIcon.leak_remove, color: Colors.red[400]),
                  backgroundColor: Colors.white,
                  label: '力量训练',
                  labelStyle: Typography.dense2018.subhead,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MovementBottomSheet(
                            scaffoldKey: _scaffoldKey,
                            onSubmitted: (List<ExerciseSet> m) {
                              appendToCurrentSession(m);
                            },
                          );
                        });
                  }),
              SpeedDialChild(
                child: Icon(
                  CustomIcon.heartbeat,
                  color: Colors.red[400],
                ),
                backgroundColor: Colors.white,
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
                          scaffoldKey: _scaffoldKey,
                        );
                      });
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.directions_run,
                  color: Colors.red[400],
                ),
                backgroundColor: Colors.white,
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

  Future<void> appendToCurrentSession(List<ExerciseSet> sets,
      {bool remainOpen = false}) async {
    return exerciseService
        .appendToExercise(_currentSession.matchingExercise, sets)
        .then((List<ExerciseSet> es) {
      setState(() {
        if (remainOpen) {
          return;
        }
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
                        onPressed: () async {
                          setState(() {
                            _editing = false;
                            NavigationUtil.showLoading(context);
                            sessionRepositoryService
                                .completedSession(_currentSession)
                                .then((_) {
                              Navigator.of(context).maybePop().then((_) {
                                _preferences.remove(CURRENT_SESSION_KEY);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => SessionReport(
                                              completedSession: _currentSession,
                                              canGoBack: false,
                                            )));
                              });
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
            builder: (context) => CameraCapture("session/" + _currentSession.id,
                    (String uploadedFile) {
                  SessionMaterial sessionMaterial = SessionMaterial.empty();
                  sessionMaterial.isVideo = false;
                  sessionMaterial.storeLocation = uploadedFile;
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
      return FutureBuilder<List<SessionMaterial>>(
        future: sessionRepositoryService
            .getSessionMaterialsBySessionId(_currentSession.id),
        builder: (context, sessionMaterials) {
          return Row(
            children: <Widget>[
              Expanded(flex: 2, child: cameraButton),
              Expanded(
                child: Badge(
                  badgeContent: Text(sessionMaterials.data == null
                      ? '0'
                      : sessionMaterials.data.length.toString()),
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
        },
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

  ExpansionPanel getCardioPanel(
      int index, Movement movement, List<ExerciseSet> sets) {
    return ExpansionPanel(
        isExpanded: _currentPanel == index,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return expansionPanelHeader(movement, sets);
        },
        body: ListView(
            shrinkWrap: true,
            children: sets.map((ExerciseSet es) {
              print(es);
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
