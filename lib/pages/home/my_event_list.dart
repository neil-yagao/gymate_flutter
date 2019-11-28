import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/session/session.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'general_event_list.dart';

class MyEventList extends StatefulWidget {
  const MyEventList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyEventListState();
  }
}

class MyEventListState extends State<MyEventList> {
  List<UserEvent> eventList = List();

  User _currentUser;

  Exercise todayPlannedExercise;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;

  }

  @override
  Widget build(BuildContext context) {
    return GeneralEventList(
      userIds: [_currentUser.id],
      defaultLoadEventAmount: 5,
      defaultEmptyWidget: emptyShow() ,
    );
  }

  Widget emptyShow(){
    return InkWell(
      onTap: () {
        NavigationUtil.pushUsingDefaultFadingTransition(
            context, UserSession("randomId"));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            CustomIcon.hand_peace_o,
            color: Colors.grey,
            size: 64,
          ),
          Text(
            "开始第一次训练吧",
            style: Typography.dense2018.title.merge(
                TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
