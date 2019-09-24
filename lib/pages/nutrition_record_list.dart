import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/nutrition_service.dart';

class NutritionRecordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NutritionRecordListState();
  }
}

class NutritionRecordListState extends State<NutritionRecordList> {
  List<NutritionRecord> _records = List();

  GlobalKey<ScaffoldState> _key = GlobalKey();

  NutritionService _nutritionService;

  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _nutritionService = NutritionService(_key);

    _nutritionService.getUserNutritionRecord(_currentUser.id).then((records) {
      setState(() {
        _records = records;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("近30天饮食记录"),
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          ..._records.map((record) {
            String recordDate =
                DateFormat("yyyy-MM-dd").format(record.recordTime);
            return ListTile(
              isThreeLine: true,
              title: Text(recordDate + "的" + record.name),
              subtitle: Text("计划:" +
                  (record.estimateCals.floor()).toString() +
                  "KCals;\n蛋白质:" +
                  record.getProtein().floor().toString() +
                  "g ,碳水:" +
                  record.getCrabs().floor().toString() +
                  "g, 脂肪:" +
                  record.getFats().floor().toString() +
                  "g"),
              trailing: IconButton(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                CarouselSlider(
                                  enableInfiniteScroll: false,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
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
                  }),
            );
          })
        ],
      )),
    );
  }
}
