import 'package:flutter/material.dart';
import 'package:workout_helper/pages/camera_page.dart';
import 'package:workout_helper/pages/home_page.dart';
import 'package:workout_helper/pages/login.dart';
import 'package:workout_helper/pages/profile_page.dart';
import 'package:workout_helper/pages/register_page.dart';
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
        //009FF2
        primarySwatch: MaterialColor(0XFF009FF2, <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(0xFF009FF2),
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      }),
        fontFamily: " Tahoma, Helvetica, Arial, sans-serif",
      ),
      routes: {
        '/': (BuildContext content) => LoginPage(),
        '/register':(context) => RegisterPage(),
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
