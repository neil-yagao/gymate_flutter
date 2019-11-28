
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';

class UserInfoTile extends StatelessWidget {

  final User postBy;
  final DateTime postAt;

  const UserInfoTile({Key key, this.postBy, this.postAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: CurrentUserStore.getAvatar(postBy,size: 20),
      title: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(postBy.name,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
                fontSize: 16)),
      ),
      subtitle: Text(
        "发布于 " +
            DateFormat('yyyy-MM-dd hh:mm:ss')
                .format(postAt.add(Duration(hours: 8))),
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
            fontSize: 14),
      ),
    );
  }
}