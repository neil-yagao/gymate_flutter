import 'package:flutter/material.dart';
import 'package:workout_helper/util/navigation_util.dart';

import '../home_page.dart';
import '../nutrition_page.dart';
import '../profile_page.dart';

class BottomNaviBar extends StatefulWidget {
  final int currentIndex;

  const BottomNaviBar({Key key, this.currentIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomNaviBarState(currentIndex);
  }
}

class BottomNaviBarState extends State<BottomNaviBar> {
  final int currentIndex;

  BottomNaviBarState(this.currentIndex);

  void _onItemTapped(int index) {
    if (index == 0) {
      NavigationUtil.replaceUsingDefaultFadingTransition(context, HomePage());
    } else if (index == 1) {
      NavigationUtil.replaceUsingDefaultFadingTransition(context, NutritionPage());
    } else if (index == 2) {
      NavigationUtil.replaceUsingDefaultFadingTransition(context, ProfilePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), title: Text("饮食")),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("我的")),
      ],
      currentIndex: currentIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
    );
  }
}
