import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/profile_tile.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/profile_service.dart';

import 'avatar_crop.dart';
import 'component/body_index_detail.dart';

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

  Widget profileColumn() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://avatars0.githubusercontent.com/u/12619420?s=460&v=4"),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Pawan Kumar posted a photo",
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "25 mins ago",
                  )
                ],
              ),
            ))
          ],
        ),
      );

  List<Widget> bodyIndexes() => buildBodyIndex();

  Widget followColumn(Size deviceSize) => Container(
        height: deviceSize.height * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProfileTile(
              title: "80",
              subtitle: "训练动作",
            ),
            ProfileTile(
              title: "140",
              subtitle: "训练记录",
            ),
            ProfileTile(
              title: "104",
              subtitle: "饮食记录",
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
    super.didChangeDependencies();
    _profileService
        .loadUserIndexes(
            Provider.of<CurrentUserStore>(context).currentUser.id.toString())
        .then((List<UserBodyIndex> indexes) {
      setState(() {
        this.userBodyIndexes = indexes;
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
    return Scaffold(key: _key, body: bodyData());
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
