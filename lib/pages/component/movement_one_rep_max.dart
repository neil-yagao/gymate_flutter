import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/entities.dart';

class MovementOneRepMaxPage extends StatelessWidget {
  final List<MovementOneRepMax> movementOneRepMax;

  const MovementOneRepMaxPage({Key key, @required this.movementOneRepMax})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("动作总结"),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("1 Rep Max",style: Typography.dense2018.headline,),
              ],
            ),
          ),
          ...movementOneRepMax.map((MovementOneRepMax morm) {
            return ListTile(
              title: Text(morm.movement.name),
              trailing: Text(morm.oneRepMax.toString() + "KG"),
              subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(morm.practiseTime)),
            );
          })
        ],
      )),
    );
  }
}
