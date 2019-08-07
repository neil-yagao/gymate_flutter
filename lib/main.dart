import 'package:flutter/material.dart';
import 'package:workout_helper/pages/camera_page.dart';
import 'package:workout_helper/pages/home_page.dart';
import 'package:workout_helper/pages/login.dart';
import 'package:workout_helper/pages/profile_page.dart';
import 'package:workout_helper/pages/session.dart';

void main() => runApp(MyApp());

final List<Widget> pages = [HomePage(), Text("饮食"), ProfilePage()];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: " Tahoma, Helvetica, Arial, sans-serif",
      ),
      routes: {
        '/': (BuildContext content) => LoginPage(),
        '/home': (BuildContext context) => MyHomePage(title: "GYMate"),
        '/quickExercise': (BuildContext context) => UserSession("randomId"),
        '/camera':(context) => CameraExampleHome('none')
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
            automaticallyImplyLeading:false
        ),
        body: SafeArea(child: pages.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), title: Text("饮食")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("我的")),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ));
  }
}
