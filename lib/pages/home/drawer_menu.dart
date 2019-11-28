import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/community/notification_message_list.dart';
import 'package:workout_helper/pages/exercise/plan_generate.dart';
import 'package:workout_helper/pages/exercise/training_plan_page.dart';
import 'package:workout_helper/pages/general/avatar_crop.dart';
import 'package:workout_helper/pages/general/generic_web_view.dart';
import 'package:workout_helper/pages/general/profile_tile.dart';
import 'package:workout_helper/pages/movement/movement_list_page.dart';
import 'package:workout_helper/pages/nutrition/nutrition_page.dart';
import 'package:workout_helper/pages/nutrition/nutrition_record_list.dart';
import 'package:workout_helper/pages/profile/body_index_page.dart';
import 'package:workout_helper/pages/profile/movement_one_rep_max.dart';
import 'package:workout_helper/pages/profile/user_training_groups.dart';
import 'package:workout_helper/pages/session/session_histories.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/service/profile_service.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

class DrawerMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> homePageKey;
  final int unreadMessageCount;

  const DrawerMenu({Key key, this.homePageKey, this.unreadMessageCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrawerMenuState();
  }
}

class DrawerMenuState extends State<DrawerMenu> {
  User _currentUser;

  MovementService _movementService;

  SessionService _sessionService;

  ProfileService _profileService;

  int _movementAmount = 0;

  int _sessionAmount = 0;

  int _exerciseTemplateAmount = 0;

  int _dietAmount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _profileService = ProfileService(widget.homePageKey);
    _profileService
        .loadUserTrainingService(_currentUser.id.toString())
        .then((Map<String, dynamic> data) {
      if (!this.mounted) {
        return;
      }
      setState(() {
        _sessionAmount = data["session_amount"];
        _movementAmount = data["movement_amount"];
        _dietAmount = data['nutrition_amount'];
        _exerciseTemplateAmount = data['exercise_template_amount'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _movementService = MovementService(widget.homePageKey);
    _sessionService = SessionService(widget.homePageKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, left: 10),
                height: MediaQuery.of(context).size.height * 0.18,
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Consumer<CurrentUserStore>(
                        builder: (context, value, child) => Container(
                              margin: EdgeInsets.only(bottom: 2,left: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0)),
                              child: InkWell(
                                onTap: () {
                                  switchHeaderAvatar();
                                },
                                child: CurrentUserStore.getAvatar(_currentUser,
                                    size: 40),
                              ),
                            )),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(_currentUser.name,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 21)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _currentUser.membership.memberLevel,
                                style: Typography.dense2018.overline
                                    .merge(TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                              ),
                              Text(
                                  "(" +
                                      _currentUser.membership.currentScore
                                          .floor()
                                          .toString() +
                                      ")",
                                  style: Typography.dense2018.overline
                                      .merge(TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              buildGroupInfo()
            ],
          ),
          Divider(),
          Container(
            height: MediaQuery.of(context).size.height * 0.72,
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.email),
                    title: Text("我的消息"),
                    onTap: () {
                      NavigationUtil.pushUsingDefaultFadingTransition(
                          context, NotificationMessageList());
                    },
                    trailing: Container(
                      width: 45,
                      child: Row(
                        children: <Widget>[
                          Text(widget.unreadMessageCount.toString()),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(CustomIcon.isight),
                  title: Text("动作简介"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, MovementListPage());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text("每日饮食"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, NutritionPage());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text("训练计划"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TrainingPlanPage();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind),
                  title: Text(
                    "身体维度",
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BodyIndexPage();
                    }));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: Text("训练历史"),
                  trailing: Container(
                    width: 45,
                    child: Row(
                      children: <Widget>[
                        Text(_sessionAmount.toString()),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  onTap: () {
                    _sessionService
                        .getUserCompletedSessions(
                            Provider.of<CurrentUserStore>(context)
                                .currentUser
                                .id)
                        .then((List<Session> sessions) {
                      Navigator.of(context).maybePop().then((_) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SessionHistory(
                            sessions: sessions,
                          );
                        }));
                      });
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.art_track),
                  title: Text("动作记录"),
                  trailing: Container(
                    width: 45,
                    child: Row(
                      children: <Widget>[
                        Text(_movementAmount.toString()),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  onTap: () {
                    _movementService
                        .getUserMovementOneRepMaxRecorders(_currentUser.id)
                        .then((List<MovementOneRepMax> movements) {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MovementOneRepMaxPage(
                            movementOneRepMax: movements);
                      }));
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.apps),
                  title: Text("我的模板"),
                  trailing: Container(
                    width: 45,
                    child: Row(
                      children: <Widget>[
                        Text(_exerciseTemplateAmount.toString()),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, PlanGenerate());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text("饮食记录"),
                  trailing: Container(
                    width: 45,
                    child: Row(
                      children: <Widget>[
                        Text(_dietAmount.toString()),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    NavigationUtil.pushUsingDefaultFadingTransition(
                        context, NutritionRecordList());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text("快速上手"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return GenericWebView(
                        leading: IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () {
                              Navigator.of(context).maybePop();
                            }),
                        title: "快速上手",
                        url: "https://www.lifting.ren/#/user-manual",
                      );
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text("吐槽专用"),
                  subtitle: Text("Email: neil.hu68@yahoo.com，有任何意见和吐槽，欢迎来邮件。"),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.rotate_left),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("退出"),
                        )
                      ],
                    ),
                    onPressed: () {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.remove("username");
                        prefs.remove("password");
                        Navigator.of(context).pushReplacementNamed("/");
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGroupInfo() {
    return Padding(
        padding: EdgeInsets.only(right: 12),
        child: _currentUser.groupName != null
            ? ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.group),
                ),
                label: Text(_currentUser.groupName),
                onPressed: () {
                  NavigationUtil.pushUsingDefaultFadingTransition(
                      context, UserTrainingGroups());
                },
              )
            : ActionChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.group),
                ),
                label: Text('尚未加入小组'),
                onPressed: () {
                  NavigationUtil.pushUsingDefaultFadingTransition(
                      context, UserTrainingGroups());
                },
              ));
  }

  Widget followColumn(Size deviceSize) => Container(
        height: deviceSize.height * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ProfileTile(
                title: _sessionAmount.toString(),
                subtitle: "训练记录",
                onTap: () {
                  NavigationUtil.showLoading(context);
                  _sessionService
                      .getUserCompletedSessions(
                          Provider.of<CurrentUserStore>(context).currentUser.id)
                      .then((List<Session> sessions) {
                    Navigator.of(context).maybePop().then((_) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SessionHistory(
                          sessions: sessions,
                        );
                      }));
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: ProfileTile(
                title: _dietAmount.toString(),
                subtitle: "饮食记录",
                onTap: () {
                  NavigationUtil.pushUsingDefaultFadingTransition(
                      context, NutritionRecordList());
                },
              ),
            )
          ],
        ),
      );

  void switchHeaderAvatar() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AvatarCrop(
        onCompleted: (File file) {
          setState(() {
            Provider.of<CurrentUserStore>(context).updateUserAvatar(file);
          });
        },
      );
    }));
  }
}
