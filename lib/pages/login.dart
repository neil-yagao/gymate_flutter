import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/logo.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'package:workout_helper/pages/general/rounded_input.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isReady = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  SharedPreferences _preferences;

//  @override
//  void initState() {
//    super.initState();
//    email.text = '13951928868';
//    password.text = '12345678';
//  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SharedPreferences.getInstance().then((prefs) {
      _preferences = prefs;
      String username = prefs.getString("username");
      String pwd = prefs.getString("password");
      if (username != null && pwd != null) {

        email.text = username;
        password.text = pwd;
      }
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final loginButton = Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          doLogin(email.text, password.text);
        },
        padding: EdgeInsets.all(12),
        color:  Color.fromRGBO(101, 85, 153, 0.6),
        child: Text('登录', style: TextStyle(color: Colors.white)),
      ),
    );

    final wechatLoginButton = Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          //appid:wx0ba2504cc150b3f6
          //appsecret:9ee453e2039ae45a82269956e5de101f
          //userPersistenceService.doLogin(email.text, password.text);
        },
        padding: EdgeInsets.all(12),
        color: Colors.green[700],
        child: Text('微信登录', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/register');
      },
      padding: EdgeInsets.all(12),
      color: Colors.transparent,
      child: Text('注册', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Logo(),
            SizedBox(height: 48.0),
            RoundedInput(
              controller: email,
              hint: "手机/用户名",
              inputType: TextInputType.phone,
            ),
            SizedBox(height: 8.0),
            RoundedInput(
              controller: password,
              hint: "密码",
              inputType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 16.0),
            loginButton,
            SizedBox(height: 8.0),
            registerButton,
            Divider(),
            //wechatLoginButton
          ],
        ),
      ),
    );
  }

  Future doLogin(String username, String password) async {
    _preferences.setString("username", username);
    _preferences.setString("password", password);
    if (!this.mounted) {
      return;
    }
    NavigationUtil.showLoading(context, content: "正在登陆...");
    User currentUser = await Provider.of<CurrentUserStore>(context)
        .doLogin(username, password);
    Navigator.of(context).pop();
    if (currentUser != null && currentUser.id != null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (_) => false);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("登录失败，请检查网络或者用户名密码是否正确。")));
    }
  }


}
