import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/profile_tile.dart';
import 'package:workout_helper/service/current_user_store.dart';

import 'avatar_crop.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  File _tempImage;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
                    value.currentUser.groupName,
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
      return Observer(builder: (BuildContext context) {
        return InkWell(
            onTap: () {
              switchHeaderAvatar();
            },
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(currentUser.avatar),
            ));
      });
    } else {
      return Observer(builder: (BuildContext context) {
        return InkWell(
            onTap: () {
              switchHeaderAvatar();
            },
            child: CircleAvatar(
              radius: 40,
              child: Text(currentUser.alias),
              backgroundColor: Theme.of(context).primaryColor,
            ));
      });
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

  Widget bodyIndexes() => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Post",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
              ),
              profileColumn(),
              Expanded(
                child: Card(
                  elevation: 2.0,
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2018/06/12/01/04/road-3469810_960_720.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget followColumn(Size deviceSize) => Container(
        height: deviceSize.height * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProfileTile(
              title: "280次",
              subtitle: "被点赞",
            ),
            ProfileTile(
              title: "140",
              subtitle: "次训练",
            ),
            ProfileTile(
              title: "10",
              subtitle: "追随者",
            )
          ],
        ),
      );

  Widget bodyData() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileHeader(),
            followColumn(MediaQuery.of(context).size),
            bodyIndexes(),
            RaisedButton(
              child: Text("logout"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            )
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
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
          });
        },
      );
    }));
  }
}
