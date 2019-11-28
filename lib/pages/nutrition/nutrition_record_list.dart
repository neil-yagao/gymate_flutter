import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/pages/general/nutrition_record_material_trailing_button.dart';
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
      appBar: DefaultAppBar.build(context,
        title: "近30天饮食记录",
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
              trailing: NutritionRecordMaterialTrailingButton(
                record: record,
              ),
            );
          })
        ],
      )),
    );
  }
}
