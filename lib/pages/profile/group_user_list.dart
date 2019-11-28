import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_entites.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/pages/session/session_histories.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'group_report.dart';

class GroupUserList extends StatefulWidget {
  final UserGroup group;

  const GroupUserList({Key key, this.group}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GroupUserListState(group);
  }
}

enum GroupOption { YESTERDAY_SUMMARY }

class GroupUserListState extends State<GroupUserList> {
  final UserGroup group;

  GroupUserListState(this.group);

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CurrentUserStore _currentUserStore;

  List<User> groupUsers = List();

  Map<int, String> lastSessionTime = Map();

  SessionService _sessionSerivce;

  @override
  void initState() {
    super.initState();
    _currentUserStore = CurrentUserStore(_key);
    _sessionSerivce = SessionService(_key);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUserStore.getGroupUsers(group.id).then((users) {
      setState(() {
        groupUsers = users;
      });
      return users;
    }).then((users) {
      _sessionSerivce.getUserLatestExerciseDate(users).then((List userTime) {
        userTime.forEach((d){
          Map<String,dynamic> entry = d as Map<String,dynamic>;
          lastSessionTime[entry['user_id']] = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(entry["latest_exercise_time"]));
        });
        setState(() {});
      });
    });
  }

  showGroupReport() {
    NavigationUtil.pushUsingDefaultFadingTransition(context, GroupReport(
      group: group,
      users: groupUsers,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: DefaultAppBar.build(context,
        title: group.name,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.insert_chart),
            onTap: () {
              showGroupReport();
            },
          )
//          PopupMenuButton<GroupOption>(
//              offset: Offset(0, 20),
//              icon: Icon(Icons.menu),
//              onSelected: (GroupOption option) {
//                this.onSelected(option);
//              },
//              itemBuilder: (BuildContext context) {}
//          )
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          ...groupUsers.map((user) {
            return ListTile(
              title: Text(user.name),
              subtitle: Text(
                  (lastSessionTime.containsKey(user.id)
                      ? "上次锻炼时间:" + lastSessionTime[user.id]
                      : "未能找到记录")),
              trailing: (lastSessionTime.containsKey(user.id))?Text("锻炼记录"):null,
              onTap:  (lastSessionTime.containsKey(user.id))?() {
                _sessionSerivce
                    .getUserCompletedSessions(user.id)
                    .then((List<Session> sessions) {
                  NavigationUtil.pushUsingDefaultFadingTransition(
                      context,
                      SessionHistory(
                        sessions: sessions,
                        sessionPractiseName: user.name + "的",
                      ));
                });
              }:null,
            );
          })
        ],
      )),
    );
  }
}
