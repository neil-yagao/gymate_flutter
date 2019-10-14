import 'package:flutter/material.dart';
import 'package:workout_helper/general/debouncer.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'component/bottom_navigation_bar.dart';
import 'component/movement_detail.dart';

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

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.localPosition}');
    final RenderBox box = context.findRenderObject();
    print('width:${box.size.width}');
    final Offset localOffset = details.localPosition;
    var resizeRate = box.size.width / 597.0;
    var originX = localOffset.dx / resizeRate;
    var originY = localOffset.dy / resizeRate;
    MuscleGroup muscleGroup = determineWhichMuscle(originX, originY);
    print('point(${originX},${originY})');
    print('selected muscle group:${muscleGroup}');
    if (muscleGroup != null) {
      setState(() {
        _selectedMuscleGroup = muscleGroup;
        filterShowingMovementBasedOnSelectedMuscleGroup();
      });
      Navigator.of(context).maybePop();
    }
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
//                    trailing: Padding(
//                        padding: EdgeInsets.only(right: 20),
//                        child: Icon(
//                          Icons.play_circle_outline,
//                          color: Theme.of(context).primaryColor,
//                        )),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => MovementDetail(
                                movement: m,
                              ));
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
                      InkWell(
                        child: Icon(Icons.person_pin_circle),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Card(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.grey),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .maybePop();
                                                    })
                                              ],
                                            ),
                                            GestureDetector(
                                                onTapDown: (TapDownDetails
                                                        details) =>
                                                    onTapDown(context, details),
                                                child: Image.asset(
                                                    "assets/body_image.png")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                      ),
                      ...MuscleGroup.values.map((muslce) => InkWell(
                          onTap: () async {
                            setState(() {
                              _showingMovements = List();
                              if (_selectedMuscleGroup != muslce) {
                                _selectedMuscleGroup = muslce;
                              } else {
                                _selectedMuscleGroup = null;
                              }
                              filterShowingMovementBasedOnSelectedMuscleGroup();
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

  void filterShowingMovementBasedOnSelectedMuscleGroup() {
    _showingMovements = List();
    _movements.forEach((m) {
      if (_selectedMuscleGroup == null ||
          m.involvedMuscle.contains(_selectedMuscleGroup)) {
        _showingMovements.add(m);
      }
    });
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

  MuscleGroup determineWhichMuscle(double originX, double originY) {
    ///shoulder
    if(((originX >= 153 && originX <= 213) || (originX>= 380 && originX<=448)) &&
        ((originY >= 231 && originY <= 293) || (originY>= 1217 && originY<=1271))
    ){
      return MuscleGroup.SHOULDER;
    }
    ///chest
    if(originX >= 220 && originX <=368 && originY >= 262 && originY <= 313){
      return MuscleGroup.CHEST;
    }
    ///abs
    if(originX >= 243 && originX <= 335 && originY >= 335 && originY <= 480){
      return MuscleGroup.ABS;
    }
    ///bicep
    if(((originX >= 140 && originX <= 195) || (originX>= 385 && originX<=437)) &&
        (originY >= 312 && originY <= 380)
    ){
      return MuscleGroup.BICEPS;
    }
    ///quads
    if(originX >= 179 && originX <=403 && originY >= 531 && originY <= 677){
      return MuscleGroup.QUADS;
    }
    ///calfs
    if(((originY >= 760 && originY <= 900) || (originY>= 1781 && originY<= 1875)) &&
        (originX >= 175 && originX <= 420)
    ){
      return MuscleGroup.CALVES;
    }
    ///lat
    if(((originX >= 208 && originX <= 269) || (originX>= 341 && originX<=384)) &&
        (originY >= 1316 && originY <= 1390)
    ){
      return MuscleGroup.LATS;
    }
    ///Triceps
    if(((originX >= 152 && originX <= 190) || (originX>= 396 && originX<=450)) &&
        (originY >= 1297 && originY <= 1378)
    ){
      return MuscleGroup.TRICEPS;
    }
    ///MIDDLE_BACK
    if(originX >= 238 && originX <= 335 &&
        originY >= 1214 && originY <= 1308
    ){
      return MuscleGroup.MIDDLE_BACK;
    }
    ///lower back
    if(originX >= 267 && originX <= 335 &&
        originY >= 1384 && originY <= 1457
    ){
      return MuscleGroup.LOWER_BACK;
    }
    ///gluten
    if(originX >= 227 && originX <= 404 &&
        originY >= 1479 && originY <= 1577
    ){
      return MuscleGroup.GLUTES;
    }
    ///HAMStirng
    if(originX >= 191 && originX <= 409 &&
        originY >= 1599 && originY <= 1733
    ){
      return MuscleGroup.HAMSTRING;
    }
    return null;
  }
}
