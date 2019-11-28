import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/session/session_report_webview.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'event_self_mixin.dart';

class SessionUserEvent extends StatelessWidget with SelfEvent{
  final UserEvent userEvent;

  const SessionUserEvent({Key key, @required this.userEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Session session =
        userEvent.relatedRecord == null ? Session() : userEvent.relatedRecord;
    if (session.id == null) {
      session.id = userEvent.id.toString();
    }
    String sessionName;
    if (session.matchingExercise == null) {
      sessionName = "训练";
    } else if (session.matchingExercise.name == null &&
        session.matchingExercise.exerciseType == "CardioSession") {
      sessionName = "快速有氧";
    } else if (session.matchingExercise.name == null) {
      sessionName = "自定义训练";
    } else {
      sessionName = session.matchingExercise.name;
    }
    return ListTile(
      leading: Text(""),
      title: Row(
        children: <Widget>[
          Text(isSelf(context,userEvent) ? "我" : userEvent.user.name),
          Text("完成了一次"),
          InkWell(
            child: Text(
              sessionName,
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
            onTap: () {
              NavigationUtil.pushUsingDefaultFadingTransition(
                  context,
                  SessionReportWebView(
                    completedSession: session,
                  ));
            },
          )
        ],
      ),
      subtitle: Text(
        DateFormat("yyyy-MM-dd hh:mm")
            .format(userEvent.happenedAt.add(Duration(hours: 8))),
      ),
      trailing: Text(
        "+" + userEvent.extraScore.round().toString(),
        style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontStyle: FontStyle.italic)
            .merge(Typography.dense2018.subhead),
      ),
    );
  }
}
