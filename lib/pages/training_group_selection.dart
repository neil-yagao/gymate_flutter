import 'package:flutter/material.dart';

class TrainingGroupSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TrainingGroupSelectionState();
  }
}

class TrainingGroupSelectionState extends State<TrainingGroupSelection> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("我的训练组"),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("组名"),
            subtitle: Text("共计：" + "人"),
            trailing: Icon(Icons.chevron_right),
          )
        ],
      )),
    );
  }
}
