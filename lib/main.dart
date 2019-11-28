import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_helper/pages/home/home_page.dart';
import 'package:workout_helper/pages/login.dart';
import 'package:workout_helper/pages/nutrition/nutrition_page.dart';
import 'package:workout_helper/pages/register_page.dart';
import 'package:workout_helper/pages/session/session.dart';
import 'package:workout_helper/service/current_user_store.dart';

import 'model/entities.dart';

CurrentUserStore store = CurrentUserStore(null);

void main() {
  SharedPreferences.getInstance().then((prefs) {
    String username = prefs.getString("username");
    String password = prefs.getString("password");
    if (username != null && password != null) {
      runApp(FutureBuilder<User>(
        future: store.doLogin(username, password),
        builder: (context, user) {
          if (user.data != null) {
            if (user.data.id != null) {
              return MyApp(
                hasLoginIn: true,
              );
            } else {
              return MyApp(
                hasLoginIn: false,
              );
            }
          } else {
            return Card(
              child: SizedBox(
                  height: 10,
                  width: 10,
                  child: Center(child: CircularProgressIndicator())),
            );
          }
        },
      ));
    } else {
      runApp(MyApp(
        hasLoginIn: false,
      ));
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final bool hasLoginIn;

  const MyApp({Key key, this.hasLoginIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentUserStore>(
        builder: (context) => store,
        child: MaterialApp(
          title: 'Lifting.ren',
          theme: ThemeData(
            //009FF2
            primarySwatch: MaterialColor(0xFF857CA4, <int, Color>{
              50: Color(0xFFF3E5F5),
              100: Color(0xFFE1BEE7),
              200: Color(0xFFCE93D8),
              300: Color(0xFFBA68C8),
              400: Color(0xFFAB47BC),
              500: Color(0xFF857CA4),
              600: Color(0xFF8E24AA),
              700: Color(0xFF7B1FA2),
              800: Color(0xFF6A1B9A),
              900: Color(0xFF4A148C),
            }),
            fontFamily: " Tahoma, Helvetica, Arial, sans-serif",
          ),
          routes: {
            '/': (BuildContext content) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/home': (BuildContext context) => HomePage(),
            '/quickExercise': (BuildContext context) => UserSession("randomId"),
            '/nutrition': (BuildContext context) => NutritionPage(),
            //'/camera': (context) => CameraExampleHome('none')
          },
          initialRoute: hasLoginIn ? '/home' : '/',
        ));
  }
}
