import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workout_helper/general/debouncer.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'component/movement_detail.dart';
import 'component/bottom_navigation_bar.dart';

class MovementListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovementListPageState();
  }
}

class MovementListPageState extends State<MovementListPage> {
  List<Movement> _movements = List();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Movement> _showingMovements = List();
  MovementService _movementService;

  MuscleGroup _selectedMuscleGroup;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movementService = MovementService(_scaffoldKey);
    _movementService.getMovements(null).then((movements) {
      setState(() {
        _movements = movements;
        _showingMovements = List();
        _showingMovements.addAll(movements);
        _showingMovements.sort((Movement m1, Movement m2) => m1.involvedMuscle
            .elementAt(0)
            .index
            .compareTo(m2.involvedMuscle.elementAt(0).index));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("训练动作"),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "查找训练动作",
                        suffixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      print('val:' + val);
                      if (val.isEmpty) {
                        setState(() {
                          _showingMovements = List();
                          _showingMovements.addAll(_movements);
                        });
                      } else {
                        _showingMovements = List();
                        _movements.forEach((m) {
                          if (m.name.indexOf(val) >= 0) {
                            _showingMovements.add(m);
                          }
                        });
                        Debouncer(milliseconds: 500).run(() {
                          setState(() {});
                        });
                      }
                    },
                  ),
                ),
                ..._showingMovements.map((Movement m) {
                  return ListTile(
                    leading: SizedBox(
                      child: Image.network(m.picReference),
                      width: 60,
                    ),
                    title: Text(m.name),
                    subtitle: getMovementInvolvedMuscle(m),
                    trailing: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Theme.of(context).primaryColor,
                        )),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => MovementDetail(movement: m,));
                    },
                  );
                })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ...MuscleGroup.values.map((muslce) => InkWell(
                          onTap: () async {
                            setState(() {
                              _showingMovements = List();
                              if (_selectedMuscleGroup != muslce) {
                                _selectedMuscleGroup = muslce;
                                _movements.forEach((m) {
                                  if (m.involvedMuscle.contains(muslce)) {
                                    _showingMovements.add(m);
                                  }
                                });
                              } else {
                                _selectedMuscleGroup = null;
                                _movements.forEach((m) {
                                  _showingMovements.add(m);
                                });
                              }
                            });
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                muscleGroupToChinese(muslce).substring(0, 2),
                                style: TextStyle(
                                    color: _selectedMuscleGroup == muslce
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700),
                              ))))
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
        bottomNavigationBar: BottomNaviBar(
          currentIndex: 1,
        ));
  }

  Widget getMovementInvolvedMuscle(Movement m) {
    String translate = "";
    m.involvedMuscle.forEach((MuscleGroup m) {
      translate += "," + muscleGroupToChinese(m);
    });
    return Text(
      "涉及肌群:" + translate.substring(1),
      style: Typography.dense2018.caption,
    );
  }
}
