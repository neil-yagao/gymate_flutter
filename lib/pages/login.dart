import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:workout_helper/pages/component/logo.dart';

import 'component/rounded_input.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var db;
  bool isReady = false;

  initDB() async {
    // this.db = await openDatabase('training.db');
  }

  @override
  void initState() {
    super.initState();
    fluwx.responseFromAuth.listen((resp) {
      print("resp = $resp");
    });

  }

  @override
  Widget build(BuildContext context) {

    TextEditingController email = TextEditingController();

    TextEditingController password =  TextEditingController();

    final loginButton = Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await initDB();
          Navigator.of(context).pushNamedAndRemoveUntil("/home",(_)=>false);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
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
          var value = await fluwx.register(appId: "wxc3a4e5bd4e1a502f");
          print('value' + value.toString());
          var data = await fluwx.sendAuth(
              scope: "snsapi_userinfo", state: '${DateTime.now().millisecondsSinceEpoch}');
          print('data' + data.toString());
          //Navigator.of(context).pushReplacementNamed("/home");
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
      color: Colors.redAccent[200],
      child: Text('注册', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Logo(),
            SizedBox(height: 48.0),
            RoundedInput(controller: email,hint: "手机/用户名",inputType: TextInputType.phone,),
            SizedBox(height: 8.0),
            RoundedInput(controller: password,hint: "密码",inputType: TextInputType.url,),
            SizedBox(height: 16.0),
            loginButton,
            SizedBox(height: 8.0),
            registerButton,
            Divider(),
            //fwechatLoginButton
          ],
        ),
      ),
    );
  }
}
