import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/profile_tile.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/service/profile_service.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'avatar_crop.dart';
import 'component/body_index_page.dart';
import 'component/bottom_navigation_bar.dart';
import 'component/generic_web_view.dart';
import 'component/movement_one_rep_max.dart';
import 'component/session_histories.dart';
import 'nutrition_record_list.dart';
import 'user_training_groups.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  File _tempImage;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<UserBodyIndex> userBodyIndexes = List();

  Map<BodyIndex, BodyIndexSpecification> bodyIndexMap;

  ProfileService _profileService;

  MovementService _movementService;

  SessionService _sessionService;

  int _movementAmount = 0;

  int _sessionAmount = 0;

  int _exerciseTemplateAmount = 0;

  int _dietAmount = 0;

  User _currentUser = User.empty();

  Widget profileHeader() => Container(
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          color: Colors.transparent,
          child: Consumer<CurrentUserStore>(
            builder: (context, value, child) => FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: getAvatar(value.currentUser),
                  ),
                  Text(
                    value.currentUser.name,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Text(
                          value.currentUser.groupName == null
                              ? "尚未加入任何小组"
                              : _currentUser.groupName,
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          NavigationUtil.pushUsingDefaultFadingTransition(
                              context, UserTrainingGroups());
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ));

  Widget getAvatar(User currentUser) {
    if (_tempImage != null) {
      return InkWell(
          onTap: () {
            switchHeaderAvatar();
          },
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: FileImage(_tempImage),
          ));
    }
    if (currentUser.avatar != null) {
      return InkWell(
          onTap: () {
            switchHeaderAvatar();
          },
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(currentUser.avatar),
          ));
    } else {
      return InkWell(
          onTap: () {
            switchHeaderAvatar();
          },
          child: CircleAvatar(
            radius: 40,
            child: Text(currentUser.alias),
            backgroundColor: Theme.of(context).primaryColor,
          ));
    }
  }

  Widget followColumn(Size deviceSize) => Container(
        height: deviceSize.height * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ProfileTile(
                title: _movementAmount.toString(),
                subtitle: "训练动作",
                onTap: () async {
                  _movementService
                      .getMovementOneRepMax(
                          Provider.of<CurrentUserStore>(context).currentUser.id)
                      .then((List<MovementOneRepMax> movements) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MovementOneRepMaxPage(
                          movementOneRepMax: movements);
                    }));
                  });
                },
              ),
            ),
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
//            Expanded(
//              child: ProfileTile(
//                title: _exerciseTemplateAmount.toString(),
//                subtitle: "训练模板",
//                onTap: () async {
//                  NavigationUtil.pushUsingDefaultFadingTransition(
//                      context, PlanGenerate());
//                },
//              ),
//            ),
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

  Widget bodyData() {
    return ListView(
      children: <Widget>[
        profileHeader(),
        followColumn(MediaQuery.of(context).size),
        Divider(),
        ListTile(
          leading: Icon(Icons.assignment_ind),
          title: Text(
            "身体指标",
            style: Typography.dense2018.subhead,
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BodyIndexPage();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text("快速上手"),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;

    _profileService
        .loadUserTrainingService(_currentUser.id.toString())
        .then((Map<String, dynamic> data) {
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
    super.initState();
    _movementService = MovementService(_key);
    _profileService = ProfileService(_key);
    _sessionService = SessionService(_key);
    bodyIndexMap = mapBodyIndexInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              child: Icon(
                CustomIcon.logout,
                color: Colors.white,
              ),
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove("username");
                  prefs.remove("password");
                  Navigator.of(context).pushReplacementNamed("/");
                });
              },
            ),
          )
        ],
      ),
      body: SafeArea(child: bodyData()),
      bottomNavigationBar: BottomNaviBar(
        currentIndex: 3,
      ),
    );
  }

  void switchHeaderAvatar() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AvatarCrop(
        onCompleted: (File file) {
          setState(() {
            _tempImage = file;
            Provider.of<CurrentUserStore>(context).updateUserAvatar(file);
          });
        },
      );
    }));
  }
}
