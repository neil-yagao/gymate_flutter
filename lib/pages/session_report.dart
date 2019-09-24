import 'dart:collection';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

import 'component/session_materials_grid.dart';

///session report should include training volume based on each movement
///one rep max
///one rep max is line and volume is bar
///1 - 100
///2 - 95
///3 - 93
///4 - 90
///5 - 87
///6 - 85
///7 - 83
///8 - 80
///9 - 77
///10 - 75
///11 - 73
///12 - 70
///16 - 60
///20 - 50
/// roughly 2.5% each after 12

const Map<int, double> OneRepMaxMap = {
  1: 1,
  2: 0.95,
  3: 0.93,
  4: 0.90,
  5: 0.87,
  6: 0.85,
  7: 0.83,
  8: 0.80,
  9: 0.77,
  10: 0.75,
};

class SessionReport extends StatelessWidget {
  final Session completedSession;
  final bool canGoBack;

  const SessionReport(
      {Key key, @required this.completedSession, this.canGoBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LinkedHashMap<Movement, List<CompletedExerciseSet>> maps =
        groupCompletedExerciseSetViaMovement(completedSession.accomplishedSets);
    List<Widget> listViewChildren = List();
    double cardioTotalCals = 0.0;
    maps.forEach((Movement m, List<CompletedExerciseSet> ces) {
      if (m.exerciseType == ExerciseType.hiit) {
        ces.forEach((CompletedExerciseSet c) {
          cardioTotalCals += c.repeats * 20 / 60;
        });
        return;
      } else if (m.exerciseType == ExerciseType.cardio) {
        ces.forEach((CompletedExerciseSet c) {
          cardioTotalCals += (c.accomplishedSet as CardioSet).exerciseCals;
        });
        return;
      }

      List<charts.Series<CompletedExerciseSet, String>> series = [
        buildBar(m, ces)
      ];
      listViewChildren.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              m.name,
              style: Typography.dense2018.headline,
            )
          ],
        ),
      ));
      listViewChildren.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: charts.BarChart(
              series,
              animate: true,
              behaviors: [charts.SeriesLegend()],
              defaultRenderer: charts.BarRendererConfig(),
            )),
      ));
      listViewChildren.add(Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '总容量:' +
                    ces
                        .map((CompletedExerciseSet ces) {
                          return ces.weight * ces.repeats;
                        })
                        .reduce((a, b) {
                          return a + b;
                        })
                        .ceil()
                        .toString() +
                    "KG",
                style: Typography.dense2018.subtitle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "1RM:" +
                    ces
                        .map((CompletedExerciseSet ces) {
                          return (ces.weight /
                              repeatsToPercentage(ces.repeats));
                        })
                        .reduce((a, b) {
                          if (a > b) {
                            return a;
                          }
                          return b;
                        })
                        .ceil()
                        .toString() +
                    "KG",
                style: Typography.dense2018.subtitle,
              ),
            ),
          )
        ],
      ));
    });
    listViewChildren.add(Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "直接卡路里消耗(来自有氧或hiit)约：" +
                cardioTotalCals.floor().toString() +
                "kClas",
            style: Typography.dense2018.subtitle,
          ),
        )
      ],
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text("本次运动报告"),
        automaticallyImplyLeading: canGoBack == null ? false : canGoBack,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: listViewChildren,
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text("训练集锦"),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SessionMaterialsGrid(
                        sessionId: completedSession.id,
                      )));
            },
          ),
          FlatButton(
            child: Text("返回首页"),
            textColor: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/home');
            },
          )
        ],
      ),
    );
  }

  double repeatsToPercentage(int repeat) {
    if (OneRepMaxMap.containsKey(repeat)) {
      return OneRepMaxMap[repeat];
    } else {
      return 0.75 - (repeat - 10) * 0.025;
    }
  }

  charts.Series<CompletedExerciseSet, String> buildBar(
    Movement movement,
    List<CompletedExerciseSet> completedSets,
  ) {
    completedSets.sort((a,b){
      return a.completedTime.compareTo(b.completedTime);
    });
    int sequence = 0;
    completedSets.forEach((c)=>c.accomplishedSet.sequence = sequence++);
    return charts.Series<CompletedExerciseSet, String>(
        id: '训练容量',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CompletedExerciseSet ces, _) =>
            '第' + (ces.accomplishedSet.sequence + 1).toString() + '组',
        measureFn: (CompletedExerciseSet ces, _) => ces.weight * ces.repeats,
        data: completedSets,
        labelAccessorFn: (CompletedExerciseSet ces, _) =>
            '训练体量' + (ces.weight * ces.repeats).toString() + 'KG');
  }

  LinkedHashMap<Movement, List<CompletedExerciseSet>>
      groupCompletedExerciseSetViaMovement(List<CompletedExerciseSet> sets) {
    LinkedHashMap<Movement, List<CompletedExerciseSet>> maps = LinkedHashMap();
    sets.forEach((CompletedExerciseSet es) {
      if (es.accomplishedSet is SingleMovementSet) {
        if (!maps
            .containsKey((es.accomplishedSet as SingleMovementSet).movement)) {
          maps.putIfAbsent((es.accomplishedSet as SingleMovementSet).movement,
              () {
            return [];
          });
        }
        maps[(es.accomplishedSet as SingleMovementSet).movement].add(es);
      } else if (es.accomplishedSet is GiantSet) {
        //giant set
        GiantSet gs = es.accomplishedSet;
        if (!maps.containsKey(gs.extractMovementBasicInfo())) {
          maps.putIfAbsent(gs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[gs.extractMovementBasicInfo()].add(es);
      } else if (es.accomplishedSet is HIITSet) {
        HIITSet hs = es.accomplishedSet as HIITSet;
        if (!maps.containsKey(hs.extractMovementBasicInfo())) {
          maps[hs.extractMovementBasicInfo()] = [];
        }
        maps[hs.extractMovementBasicInfo()].add(es);
      } else if (es.accomplishedSet is CardioSet) {
        CardioSet hs = es.accomplishedSet as CardioSet;
        Movement temp = Movement(hs.movementName, hs.movementName, '', '', '',
            ExerciseType.cardio, [], 0);
        if (!maps.containsKey(temp)) {
          maps[temp] = [];
        }
        maps[temp].add(es);
      }
    });
    return maps;
  }
}
