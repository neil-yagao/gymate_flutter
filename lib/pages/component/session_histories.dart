import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/session_report.dart';

class SessionHistory extends StatelessWidget {
  final List<Session> sessions;

  const SessionHistory({Key key, @required this.sessions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("训练记录"),
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
                  .format(session.accomplishedTime)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SessionReport(completedSession: session,canGoBack: true,)));
              },
            );
          })
        ],
      )),
    );
    ;
  }
}
