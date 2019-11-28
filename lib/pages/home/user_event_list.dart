import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';

import 'general_event_list.dart';
import 'home_page.dart';
import 'my_event_list.dart';

class UserEventListView extends StatefulWidget {
  final int currentUserId;

  const UserEventListView({Key key, this.currentUserId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserEventListViewState();
  }
}

class UserEventListViewState extends State<UserEventListView>
    with SingleTickerProviderStateMixin {
  Tab mePanel;
  Tab groupPanel;
  List<Tab> myTabs = [];

  User _user;
  List<User> sameGroupUsers = List();
  CommunityService _communityService;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<CurrentUserStore>(context).currentUser;
    _communityService = CommunityService(HomePage.of(context).scaffoldKey);
    _communityService.getRelatedUsers(_user.id).then((users) {
      sameGroupUsers = users;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    mePanel = Tab(
      child: Text(
        '我的训练日记',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
    groupPanel = Tab(
      child: Text(
        '小组新鲜事',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );

    myTabs = [mePanel, groupPanel];
    return Column(children: <Widget>[
      TabBar(
        controller: _tabController,
        tabs: myTabs,
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height * .42,
          child: TabBarView(
              controller: _tabController,
              children: myTabs.map((Tab tab) {
                if (tab == mePanel) {
                  return MyEventList();
                } else {
                  return GeneralEventList(
                    userIds: sameGroupUsers.map((u) => u.id).toList(),
                  );
                }
              }).toList()))
    ]);
  }
}
