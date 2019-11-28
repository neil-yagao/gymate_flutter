import 'package:flutter/material.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';

class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessageListState();
  }
}

class MessageListState extends State<MessageList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<NotificationMessage> loadedList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: DefaultAppBar.build(context, title: "我的消息"),
      body: SafeArea(child: ListView.builder(itemBuilder: (context, index) {
        if (index >= loadedList.length - 1) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Text("空空如野"),
          );
        }
        NotificationMessage message = loadedList.elementAt(index);
        return ListTile(
          title: Text(message.title),
          subtitle: Text(message.content),
        );
      })),
    );
  }
}
