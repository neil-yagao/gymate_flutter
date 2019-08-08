import 'package:flutter/material.dart';
import 'package:workout_helper/pages/component/rounded_input.dart';

import 'component/logo.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController cell = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

  TextEditingController verifyCode = TextEditingController();

  TextEditingController name = TextEditingController();

  String verifyButton = "发送验证码";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
              Logo(),
              SizedBox(height: 48.0),
              RoundedInput(
                controller: cell,
                hint: "手机号",
                inputType: TextInputType.phone,
              ), SizedBox(height: 48.0),
              RoundedInput(
                controller: name,
                hint: "昵称",
                inputType: TextInputType.text,
              ),
              SizedBox(height: 8.0),
              RoundedInput(
                controller: password,
                hint: "密码",
                inputType: TextInputType.url,
              ),
              SizedBox(height: 8.0),
              RoundedInput(
                controller: confirmPassword,
                hint: "确认密码",
                inputType: TextInputType.url,
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RoundedInput(
                          controller: confirmPassword,
                          hint: "验证码",
                          inputType: TextInputType.number,
                        ),
                      )),
                  Expanded(
                      child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text(verifyButton),
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8.0),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil("/home",(_)=>false);
                },
                padding: EdgeInsets.all(12),
                color: Colors.redAccent[200],
                child: Text('注册', style: TextStyle(color: Colors.white)),
              )
            ])));
  }
}
