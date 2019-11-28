import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/nutrition_preference.dart';

class NutritionRecordMaterialTrailingButton extends StatelessWidget {
  final NutritionRecord record;

  const NutritionRecordMaterialTrailingButton({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        icon: Icon(
          Icons.image,
          color: record.materials.isEmpty
              ? Colors.grey
              : Theme.of(context).primaryColor,
        ),
        onPressed: () {
          if (record.materials.isEmpty) {
            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                    child: Card(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                      CarouselSlider(
                        enableInfiniteScroll: false,
                        height: MediaQuery.of(context).size.height * 0.6,
                        items: <Widget>[
                          ...record.materials.map((image) {
                            return Padding(
                              padding: EdgeInsets.all(9),
                              child: Image.network(image),
                            );
                          })
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text("确定"),
                            onPressed: () {
                              Navigator.of(context).maybePop();
                            },
                          )
                        ],
                      ),
                    ])));
              });
        });
  }
}
