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
