import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_entites.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/session_service.dart';

class GroupReport extends StatefulWidget {
  final UserGroup group;
  final List<User> users;

  const GroupReport({Key key, this.group, this.users}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GroupReportState(group, users);
  }
}

class GroupReportState extends State<GroupReport> {
  final UserGroup group;
  final List<User> users;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SessionService _sessionService;
  List<Map<String, dynamic>> groupUserSummary = List();

  List<Map<String, dynamic>> lastWeek;
  List<Map<String, dynamic>> lastMonth;

  Map<int, Map<String, dynamic>> userToSummaryMap = Map();

  String timePeriodShowMonth = "";

  String timePeriodShow = "";

  GroupReportState(this.group, this.users);

  String timePeriod = "week";

  String timePeriodShowWeek = "";

  DateTime startTime;

  DateTime endTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sessionService = SessionService(_scaffoldKey);
    endTime = DateTime.now();
    while (endTime.weekday != DateTime.sunday) {
      endTime = endTime.subtract(Duration(days: 1));
    }
    startTime = endTime.subtract(Duration(days: 7));
    String userIds = users.map((u) => u.id.toString()).join(",");
    timePeriodShowWeek = setTimePeriod();
    _sessionService
        .getGroupSessionReport(userIds, startTime, endTime)
        .then((summary) {
      setState(() {
        groupUserSummary = summary;
        lastWeek = summary;

        timePeriodShow = timePeriodShowWeek;
        doMapping();
        debugPrint('lastWeek' + lastWeek.toString());
      });
    });
    endTime = DateTime.now();
    endTime = DateTime(endTime.year, endTime.month, 0);
    endTime = endTime.add(Duration(days: 1));
    startTime = DateTime(endTime.year, endTime.month - 1, 1);
    timePeriodShowMonth = setTimePeriod();
    _sessionService
        .getGroupSessionReport(userIds, startTime, endTime)
        .then((summary) {
      setState(() {
        lastMonth = summary;
        debugPrint('lastMonth' + lastMonth.toString());
      });
    });
  }

  String setTimePeriod() {
    return DateFormat("yyyy-MM-dd").format(startTime) +
        " 至 " +
        DateFormat("yyyy-MM-dd").format(endTime);
  }

  void doMapping() {
    userToSummaryMap = Map();
    groupUserSummary.forEach((info) {
      userToSummaryMap[info['id']] = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DefaultAppBar.build(context,
        title: group.name,
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("上周"),
                textColor: timePeriod == 'week'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                highlightColor:
                    timePeriod == 'week' ? Colors.grey : Colors.transparent,
                onPressed: () {
                  setState(() {
                    timePeriod = 'week';
                    groupUserSummary = lastWeek;
                    timePeriodShow = timePeriodShowWeek;
                    doMapping();
                  });
                },
              ),
              RaisedButton(
                child: Text("上个月"),
                textColor: timePeriod == 'month'
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                highlightColor:
                    timePeriod == 'month' ? Colors.grey : Colors.transparent,
                onPressed: () {
                  setState(() {
                    timePeriod = 'month';
                    timePeriodShow = timePeriodShowMonth;
                    groupUserSummary = lastMonth;
                    doMapping();
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(timePeriodShow,style: Typography.dense2018.subhead,)
            ],
          ),
          Divider(),
          ...users.map((user) {
            return ListTile(
              title: Text(user.name),
              trailing: userToSummaryMap[user.id] == null
                  ? Text("未找到训练记录")
                  : Text("总计训练次数：" +
                      userToSummaryMap[user.id]['exercise_count'].toString()),
            );
          })
        ],
      )),
    );
  }
}
