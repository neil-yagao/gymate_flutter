import 'package:flutter/material.dart';
import 'package:workout_helper/pages/exercise/training_plan_selection.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'home_calendar.dart';

class TrainingPlanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TrainingPlanPageState();
  }
}

class TrainingPlanPageState extends State<TrainingPlanPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.build(context, title: "我的计划"),
      key: scaffoldKey,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Container(padding: EdgeInsets.all(8), child: HomeCalendar()),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 300,
                padding: EdgeInsets.only(left:28),
                width: MediaQuery.of(context).size.width * 0.45,
                child: InkWell(
                  onTap: (){
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, TrainingPlanSelection());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.inbox,
                        color: Colors.grey,
                        size: 64,
                      ),
                      Text(
                        "标准计划",
                        style: Typography.dense2018.title.merge(
                            TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 300,
                padding: EdgeInsets.only(right:28),
                width: MediaQuery.of(context).size.width * 0.45,
                child: InkWell(
                  onTap: (){
                    showDialog(context: context,builder: (context) => SimpleDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:22.0),
                            child: Text("尚在开发中，敬请期待"),
                          ),
                        ],
                      ),
                    ));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Colors.grey,
                        size: 64,
                      ),
                      Text(
                        "跟随别人",
                        style: Typography.dense2018.title.merge(
                            TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
