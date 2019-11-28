import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/generic_web_view.dart';
import 'package:workout_helper/pages/home/home_page.dart';
import 'package:workout_helper/util/navigation_util.dart';

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
      leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            NavigationUtil.replaceUsingDefaultFadingTransition(
                context, HomePage());
          }),
      title: DateFormat('yyyy-MM-dd').format(completedSession.accomplishedTime),
      url: reportUrl,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            fluwx
                .registerWxApi(
                    appId: "wx0ba2504cc150b3f6",
                    universalLink: "https://www.lifting.ren/")
                .then((val) {
              fluwx
                  .shareToWeChat(fluwx.WeChatShareWebPageModel(
                      webPage: reportUrl,
                      title: "我的训练",
                      scene: fluwx.WeChatScene.TIMELINE,
                      thumbnail: "assets://assets/logo.png"))
                  .catchError((error) {
                showDialog(
                    context: context,
                    builder: (context) => Card(
                          child: Text(error.toString()),
                        ));
              });
            });
          },
        )
      ],
    );
  }
}
