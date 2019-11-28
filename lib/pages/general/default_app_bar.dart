import 'package:flutter/material.dart';

class DefaultAppBar {
  static AppBar build(BuildContext context,
      {String title, bool implyLeading = true, List<Widget> actions,bool centerTitle = true, Widget leading}) {
    // TODO: implement build
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      leading: leading,
      automaticallyImplyLeading: implyLeading,
      title: Text(
        title??"",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Colors.white60,
      elevation: 0,
      actions: actions,
      centerTitle: centerTitle,
    );
  }
}
