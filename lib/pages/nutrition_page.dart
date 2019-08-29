import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'component/bottom_navigation_bar.dart';

class NutritionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NutritionPageState();
  }
}

class NutritionPageState extends State<NutritionPage> {
  int _expandingPanel = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Text(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                    Text("推荐摄入 "),
                    Text("1400"),
                    Text(" KCals"),
                  ],
                ),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "蛋白质：",
                          style: Typography.dense2018.subtitle,
                        )),
                        Expanded(
                          child: Text(
                            "120g",
                            style: Typography.dense2018.subtitle,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("碳水化合物：",
                                style: Typography.dense2018.subtitle)),
                        Expanded(
                          child: Text(
                            "120g",
                            style: Typography.dense2018.subtitle,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "脂肪：",
                          style: Typography.dense2018.subtitle,
                        )),
                        Expanded(
                          child: Text(
                            "120g",
                            style: Typography.dense2018.subtitle,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.photo_camera),
      ),
      bottomNavigationBar: BottomNaviBar(
        currentIndex: 1,
      ),
    );
  }
}
