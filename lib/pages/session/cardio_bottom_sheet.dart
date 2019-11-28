import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/my_flutter_app_icons.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/profile_service.dart';

class CardioBottomSheet extends StatefulWidget {
  final Function(ExerciseSet) logExercise;

  const CardioBottomSheet({Key key, this.logExercise}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CardioBottomSheetState(logExercise);
  }
}

Map<String, String> metMap = {
  'sedentary': '1.0-1.5',
  'light-intensity': '1.6-2.9',
  'moderate-intensity': '3-5.9',
  'vigorous-intensity': '>=6'
};

/// kilocalories = MET * weight in kilograms * duration in hour
///
/// MET estimate
/// (walking speed in km/h / 1.6 - 2)*1.2  + 1.5 (speed < 5 km/h)
/// running 1.1 * speed in km/h
/// cycling 6.8 + (speed in km/h - 16)  * 0.8
/// swimming 8.3
/// rowing 6.0 + (speed in km/h - 10)
///
/// reference:
/// https://pdfs.semanticscholar.org/1ab1/cfd35edf7ad3af95092eea996184a27a925e.pdf
/// https://download.lww.com/wolterskluwer_vitalstream_com/PermaLink/MSS/A/MSS_43_8_2011_06_13_AINSWORTH_202093_SDC1.pdf

class CardioBottomSheetState extends State<CardioBottomSheet> {
  CardioSet _cs = CardioSet.empty();

  ProfileService _profileService = ProfileService(null);

  TextEditingController _distance = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController walkingSteps = TextEditingController();

  UserBodyIndex bodyWeightIndex;

  final Function(ExerciseSet) logExercise;

  CardioBottomSheetState(this.logExercise);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileService
        .loadUserIndexes(
            Provider.of<CurrentUserStore>(context).currentUser.id.toString())
        .then((List<UserBodyIndex> userBodyIndexes) {
      bodyWeightIndex = userBodyIndexes.firstWhere(
          (UserBodyIndex index) => index.bodyIndex == BodyIndex.WEIGHT,
          orElse: () => UserBodyIndex.empty());
      setState(() {
        if (bodyWeightIndex.unit != null) {
          _weight.text = bodyWeightIndex.value.toString();
        } else {
          _weight.text = '60';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_cs.movement == null){
      _cs.movement = CardioType.walking;
      _cs.movementName = "走路";
    }
    return Center(
        child: Card(
            child: AnimatedContainer(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 300),
                child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shrinkWrap: true,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "有氧训练",
                            style: Typography.dense2018.headline,
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              color: _cs.movement == CardioType.walking
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Icon(
                                CustomIcon.directions_walk,
                                color: _cs.movement == CardioType.walking
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cs.movementName = '步行';
                                  _cs.movement = CardioType.walking;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              color: _cs.movement == CardioType.running
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Icon(
                                CustomIcon.directions_run,
                                color: _cs.movement == CardioType.running
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cs.movementName = '跑步';
                                  _cs.movement = CardioType.running;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              color: _cs.movement == CardioType.cycle
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Icon(
                                CustomIcon.directions_bike,
                                color: _cs.movement == CardioType.cycle
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cs.movementName = '骑行';
                                  _cs.movement = CardioType.cycle;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              color: _cs.movement == CardioType.swimming
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Icon(
                                CustomIcon.swimming,
                                color: _cs.movement == CardioType.swimming
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cs.movementName = '游泳';
                                  _cs.movement = CardioType.swimming;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              color: _cs.movement == CardioType.rowing
                                  ? Colors.amber
                                  : Colors.transparent,
                              child: Icon(
                                CustomIcon.rowing,
                                color: _cs.movement == CardioType.rowing
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cs.movementName = '划船';
                                  _cs.movement = CardioType.rowing;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _cs.movement != CardioType.walking
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _distance,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: "距离",
                                          suffixText: "KM"),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _time,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: "时间",
                                          suffixText: "分钟"),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _weight,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: "体重",
                                          suffixText: "KG"),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 8),
                              child: TextField(
                                controller: walkingSteps,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "输入步数",
                                    prefixIcon: Icon(
                                      CustomIcon.directions_walk,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    suffixText: "步"),
                              ),
                            ),
                      Divider(),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              onPressed: () {
                                if (_cs.movement == CardioType.walking) {
                                  CardioSet cardioSet = CardioSet.empty();
                                  cardioSet.movement = CardioType.walking;
                                  cardioSet.movementName = "走路";
                                  cardioSet.exerciseCals =
                                      double.parse(walkingSteps.text) /
                                          60 /
                                          6 *
                                          6;
                                  cardioSet.exerciseDistance =
                                      double.parse(walkingSteps.text);
                                  cardioSet.exerciseTime = 0;
                                  Navigator.of(context).maybePop().then((_) {
                                    this.logExercise(cardioSet);
                                  });
                                  return;
                                }
                                double speedPerHour =
                                    double.parse(_distance.text) /
                                        double.parse(_time.text) *
                                        60;
                                double weightTime = double.parse(_weight.text) *
                                    double.parse(_time.text) /
                                    60;

                                /// kilocalories = MET * weight in kilograms * duration in hour
                                ///
                                /// MET estimate
                                /// (walking speed in km/h / 1.6 - 2)*1.2  + 1.5 (speed < 5 km/h)
                                /// running 1.1 * speed in km/h
                                /// cycling 6.8 + (speed in km/h - 16)  * 0.8
                                /// swimming 8.3
                                /// rowing 6.0 + (speed in km/h - 10)
                                double estimateCals = 0;
                                switch (_cs.movement) {
                                  case CardioType.running:
                                    estimateCals =
                                        speedPerHour * 1.1 * weightTime;
                                    break;
                                  case CardioType.cycle:
                                    estimateCals =
                                        ((speedPerHour - 16) * 0.8 + 6.8) *
                                            weightTime;
                                    break;
                                  case CardioType.swimming:
                                    estimateCals = 8.3 * weightTime;
                                    break;
                                  case CardioType.rowing:
                                    estimateCals =
                                        (4.3 + speedPerHour - 8) * weightTime;
                                    break;
                                  case CardioType.walking:

                                    /// already handled
                                    break;
                                }
                                _cs.exerciseTime = int.parse(_time.text);
                                _cs.exerciseDistance =
                                    double.parse(_distance.text);
                                _cs.exerciseCals = estimateCals;
                                Navigator.of(context).maybePop().then((_) {
                                  this.logExercise(_cs);
                                });
                              },
                              child: Text("记录运动")))
                    ]))));
  }
}
