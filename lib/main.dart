import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/pages/component/bottom_navigation_bar.dart';
import 'package:workout_helper/pages/home_page.dart';
import 'package:workout_helper/pages/login.dart';
import 'package:workout_helper/pages/nutrition_page.dart';
import 'package:workout_helper/pages/profile_page.dart';
import 'package:workout_helper/pages/register_page.dart';
import 'package:workout_helper/pages/session.dart';
import 'package:workout_helper/service/current_user_store.dart';

import 'general/my_flutter_app_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUserStore>(
        builder: (context) => CurrentUserStore(null),
        child: MaterialApp(
          title: 'Lifting.ren',
          theme: ThemeData(
            //009FF2
            primarySwatch: MaterialColor(0xFFF44336, <int, Color>{
              50: Color(0xFFFFEBEE),
              100: Color(0xFFFFCDD2),
              200: Color(0xFFEF9A9A),
              300: Color(0xFFE57373),
              500: Color(0xFFF44336),
              400: Color(0xFFEF5350),
              600: Color(0xFFE53935),
              700: Color(0xFFD32F2F),
              800: Color(0xFFC62828),
              900: Color(0xFFB71C1C),
            }),
            fontFamily: " Tahoma, Helvetica, Arial, sans-serif",
          ),
          routes: {
            '/': (BuildContext content) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/home': (BuildContext context) => HomePage(),
            '/quickExercise': (BuildContext context) => UserSession("randomId"),
            '/nutrition':(BuildContext context) => NutritionPage(),
            '/profile':(BuildContext context) => ProfilePage(),
            //'/camera': (context) => CameraExampleHome('none')
          },
          initialRoute: '/',
        ));
  }
}
