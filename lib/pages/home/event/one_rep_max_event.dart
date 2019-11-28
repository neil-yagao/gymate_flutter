import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/user_event.dart';

import 'event_self_mixin.dart';

class OneRepMaxEvent extends StatelessWidget with SelfEvent{

  final UserEvent userEvent;

  const OneRepMaxEvent({Key key, this.userEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    MovementOneRepMax oneRepMax = userEvent.relatedRecord as MovementOneRepMax;
    if(oneRepMax == null){
      return Container();
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(isSelf(context,userEvent) ? "我" : userEvent.user.name),
          Text("新的记录：" + oneRepMax.movement.name  ),
          Text(" " + oneRepMax.oneRepMax.floor().toString() + "KG")
        ],
      ),
      subtitle: Text(DateFormat('yyyy-MM-dd hh:mm').format(oneRepMax.practiseTime)),
    );
  }
}