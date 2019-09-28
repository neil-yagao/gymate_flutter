import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/nutrition_service.dart';
import 'package:workout_helper/service/profile_service.dart';

import 'camera_page.dart';
import 'component/sample_meal.dart';
import 'component/bottom_navigation_bar.dart';
import 'component/diet_pattern.dart';
import 'component/label_radio.dart';
import 'component/macro_nutrition_panel.dart';

class NutritionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NutritionPageState();
  }
}

class NutritionPageState extends State<NutritionPage> {
  int _expandingPanel = -1;

  UserNutritionPreference _userNutritionPreference;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  NutritionService nutritionService;

  ProfileService profileService;

  List<UserBodyIndex> _userBodyIndexes;

  int _gender = 1;

  bool _editing = false;

  TextEditingController _age = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _weight = TextEditingController();

  List<NutritionRecord> todayRecords = List();
  NutritionPreference _selectedNutritionPreference =
      NutritionPreference.CARB_CYCLE;

  UserNutritionPreference _cacheNutritionPreference;

  double _activityMultiply = 1.2;
  User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<CurrentUserStore>(context).currentUser;
    nutritionService = NutritionService(_scaffoldKey);
    profileService = ProfileService(_scaffoldKey);
    Future.wait([
      nutritionService.getUserNutritionPreference(user.id),
      profileService.loadUserIndexes(user.id.toString())
    ]).then((result) {
      if (result.length < 2) {
        return;
      }
      setState(() {
        _userBodyIndexes = result[1];
        UserBodyIndex age = findBodyIndex(BodyIndex.AGE);
        if (age != null) {
          _age.text = age.value.toString();
        }
        UserBodyIndex height = findBodyIndex(BodyIndex.HEIGHT);
        if (height != null) {
          _height.text = height.value.toString();
        }
        UserBodyIndex weight = findBodyIndex(BodyIndex.WEIGHT);
        if (weight != null) {
          _weight.text = weight.value.toString();
        }
        UserNutritionPreference preference = result[0];
        if (_editing) {
          return;
        }
        if (preference != null && preference.user != null) {
          _userNutritionPreference = preference;
          nutritionService
              .fetchSuggestionDivision(preference)
              .then((List<NutritionRecord> nutritionRecord) {
            setState(() {
              todayRecords = nutritionRecord;
            });
          });
        }
      });
    });
  }

  UserBodyIndex findBodyIndex(BodyIndex seekingIndex) {
    try {
      return _userBodyIndexes
          .firstWhere((index) => index.bodyIndex == seekingIndex);
    } catch (e) {
      return null;
    }
  }

  Widget userChosenPreference() {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool expanded) {
          setState(() {
            if (expanded) {
              _expandingPanel = -1;
            } else {
              _expandingPanel = index;
            }
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _expandingPanel == 0,
            headerBuilder: (BuildContext context, isExpanded) => ListTile(
              leading: Icon(Icons.fastfood),
              title: Row(
                children: <Widget>[
                  Text(
                    _userNutritionPreference.getNutritionPreferenceName(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child:
                        Text(_userNutritionPreference.tdee.floor().toString()),
                  ),
                  Text(" KCals",
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            body: MacroNutritionPanel(_userNutritionPreference, null),
          ),
          ...todayRecords.map((NutritionRecord nr) {
            return ExpansionPanel(
              isExpanded: _expandingPanel == todayRecords.indexOf(nr) + 1,
              headerBuilder: (BuildContext context, isExpanded) => ListTile(
                leading: InkWell(
                    child: Icon(
                      Icons.check,
                      color: nr.id == null ? Colors.grey : Colors.greenAccent,
                    ),
                    onTap: () {
                      nutritionService
                          .saveNutritionRecord(user.id, nr)
                          .then((NutritionRecord savedNutritionRecord) {
                        setState(() {
                          nr.id = savedNutritionRecord.id;
                          _expandingPanel = todayRecords.indexOf(nr) + 1;
                        });
                      });
                    }),
                title: Row(
                  children: <Widget>[
                    Text(nr.name + ", 约：",
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic)),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(nr.estimateCals.floor().toString()),
                    ),
                    Text(" KCals",
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              body: MacroNutritionPanel(nr, [SampleMeal(nutritionRecord: nr)]),
            );
          })
        ],
      ),
    );
  }

  Widget userChosePreference() {
    return Card(
      child: ListView(
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: LabeledRadio<int>(
                    value: 1,
                    padding: EdgeInsets.all(8),
                    label: Text("女"),
                    groupValue: _gender,
                    onChanged: (int value) {
                      setState(
                        () {
                          _gender = value;
                        },
                      );
                    }),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: LabeledRadio(
                      value: 0,
                      padding: EdgeInsets.all(8),
                      label: Text("男"),
                      groupValue: _gender,
                      onChanged: (int value) {
                        setState(
                          () {
                            _gender = value;
                          },
                        );
                      })),
              Expanded(
                child: ListTile(
                  dense: true,
                  title: TextField(
                    textAlign: TextAlign.center,
                    controller: _age,
                    decoration: InputDecoration(
                        isDense: true, labelText: "年龄", suffixText: "岁"),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  dense: true,
                  title: TextField(
                    textAlign: TextAlign.center,
                    controller: _height,
                    decoration: InputDecoration(
                        isDense: true, labelText: "身高", suffixText: "cm"),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  dense: true,
                  title: TextField(
                    textAlign: TextAlign.center,
                    controller: _weight,
                    decoration: InputDecoration(
                        isDense: true, labelText: "体重", suffixText: "KG"),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          RadioListTile<double>(
            dense: true,
            value: 1.2,
            groupValue: _activityMultiply,
            title: Text("文职且不怎么运动"),
            onChanged: (double value) {
              setState(() {
                _activityMultiply = 1.2;
              });
            },
          ),
          RadioListTile<double>(
            dense: true,
            value: 1.375,
            groupValue: _activityMultiply,
            title: Text("每周运动1~3次"),
            onChanged: (double value) {
              setState(() {
                _activityMultiply = 1.375;
              });
            },
          ),
          RadioListTile<double>(
            dense: true,
            value: 1.55,
            groupValue: _activityMultiply,
            title: Text("每周运动3~5次"),
            onChanged: (double value) {
              setState(() {
                _activityMultiply = 1.55;
              });
            },
          ),
          RadioListTile<double>(
            dense: true,
            value: 1.72,
            groupValue: _activityMultiply,
            title: Text("每周运动6~7次"),
            onChanged: (double value) {
              setState(() {
                _activityMultiply = 1.72;
              });
            },
          ),
          RadioListTile<double>(
            dense: true,
            value: 1.9,
            groupValue: _activityMultiply,
            title: Text("体力劳动者，或每天运动量较大"),
            onChanged: (double value) {
              setState(() {
                _activityMultiply = 1.9;
              });
            },
          ),
          DietPattern(onUserSelectingPreference: (preference) {
            _selectedNutritionPreference = preference;
          }),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _editing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FlatButton(
                        textColor: Colors.orangeAccent,
                        child: Text("取消"),
                        onPressed: () {
                          setState(() {
                            _userNutritionPreference =
                                _cacheNutritionPreference;
                            _editing = false;
                          });
                        },
                      ))
                  : Text(""),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("确认"),
                  onPressed: () {
                    UserNutritionPreference preference =
                        UserNutritionPreference.empty();
                    preference.user = user;
                    preference.bmr = 10 * double.parse(_weight.text) +
                        6.25 * double.parse(_height.text) -
                        5 * double.parse(_age.text) +
                        5 +
                        (_gender * -166);
                    preference.tdee = preference.bmr * _activityMultiply;
                    preference.nutritionPreference =
                        _selectedNutritionPreference;

                    nutritionService
                        .createUserNutritionPreference(preference)
                        .then((newPreference) {
                      setState(() {
                        _userNutritionPreference = newPreference;
                      });
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: _userNutritionPreference == null
            ? Text("定制私人营养计划",
                style: Typography.dense2018.title.merge(
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.white
                        //    color: Theme.of(context).primaryColor
                        )))
            : Text(
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                style: TextStyle(color: Colors.white),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _editing = true;
                _cacheNutritionPreference = _userNutritionPreference;
                _userNutritionPreference = null;
              });
            },
          )
        ],
      ),
      body: SafeArea(
          child: _userNutritionPreference == null
              ? userChosePreference()
              : userChosenPreference()),
      floatingActionButton: _userNutritionPreference == null
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_expandingPanel < 1) {
                  nutritionNonSelectedWarning();
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CameraCapture(
                            "nutrition/" +
                                DateFormat("yyyy-MM-dd").format(DateTime.now()),
                            (String uploadedFile) {
                          NutritionRecord matchingRecord =
                              todayRecords.elementAt(_expandingPanel - 1);
                          if (matchingRecord.materials == null) {
                            matchingRecord.materials = List();
                          }
                          matchingRecord.materials.add(uploadedFile);
                          nutritionService
                              .saveNutritionRecord(user.id, matchingRecord)
                              .then((nutritionRecord) {
                            setState(() {
                              todayRecords.replaceRange(_expandingPanel - 1,
                                  _expandingPanel, [nutritionRecord]);
                            });
                          });
                        })));
              },
              child: Icon(
                Icons.camera_enhance,
                color: Theme.of(context).primaryColor,
              ),
            ),
      bottomNavigationBar: BottomNaviBar(
        currentIndex: 2,
      ),
    );
  }

  Future<void> nutritionNonSelectedWarning() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "请展开对应的记录",
            style: Typography.dense2018.subtitle,
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
