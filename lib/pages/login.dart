import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var db;
  initDB() async {
    // this.db = await openDatabase('training.db');
  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '手机号',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: '密码',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await initDB();
          Navigator.of(context).pushReplacementNamed("/home");
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('登录', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/camera');
      },
      padding: EdgeInsets.all(12),
      color: Colors.redAccent[200],
      child: Text('手机号体验', style: TextStyle(color: Colors.white)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 16.0),
            loginButton,
            SizedBox(height: 8.0),
            registerButton,
            Divider()
          ],
        ),
      ),
    );
  }
}
