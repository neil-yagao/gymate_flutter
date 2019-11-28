import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/community/community_main.dart';
import 'package:workout_helper/pages/home/home_page.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/notification_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

const double kToolbarHeight = 50.0;

class NavigateAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentPage;
  final int unreadMessageCount;

  const NavigateAppBar({Key key, this.currentPage, this.unreadMessageCount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NavigateAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class NavigateAppBarState extends State<NavigateAppBar> {
  TextStyle activeTabStyle;

  TextStyle normalTabStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    activeTabStyle = Typography.dense2018.body1.merge(TextStyle(
        color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold));
    normalTabStyle = Typography.dense2018.body1;

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              "我的",
              style: widget.currentPage == 0 ? activeTabStyle : normalTabStyle,
            ),
            onPressed: () {
              NavigationUtil.replaceUsingDefaultFadingTransition(
                  context, HomePage());
            },
          ),
          FlatButton(
            child: Text("社区",
                style:
                    widget.currentPage == 1 ? activeTabStyle : normalTabStyle),
            onPressed: () {
              NavigationUtil.replaceUsingDefaultFadingTransition(
                  context, CommunityMain());
            },
          )
        ],
      ),
      automaticallyImplyLeading: false,
      actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      actions: Scaffold.of(context).hasEndDrawer
          ? <Widget>[
              Badge(
                position: BadgePosition.topRight(top:4.0,right:4.0),
                showBadge: widget.unreadMessageCount > 0,
                child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    }),
              )
            ]
          : null,
    );
  }
}
