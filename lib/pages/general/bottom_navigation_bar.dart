import 'package:flutter/material.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/pages/community/community_main.dart';
import 'package:workout_helper/pages/home/home_page.dart';
import 'package:workout_helper/pages/movement/movement_list_page.dart';
import 'package:workout_helper/pages/nutrition/nutrition_page.dart';
import 'package:workout_helper/util/navigation_util.dart';

class BottomNaviBar extends StatefulWidget {
  final int currentIndex;

  const BottomNaviBar({Key key, @required this.currentIndex}) : super(key: key);

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
      NavigationUtil.replaceUsingDefaultFadingTransition(
          context, MovementListPage());
    } else if (index == 2) {
      NavigationUtil.replaceUsingDefaultFadingTransition(
          context, NutritionPage());
    } else if (index == 3) {
      NavigationUtil.replaceUsingDefaultFadingTransition(
          context, CommunityMain());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
        BottomNavigationBarItem(
            icon: Icon(CustomIcon.isight), title: Text("动作")),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), title: Text("饮食")),
        BottomNavigationBarItem(
            activeIcon: Container(
                height: 24,
                width: 24,
                child: Image.asset(
                  "assets/community_active.png",
                  fit: BoxFit.fill,
                )),
            icon: Container(
                height: 24,
                width: 24,
                child: Image.asset(
                  "assets/community_inactive.png",
                  fit: BoxFit.fill,
                )),
            title: Text("社区"))
      ],
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onItemTapped,
    );
  }
}
