import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';

import 'package:workout_helper/pages/session/session_report_webview.dart';

class SessionHistory extends StatelessWidget {
  final List<Session> sessions;

  final String sessionPractiseName;

  const SessionHistory(
      {Key key, @required this.sessions, this.sessionPractiseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar.build(context,
        title: sessionPractiseName == null
            ? "训练记录"
            : sessionPractiseName + "训练记录",
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ...sessions.map((Session session) {
            return ListTile(
              title: Text(
                  "一共" + session.accomplishedSets.length.toString() + "组动作"),
              trailing: Icon(Icons.keyboard_arrow_right),
              subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                  .format(session.accomplishedTime.add(Duration(hours: 8)))),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SessionReportWebView(
                          completedSession: session,
                          canGoBack: true,
                        )));
              },
            );
          })
        ],
      )),
    );
    ;
  }
}
