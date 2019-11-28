import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/movement.dart';

class MovementMaterialPreview extends StatelessWidget {
  final MovementMaterial material;

  const MovementMaterialPreview({Key key, this.material}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(style: BorderStyle.solid, color: Colors.grey))),
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width * 0.27,
              width: MediaQuery.of(context).size.width * 0.36,
              child: Image.network(
                material.frontPagePic,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(material.uploadBy.name + '@' + DateFormat('yyyy-MM-dd').format(material.uploadAt),
              style: Typography.dense2018.caption
                ,),
            ),
          ],
        ));
  }
}
