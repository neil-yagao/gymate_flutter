import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/profile_tile.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/service/profile_service.dart';
import 'package:workout_helper/service/session_service.dart';

import 'avatar_crop.dart';
import 'component/body_index_detail.dart';
import 'component/bottom_navigation_bar.dart';
import 'component/movement_one_rep_max.dart';
import 'component/session_histories.dart';

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

  ProfileService _profileService = ProfileService();

  MovementService _movementService = MovementService();

  SessionService _sessionService = SessionService();

  int _movementAmount = 0;

  int _sessionAmount = 0;

  int _dietAmount = 0;

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
                  Text(
                    value.currentUser.groupName == null
                        ? "尚未加入任何小组"
                        : value.currentUser.groupName,
                    style: TextStyle(color: Colors.black),
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

  List<Widget> bodyIndexes() => buildBodyIndex();

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
                      return MovementOneRepMaxPage(movementOneRepMax: movements);
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
                  _sessionService.getUserCompletedSessions(
                      Provider.of<CurrentUserStore>(context).currentUser.id).then((List<Session> sessions){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return SessionHistory(sessions: sessions,);
                        }));
                  });
                },
              ),
            ),
            Expanded(
              child: ProfileTile(
                title: _dietAmount.toString(),
                subtitle: "饮食记录",
                onTap: () {},
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView(
            children: bodyIndexes(),
          ),
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    String userId =
        Provider.of<CurrentUserStore>(context).currentUser.id.toString();
    super.didChangeDependencies();
    _profileService.loadUserIndexes(userId).then((List<UserBodyIndex> indexes) {
      setState(() {
        this.userBodyIndexes = indexes;
      });
    });
    _profileService
        .loadUserTrainingService(userId)
        .then((Map<String, dynamic> data) {
      setState(() {
        _sessionAmount = data["session_amount"];
        _movementAmount = data["movement_amount"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bodyIndexMap = mapBodyIndexInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(),
      body: SafeArea(child: bodyData()),
      bottomNavigationBar: BottomNaviBar(currentIndex: 2,),
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

  List<Widget> buildBodyIndex() {
    if (userBodyIndexes.isEmpty) {
      return [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                addNewBodyIndex();
              },
              child: SizedBox(
                height: 200,
                child: Center(child: Text("尚未添加任何身体指标。")),
              ),
            ))
      ];
    } else {
      return [
        ...userBodyIndexes.map((UserBodyIndex userBodyIndex) {
          return ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(bodyIndexMap[userBodyIndex.bodyIndex].name),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Text(userBodyIndex.value.toString()),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(userBodyIndex.unit),
                    )
                  ],
                )),
              ],
            ),
            subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                .format(userBodyIndex.recordTime)),
          );
        }).toList(),
        Divider(),
        RaisedButton(
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            addNewBodyIndex();
          },
          child: Icon(Icons.add),
          color: Colors.transparent,
          textColor: Colors.grey,
        ),
      ];
    }
  }

  void doAddBodyIndex(UserBodyIndex ubi) {
    setState(() {
      UserBodyIndex hasAdded;
      this.userBodyIndexes.forEach((UserBodyIndex index) {
        if (ubi.bodyIndex == index.bodyIndex) {
          hasAdded = index;
        }
      });
      if (hasAdded != null) {
        //
        this.userBodyIndexes.remove(hasAdded);
      }
      this.userBodyIndexes.add(ubi);
      _profileService.createUserIndex(ubi,
          Provider.of<CurrentUserStore>(context).currentUser.id.toString());
    });
    Navigator.of(context).maybePop();
  }

  void addNewBodyIndex() {
    showCupertinoModalPopup<UserBodyIndex>(
        context: context,
        builder: (BuildContext context) {
          return BodyIndexDetail(appendIndex: doAddBodyIndex);
        });
  }
}
