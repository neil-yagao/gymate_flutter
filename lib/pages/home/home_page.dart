import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/exercise/training_plan_selection.dart';
import 'package:workout_helper/pages/general/avatar_crop.dart';
import 'package:workout_helper/pages/general/navigate_app_bar.dart';
import 'package:workout_helper/pages/home/user_event_list.dart';
import 'package:workout_helper/pages/session/session.dart';
import 'package:workout_helper/pages/session/session_report_webview.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/exercise_service.dart';
import 'package:workout_helper/service/notification_service.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'drawer_menu.dart';
import 'exercise_preview.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageNoPlanState();
  }

  static HomePageNoPlanState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedHomePage)
            as InheritedHomePage)
        .data;
  }
}

class HomePageNoPlanState extends State<HomePage> {
  ExerciseService _exerciseService;

  SessionService _sessionService;

  User _currentUser;

  Exercise todayPlannedExercise;

  Session _todayCompletedSession;

  NotificationService _notificationService;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentPage = 0;

  TextStyle activeTabStyle;

  TextStyle normalTabStyle;

  Timer t;

  int unreadMessageCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    activeTabStyle = Typography.dense2018.body1.merge(TextStyle(
        color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold));
    normalTabStyle = Typography.dense2018.body1;
    _exerciseService = ExerciseService(scaffoldKey);
    _sessionService = SessionService(scaffoldKey);
    _notificationService = NotificationService(scaffoldKey);
    t?.cancel();
    t = Timer.periodic(
        Duration(minutes: 1),
        (timer) => _notificationService
                .getUnreadMessageCount(_currentUser.id)
                .then((count) {
              if (!this.mounted) {
                t?.cancel();
                return;
              }
              if (unreadMessageCount != count) {
                setState(() {
                  unreadMessageCount = count;
                });
              }
            }));
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _sessionService.getTodayCompletedSession(_currentUser.id).then((s) {
      if (s != null) {
        setState(() {
          _todayCompletedSession = s;
          todayPlannedExercise = s.matchingExercise;
        });
      } else {
        _exerciseService
            .getUserPlannedExercise(_currentUser.id, date)
            .then((e) {
          if (e == null) {
            return;
          }
          setState(() {
            todayPlannedExercise = e;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      key: scaffoldKey,
      appBar: NavigateAppBar(
        currentPage: 0,
        unreadMessageCount: unreadMessageCount,
      ),
      endDrawer: Drawer(
        child: DrawerMenu(
          homePageKey: scaffoldKey,
          unreadMessageCount: unreadMessageCount,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            CustomIcon.directions_run,
            color: Theme.of(context).primaryColor,
          ),
          tooltip: "快速开始一次训练",
          backgroundColor: Colors.white,
          onPressed: () {
            NavigationUtil.pushUsingDefaultFadingTransition(
                context, UserSession("randomId"));
          }),
      body: SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [buildFirstHalf(), buildEventList()]),
      ),
      floatingActionButtonLocation: userHaventJoinedPlan()
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: ListTile(
          title: Text(
            userHaventJoinedPlan() ? "搜索计划" : todayPlannedExercise.name,
            style:
                Typography.dense2018.title.merge(TextStyle(color: Colors.grey)),
          ),
          onTap: () {
            userHaventJoinedPlan()
                ? NavigationUtil.pushUsingDefaultFadingTransition(
                    context, TrainingPlanSelection())
                : goToTodaySession(context);
          },
          trailing: userHaventJoinedPlan()
              ? IconButton(
                  icon: Icon(Icons.youtube_searched_for),
                  onPressed: () {
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, TrainingPlanSelection());
                  },
                )
              : IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ExercisePreview(
                            exercise: todayPlannedExercise,
                          );
                        });
                  }),
        ),
      ),
//        bottomNavigationBar: BottomNaviBar(
//          currentIndex: 0,
//        )
    );
  }

  Widget buildTodayPart() {
    if (!userHaventJoinedPlan()) {
      return ListTile(
        leading: Text(""),
        title: Text(todayPlannedExercise.name,
            style: Typography.dense2018.subtitle),
        subtitle: Text(todayPlannedExercise.description),
        trailing: _todayCompletedSession == null ||
                _todayCompletedSession.accomplishedTime == null
            ? IconButton(
                onPressed: () {
                  goToTodaySession(context);
                },
                icon: Icon(Icons.chevron_right),
              )
            : Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
        onTap: _todayCompletedSession == null ||
                _todayCompletedSession.accomplishedTime == null
            ? () {
                goToTodaySession(context);
              }
            : () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SessionReportWebView(
                          completedSession: _todayCompletedSession,
                          canGoBack: true,
                        )));
              },
      );
    } else {
      return Container();
    }
  }

  void goToTodaySession(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => UserSession("today")));
  }

  bool userHaventJoinedPlan() =>
      todayPlannedExercise == null || todayPlannedExercise.id == null;

//  Future appendCardioSetToCurrentSession(ExerciseSet es) {
//    NavigationUtil.showLoading(context,
//        content: "记录中,消耗约：" +
//            (es as CardioSet).exerciseCals.ceil().toString() +
//            "KCals");
//    return _sessionService
//        .completeCardioOnlySession(es, _currentUser.id)
//        .then((_) {
//      Navigator.of(context).maybePop().then((_) {
//        showDialog(
//            context: context,
//            builder: (context) {
//              return Dialog(
//                child: Padding(
//                  padding: EdgeInsets.all(16),
//                  child: Text("记录成功，消耗约：" +
//                      (es as CardioSet).exerciseCals.ceil().toString() +
//                      "KCals"),
//                ),
//              );
//            });
//      });
//    }).catchError((error) {
//      debugPrint("error during finish cardio only session" + error.toString());
//      scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text("网络出现问题"),
//        duration: Duration(seconds: 3),
//      ));
//      Navigator.of(context).maybePop();
//    });
//  }

  Widget buildFirstHalf() {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.grey[200],
          child: _currentUser.customizeMotto == null
              ? Image.asset(
                  "assets/motto.jpg",
                  fit: BoxFit.fitWidth,
                )
              : Image.network(
                  _currentUser.customizeMotto,
                  fit: BoxFit.fitWidth,
                ),
          height: MediaQuery.of(context).size.height * 0.31,
          width: MediaQuery.of(context).size.width * 0.999,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                NavigationUtil.pushUsingDefaultFadingTransition(context,
                    AvatarCrop(
                  onCompleted: (File file) {
                    setState(() {
                      Provider.of<CurrentUserStore>(context)
                          .updateCustomMotto(file);
                    });
                  },
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  Widget buildEventList() {
    return InheritedHomePage(
      data: this,
      child: UserEventListView(
        currentUserId: _currentUser.id,
      ),
    );
  }
}

class InheritedHomePage extends InheritedWidget {
  final HomePageNoPlanState data;

  InheritedHomePage({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
