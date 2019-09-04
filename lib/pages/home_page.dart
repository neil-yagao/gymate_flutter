import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/session.dart';
import 'package:workout_helper/service/session_service.dart';

import 'component/bottom_navigation_bar.dart';
import 'component/home_calendar.dart';

class HomePage extends StatefulWidget {
  final bool hasLaunchPlan = false;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageNoPlanState();
  }
}

class HomePageNoPlanState extends State<HomePage> {
  SessionService _sessionService = SessionService();
  Session _todaySession;

  @override
  void initState() {
    super.initState();
    _sessionService.getTodaySession().then((Session session) {
      if (session != null) {
        setState(() {
          _todaySession = session;
        });
      }
    });
  }

//
//  final List<Map<String, String>> options = [
//    {
//      "title": "力量举",
//      "headingLogo": "assets/powerlifting.jpg",
//      "description": "卧推、硬拉、深蹲三项力量训练",
//      "to": 'powerlifting'
//    },
//    {
//      "title": "健美",
//      "headingLogo": "assets/fitness.jpeg",
//      "description": "健美形体训练",
//      "to": 'bodybuilding'
//    },
//    {
//      "title": "Crossfit",
//      "headingLogo": "assets/crossfit.jpeg",
//      "description": "提高综合身体素质",
//      "to": 'crossfit'
//    }
//  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: [
              Stack(
                children: <Widget>[
                  HomeCalendar(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 75.0, bottom: 50),
                      child: Image.asset(
                        "assets/motto.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                child: Padding(
                  padding: const EdgeInsets.only(top:14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildSessionPart(_todaySession),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(flex: 1, child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Text(
                              "或者",
                              style: Typography.dense2018.subhead.merge(TextStyle(
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
            onTap: () {}),
      );
    }

    return Card(
        child: Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("训练进度", style: Typography.dense2018.title),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: LinearProgressIndicator(
          semanticsLabel: '现有计划进展',
          value: 0.2,
        ),
      ),
      ListTile(
        title: Text(todaySession.matchingExercise.name,
            style: Typography.dense2018.subtitle),
        subtitle: Text(todaySession.matchingExercise.description),
        trailing: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          onPressed: () {
            goToTodaySession(context);
          },
          child: Icon(Icons.chevron_right),
        ),
        onTap: () {
          goToTodaySession(context);
        },
      )
    ]));
  }

  void goToTodaySession(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => UserSession("today")));
  }
}
