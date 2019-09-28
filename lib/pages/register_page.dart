import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/component/rounded_input.dart';
import 'package:workout_helper/service/basic_dio.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

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

  Dio dio;

  String cellPhone = "";

  Timer t;
  @override
  void initState() {
    super.initState();
    dio = DioInstance.getInstance(_globalKey);
  }

  @override
  void dispose(){
    t?.cancel();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
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
                  onChanged: (String cell) {
                    setState(() {
                      this.cellPhone = cell;
                    });
                  },
                ),
                SizedBox(height: 8.0),
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
                            controller: verifyCode,
                            hint: "验证码",
                            inputType: TextInputType.number,
                          ),
                        )),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: cellPhone.trim().length == 11 &&
                              verifyButton == '发送验证码'
                          ? () async {
                              if (!this.mounted) {
                                return;
                              }
                              dio
                                  .get('/user/verify-code/' + cell.text)
                                  .then((value) {
                                setState(() {
                                  verifyButton = 60.toString();
                                  t =
                                      Timer.periodic(Duration(seconds: 1), (t) {
                                    if (int.parse(verifyButton) <= 0) {
                                      setState(() {
                                        verifyButton = '发送验证码';
                                      });
                                      t.cancel();
                                    }
                                    if (verifyButton.contains(RegExp("\\d"))) {
                                      setState(() {
                                        verifyButton =
                                            (int.parse(verifyButton) - 1)
                                                .toString();
                                      });
                                    }
                                  });
                                });
                                _globalKey.currentState.showSnackBar(
                                    SnackBar(content: Text("验证码发送成功")));
                              });
                            }
                          : null,
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
                    if (name.text == null) {
                      showSnackBar("昵称未填写");
                      return;
                    }
                    if (password.text != confirmPassword.text) {
                      showSnackBar("密码不一致");
                      return;
                    }
                    if (verifyCode.text ==
                        null /*|| verifyCode.text.length != 4*/) {
                      showSnackBar("验证码未填写");
                      return;
                    }
                    NavigationUtil.showLoading(context,content:"正在为您注册...");
                    Provider.of<CurrentUserStore>(context)
                        .register(
                            name.text, password.text, cell.text, verifyCode.text)
                        .then((User _) {
                          Navigator.of(context).maybePop();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/home", (_) => false);
                    }).catchError((_) {});
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.redAccent[200],
                  child: Text('注册', style: TextStyle(color: Colors.white)),
                )
              ])),
        ));
  }

  void showSnackBar(String content) {
    _globalKey.currentState.showSnackBar(SnackBar(content: Text(content)));
  }

}
