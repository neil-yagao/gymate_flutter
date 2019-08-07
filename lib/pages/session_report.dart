import 'dart:collection';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

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
  1: 100,
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

  const SessionReport({Key key, this.completedSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LinkedHashMap<Movement, List<CompletedExerciseSet>> maps =
    groupCompletedExerciseSetViaMovement(completedSession.accomplishedSets);
    List<Widget> listViewChildren = List();
    maps.forEach((Movement m, List<CompletedExerciseSet> ces) {
      List<charts.Series<CompletedExerciseSet, String>> series = [
        buildLine(m, ces),
        buildBar(m, ces)
      ];
      listViewChildren.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            child: charts.OrdinalComboChart(series,
                animate: true,
                defaultRenderer: new charts.LineRendererConfig(),
                behaviors: [new charts.SeriesLegend()],
                customSeriesRenderers: [
                  new charts.BarRendererConfig(
                      customRendererId: 'customBar')
                ])
        ),
      ));
    });
    return Scaffold(
        appBar: AppBar(title: Text("本次运动报告"),
        actions: <Widget>[IconButton(icon: Icon(Icons.share),onPressed: (){},)],),
        body: ListView(
          children: listViewChildren,
        )
        ,bottomNavigationBar: ButtonBar(children: <Widget>[
          RaisedButton(
            child: Text("确定"),
            textColor: Colors.white,
            color:Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.of(context).popAndPushNamed('/home');
            },
          )
    ],),
    );
  }

  double repeatsToPercentage(int repeat) {
    if (OneRepMaxMap.containsKey(repeat)) {
      return OneRepMaxMap[repeat];
    } else {
      return 0.75 - (repeat - 10) * 0.025;
    }
  }

  charts.Series<CompletedExerciseSet, String> buildLine(Movement movement,
      List<CompletedExerciseSet> completedSets,) {
    return charts.Series<CompletedExerciseSet, String>(
        id: movement.name + '的1RM',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (CompletedExerciseSet ces, _) =>
        '第' + (ces.accomplishedSet.sequence + 1).toString() + '组',
        measureFn: (CompletedExerciseSet ces, _) =>
        ces.weight / repeatsToPercentage(ces.repeats),
        data: completedSets,
        labelAccessorFn: (CompletedExerciseSet ces,_) => '最大力量' +
            (ces.weight / repeatsToPercentage(ces.repeats)).toString() + 'KG'
    );
  }

  charts.Series<CompletedExerciseSet, String> buildBar(Movement movement,
      List<CompletedExerciseSet> completedSets,) {
    return charts.Series<CompletedExerciseSet, String>(
      id: movement.name + '的训练容量',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (CompletedExerciseSet ces, _) =>
      '第' + (ces.accomplishedSet.sequence + 1).toString() + '组',
      measureFn: (CompletedExerciseSet ces, _) => ces.weight * ces.repeats,
      data: completedSets,
        labelAccessorFn: (CompletedExerciseSet ces,_) => '训练体量' +
            ( ces.weight * ces.repeats).toString() + 'KG'
    )
      ..setAttribute(charts.rendererIdKey, 'customBar');
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
      } else {
        //giant set
        GiantSet gs = es.accomplishedSet;
        if (!maps.containsKey(gs.extractMovementBasicInfo())) {
          maps.putIfAbsent(gs.extractMovementBasicInfo(), () {
            return [];
          });
        }
        maps[gs.extractMovementBasicInfo()].add(es);
      }
    });
    return maps;
  }
}
