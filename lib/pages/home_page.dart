import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/session.dart';
import 'package:workout_helper/pages/training_plan_selection.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import 'component/bottom_navigation_bar.dart';
import 'component/home_calendar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageNoPlanState();
  }
}

class HomePageNoPlanState extends State<HomePage> {
  SessionService _sessionService;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Session _todaySession;

  bool _showCalendar = false;

  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sessionService = SessionService(_key);
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _sessionService.getTodaySession(_currentUser.id).then((Session session) {
      if (session != null && this.mounted) {
        setState(() {
          _todaySession = session;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: SafeArea(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: [
              buildFirstHalf(),
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildSessionPart(_todaySession),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(flex: 1, child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              "或者",
                              style: Typography.dense2018.subhead.merge(
                                  TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic)),
                            ),
                          ),
                          Expanded(flex: 2, child: Divider()),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(Icons.flash_on),
                              ),
                              title: Text("快速开始一次训练",
                                  style: Typography.dense2018.title.merge(
                                      TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic))),
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                        pageBuilder: (context, a1, a2) =>
                                            UserSession("randomId"),
                                        transitionsBuilder:
                                            (context, animate, a2, child) =>
                                                FadeTransition(
                                                  opacity: animate,
                                                  child: child,
                                                ),
                                        transitionDuration:
                                            Duration(milliseconds: 500)));
                              }))
                    ],
                  ),
                ),
              ),
            ])),
        bottomNavigationBar: BottomNaviBar(
          currentIndex: 0,
        ));
  }

  Widget buildSessionPart(Session todaySession) {
    if (todaySession == null || todaySession.id == null) {
      //user do not involved in any plan
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.search),
            ),
            title: Text(
              "查找合适的计划",
              style: Typography.dense2018.title.merge(
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            ),
            onTap: () {
              NavigationUtil.pushUsingDefaultFadingTransition(
                  context, TrainingPlanSelection());
            }),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
      child: Card(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  "今日训练",
                  style: Typography.dense2018.title.merge(TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: InkWell(
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, TrainingPlanSelection());
                  },
                ),
              )
            ],
          ),
        ),
        ListTile(
          title: Text(todaySession.matchingExercise.name,
              style: Typography.dense2018.subtitle),
          subtitle: Text(todaySession.matchingExercise.description),
          trailing: _todaySession.accomplishedTime == null
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
          onTap: _todaySession.accomplishedTime == null
              ? () {
                  goToTodaySession(context);
                }
              : null,
        )
      ])),
    );
  }

  void goToTodaySession(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => UserSession("today")));
  }

  Widget buildFirstHalf() {
    if (_showCalendar) {
      return HomeCalendar();
    }
    return Stack(
      children: <Widget>[
        HomeCalendar(),
        Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showCalendar = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "显示计划",
                          style: Typography.dense2018.caption.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    )
                  ],
                ),
                Image.asset(
                  "assets/motto.jpg",
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          color: Color.fromRGBO(255, 255, 255, 0.8),
          height: MediaQuery.of(context).size.height * 0.5,
        ),
      ],
    );
  }
}
