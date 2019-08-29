import 'package:flutter/material.dart';

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
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, a1, a2) => HomePage(),
          transitionsBuilder: (context, animate, a2, child) => FadeTransition(
                opacity: animate,
                child: child,
              ),
          transitionDuration: Duration(milliseconds: 500)));
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, a1, a2) => NutritionPage(),
          transitionsBuilder: (context, animate, a2, child) => FadeTransition(
            opacity: animate,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 500)));
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, a1, a2) => ProfilePage(),
          transitionsBuilder: (context, animate, a2, child) => FadeTransition(
            opacity: animate,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 500)));
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
      selectedItemColor: Colors.blue,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
    );
  }
}
