import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/profile_service.dart';

import 'package:workout_helper/pages/profile/body_index_detail.dart';

class BodyIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyIndexPageState();
  }
}

class BodyIndexPageState extends State<BodyIndexPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  List<UserBodyIndex> userBodyIndexes = List();

  Map<BodyIndex, BodyIndexSpecification> bodyIndexMap;

  ProfileService _profileService;
  User _currentUser = User.empty();

  @override
  void didChangeDependencies(){

    super.didChangeDependencies();
    bodyIndexMap = mapBodyIndexInfo();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _profileService = ProfileService(_key);
    _profileService
        .loadUserIndexes(_currentUser.id.toString())
        .then((List<UserBodyIndex> indexes) {
      setState(() {
        this.userBodyIndexes = indexes;
      });
    });
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
          textColor: Theme.of(context).primaryColor,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: DefaultAppBar.build(context,
        title: "维度",
      ),
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        children: buildBodyIndex(),
      )),
    );
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
          return Center(child: BodyIndexDetail(appendIndex: doAddBodyIndex));
        });
  }
}
