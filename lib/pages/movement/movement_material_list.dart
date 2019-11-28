import 'package:flutter/material.dart';
import 'package:workout_helper/model/movement.dart';

import 'movement_material_preview.dart';

class MovementMaterialList extends StatelessWidget {
  final List<MovementMaterial> materials;
  final Function(MovementMaterial) onSelected;

  const MovementMaterialList(
      {Key key, @required this.materials, @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (materials.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.36,
              height: MediaQuery.of(context).size.width * 0.27,
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  "尚未有人上传\n成为第一个吧？",
                  style: TextStyle(fontStyle: FontStyle.italic)
                      .merge(Typography.dense2018.subtitle),
                ),
              )),
        ],
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      height: MediaQuery.of(context).size.width * 0.37,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ...materials.map((m) => InkWell(
                child: MovementMaterialPreview(
                  material: m,
                ),
                onTap: () {
                  this.onSelected(m);
                },
              ))
        ],
      ),
    );
  }
}
