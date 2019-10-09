import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/user_entites.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'group_user_list.dart';

class UserTrainingGroups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserTrainingGroupsState();
  }
}

class UserTrainingGroupsState extends State<UserTrainingGroups> {
  String _groupName = "";

  String _groupCode = "";

  List<UserGroup> groups = List();

  CurrentUserStore userStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userStore = Provider.of<CurrentUserStore>(context);
    userStore.getCurrentUserGroup().then((gs) {
      setState(() {
        this.groups = gs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的小组"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Icon(Icons.add),
            onPressed: () {
              showJoinAlert();
            },
          )
        ],
      ),
      body: groups.isEmpty
          ? noGroup()
          : ListView(
              children: <Widget>[
                ...groups.map((g) {
                  return ListTile(
                    onTap: () {
                      NavigationUtil.pushUsingDefaultFadingTransition(
                          context, GroupUserList(group: g,));
                    },
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(g.name),
                        ),
                        Expanded(
                          child: Text(g.groupUserNumber.toString() + "人"),
                        )
                      ],
                    ),

                    ///currently there is no need for default group
//                    leading: userStore.currentUser.groupName == g.name
//                        ? Icon(Icons.check_circle_outline, color: Colors.green)
//                        : Icon(
//                            Icons.crop_square,
//                            color: Colors.grey,
//                          ),
                    subtitle: Text(g.code),
                    trailing: Icon(Icons.chevron_right),
                  );
                })
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: FlatButton(
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  createNewGroup();
                },
                child: Text(
                  "创建新的训练小组",
                  style: Typography.dense2018.subtitle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  createNewGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: TextField(
                      onChanged: (val) {
                        this._groupName = val;
                      },
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: "小组名称",
                          suffixText: "*",
                          suffixStyle:
                              TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      onChanged: (val) {
                        this._groupCode = val;
                      },
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: "自定义小组代码",
                          hintText: "请至少输入4个字母"),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      userStore
                          .createTrainingGroup(_groupName, _groupCode)
                          .then((userGroup) {
                        setState(() {
                          groups.add(userGroup);
                        });
                        Navigator.of(context).maybePop();
                      });
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: Text("新增"),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget noGroup() {
    return Center(
      child: InkWell(
        onTap: () {
          showJoinAlert();
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
              "试试加个小组吧？",
              style: Typography.dense2018.title.merge(
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }

  showJoinAlert() {
    showDialog<String>(
        context: context,
        builder: (context) {
          String groupCode = '';
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      "请输入小组的编码",
                      style: Typography.dense2018.subhead
                          .merge(TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (val) {
                        groupCode = val;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: FlatButton(
                          child: Text("确定"),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).maybePop(groupCode);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }).then((groupCode) {
      if (groupCode == null || groupCode.isEmpty) {
        return;
      }
      print("groupCode:" + groupCode);
      userStore.joinGroup(groupCode).then((joinedGroup) {
        setState(() {
          groups.add(joinedGroup);
        });
      }).catchError((_){
        showDialog(context:context,builder: (context){
          return AlertDialog(
            title: Text("加入小组失败，请检查小组：" + groupCode + "是否存在。"),
          );
        });

      });
    });
  }
}
