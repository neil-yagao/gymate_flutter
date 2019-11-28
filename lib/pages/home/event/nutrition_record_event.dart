import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/general/nutrition_record_material_trailing_button.dart';

import 'event_self_mixin.dart';

class NutritionRecordEvent extends StatefulWidget {
  final UserEvent userEvent;

  const NutritionRecordEvent({Key key, this.userEvent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NutritionRecordEventState();
  }
}

class NutritionRecordEventState extends State<NutritionRecordEvent>
    with SelfEvent {
  @override
  Widget build(BuildContext context) {
    NutritionRecord record = widget.userEvent.relatedRecord as NutritionRecord;
    if(record == null){
      return Container();
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(isSelf(context, widget.userEvent)
              ? "我"
              : widget.userEvent.user.name),
          Text("记录了" + DateFormat('yyyy-MM-dd').format(record.recordTime.add(Duration(hours: 8))) +  "的" + record.name)
        ],
      ),
      subtitle: Text("计划摄入:" +
          record.estimateCals.floor().toString() +
          "KCals;\n蛋白质:" +
          record.getProtein().floor().toString() +
          "g ,碳水:" +
          record.getCrabs().floor().toString() +
          "g, 脂肪:" +
          record.getFats().floor().toString() +
          "g"),
      leading: NutritionRecordMaterialTrailingButton(
        record: record,
      ),
      trailing:  Text(
        " +1",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontStyle: FontStyle.italic)
            .merge(Typography.dense2018.subhead),
      ),
    );
  }
}
