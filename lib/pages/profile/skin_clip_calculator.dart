import 'package:flutter/material.dart';

import 'package:workout_helper/pages/general/label_radio.dart';

class SkinClipCalculator extends StatefulWidget {
  final TextEditingController bodyFatController;

  const SkinClipCalculator({Key key, @required this.bodyFatController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SkinClipCalculatorState(bodyFatController);
  }
}

class SkinClipCalculatorState extends State<SkinClipCalculator> {
  int _gender = 1;

  final TextEditingController bodyFatController;

  double _age, _triceps, _thigh, _suprailiac, _abdomen;

  SkinClipCalculatorState(this.bodyFatController);

  void doCalculateIfPossible() {
    if (_age != null &&
        _triceps != null &&
        _thigh != null &&
        _suprailiac != null &&
        _abdomen != null) {
      double sum = _triceps + _thigh + _suprailiac + _abdomen;
      if (_gender == 1) {
        //female
        bodyFatController.text =
            (sum * 0.29669 - (sum * sum * 0.00043) + _age * 0.02963 + 1.4072)
                .toString().substring(0,5);
      } else {
        //male
        bodyFatController.text =
            (sum * 0.29228 - (sum * sum * 0.0005) + _age * 0.15845 - 5.76377)
                .toString().substring(0,5);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: LabeledRadio(
                value: 1,
                padding: EdgeInsets.all(8),
                label: Text("女"),
                groupValue: _gender,
                onChanged: (int value) {
                  setState(
                    () {
                      _gender = value;
                      doCalculateIfPossible();
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
                        doCalculateIfPossible();
                      },
                    );
                  })),
          Expanded(
            child: ListTile(
              dense: true,
              title: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    isDense: true, labelText: "年龄", suffixText: "岁"),
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (String value) {
                  setState(() {
                    _age = double.parse(value);
                    doCalculateIfPossible();
                  });
                },
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
              leading: Text("大臂"),
              title: TextField(
                textAlign: TextAlign.center,

                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(isDense: true),
                onChanged: (String value) {
                  setState(() {
                    _triceps = double.parse(value);
                    doCalculateIfPossible();
                  });
                },
              ),
              trailing: Tooltip(
                message: "保持手臂放松，手肘与肩部连线中间部位，垂直捏起",
                showDuration: Duration(minutes: 1),
                child: Icon(Icons.help_outline),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              dense: true,
              leading: Text("大腿"),
              title: TextField(
                textAlign: TextAlign.center,

                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(isDense: true),
                onChanged: (String value) {
                  setState(() {
                    _thigh = double.parse(value);
                    doCalculateIfPossible();
                  });
                },
              ),
              trailing: Tooltip(
                message: "保持大腿放松，膝盖正上方大腿半程出，垂直捏起",
                showDuration: Duration(minutes: 1),
                child: Icon(Icons.help_outline),
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
              leading: Text("侧腹"),
              title: TextField(
                textAlign: TextAlign.center,

                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(isDense: true),
                onChanged: (String value) {
                  setState(() {
                    _suprailiac = double.parse(value);
                    doCalculateIfPossible();
                  });
                },
              ),
              trailing: Tooltip(
                message: "腹部放松，侧腹肚脐平行位置，对角线方向捏起",
                showDuration: Duration(minutes: 1),
                child: Icon(Icons.help_outline),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              dense: true,
              leading: Text("腹部"),
              title: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(isDense: true),
                onChanged: (String value) {
                  setState(() {
                    _abdomen = double.parse(value);
                    doCalculateIfPossible();
                  });
                },
              ),
              trailing: Tooltip(
                message: "腹部放松，肚脐任一一侧两厘米，水平捏起",
                showDuration: Duration(minutes: 1),
                child: Icon(Icons.help_outline),
              ),
            ),
          ),
        ],
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "备注:",
              style: Typography.dense2018.subhead,
            ),
            Text(
              "每个部位测量两次，若误差大于2mm则需重新测量",
              style: Typography.dense2018.caption,
            ),
          ],
        ),
      )
    ]);
  }
}
