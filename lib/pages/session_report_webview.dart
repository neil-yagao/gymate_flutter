import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:share/share.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/util/navigation_util.dart';
import 'dart:io' show Platform;

import 'component/generic_web_view.dart';
import 'home_page.dart';

class SessionReportWebView extends StatelessWidget {
  final Session completedSession;
  final bool canGoBack;

  const SessionReportWebView(
      {Key key, @required this.completedSession, this.canGoBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String reportUrl =
        "https://www.lifting.ren/#/session-report/" + this.completedSession.id;
    return GenericWebView(
    leading: IconButton(icon: Icon(Icons.home), onPressed: (){
      NavigationUtil.replaceUsingDefaultFadingTransition(context, HomePage());
    }),
      title: "训练报告",
      url: reportUrl,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Colors.white,
          onPressed: () {
            if(Platform.isAndroid) {
              fluwx.register(
                  appId: "wx0ba2504cc150b3f6",
                  universalLink: "http://www.lifting.ren/").then((val) {
                fluwx.share(fluwx.WeChatShareWebPageModel(
                    webPage: reportUrl,
                    title: "我的健身报告",
                    scene: fluwx.WeChatScene.TIMELINE,
                    thumbnail: "assets://assets/logo.jpg")).catchError((error) {
                  showDialog(context: context, builder: (context) =>
                      Card(
                        child: Text(error.toString()),
                      ));
                });
              });
            }else {
              Share.share(reportUrl,subject: "我的健身报告" );
            }
          },
        )
      ],
    );
  }
}
