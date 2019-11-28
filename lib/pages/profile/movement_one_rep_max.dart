import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';

import '../../model/entities.dart';

class MovementOneRepMaxPage extends StatelessWidget {
  final List<MovementOneRepMax> movementOneRepMax;

  const MovementOneRepMaxPage({Key key, @required this.movementOneRepMax})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar.build(context,
        title: "最大重量",
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ...movementOneRepMax.map((MovementOneRepMax morm) {
            return ListTile(
              title: Text(morm.movement.name),
              trailing: Text(morm.oneRepMax.floor().toString() + "KG"),
              subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(morm.practiseTime.add(Duration(hours: 8)))),
            );
          })
        ],
      )),
    );
  }
}
