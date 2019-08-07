import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/session.dart';
import 'package:workout_helper/service/session_service.dart';

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
  SessionRepositoryService _sessionService = SessionRepositoryService();
  Session _todaySession;

  @override
  void initState() {
    super.initState();
    _todaySession = _sessionService.getTodaySession();
  }

  final List<Map<String, String>> options = [
    {
      "title": "力量举",
      "headingLogo": "assets/powerlifting.jpg",
      "description": "卧推、硬拉、深蹲三项力量训练",
      "to": 'powerlifting'
    },
    {
      "title": "健美",
      "headingLogo": "assets/fitness.jpeg",
      "description": "健美形体训练",
      "to": 'bodybuilding'
    },
    {
      "title": "Crossfit",
      "headingLogo": "assets/crossfit.jpeg",
      "description": "提高综合身体素质",
      "to": 'crossfit'
    }
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(padding: const EdgeInsets.all(8.0), children: [
      HomeCalendar(),
      Divider(),
      buildSessionPart(_todaySession),
      Divider(),
      TrainingDivisionSelection(
          title: "快速开始训练",
          headingLogo: "assets/quick-session.jpg",
          description: "快速开始一次训练",
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/quickExercise');
          }),
      Divider()
    ]);
  }

  Card buildSessionPart(Session todaySession) {
    if (todaySession == null || todaySession.id == null) {
      //user do not involved in any plan
      return Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12, bottom: 8),
                    child: Text("添加计划", style: Typography.dense2018.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 14.0),
                  child: InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.person_add,
                        size: 21,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                          onPressed: () {}),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

class TrainingDivisionSelection extends StatelessWidget {
  TrainingDivisionSelection(
      {Key key, this.title, this.headingLogo, this.description, this.onTap})
      : super(key: key);

  final String title;
  final String headingLogo;
  final String description;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset(headingLogo)),
      title: Text(title),
      subtitle: Text(description),
      onTap: onTap,
    );
  }
}
