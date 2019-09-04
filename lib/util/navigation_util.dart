import 'package:flutter/material.dart';

class NavigationUtil {

  static Future replaceUsingDefaultFadingTransition( context,Widget widget ){
    return Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, a1, a2) => widget ,
        transitionsBuilder: (context, animate, a2, child) => FadeTransition(
          opacity: animate,
          child: child,
        ),
        transitionDuration: Duration(milliseconds: 500)));
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
}