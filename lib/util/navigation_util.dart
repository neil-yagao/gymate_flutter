import 'package:flutter/material.dart';

class NavigationUtil {

  static Future replaceUsingDefaultFadingTransition( context,Widget widget ){
    return Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
        pageBuilder: (context, a1, a2) => widget ,
        transitionsBuilder: (context, animate, a2, child) => FadeTransition(
          opacity: animate,
          child: child,
        ),
        transitionDuration: Duration(milliseconds: 500)),(_) => false);
  }

  static Future pushUsingDefaultFadingTransition( context,Widget widget ){
    return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, a1, a2) => widget ,
        transitionsBuilder: (context, animate, a2, child) => FadeTransition(
          opacity: animate,
          child: child,
        ),
        transitionDuration: Duration(milliseconds: 500)));
  }

  static Future showLoading(BuildContext context, {String content}) {
    return showDialog(
      context: context,
      builder:(context)=> new Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(content == null ? "请稍后..." : content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}