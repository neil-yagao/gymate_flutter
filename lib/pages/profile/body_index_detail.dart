import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/profile/skin_clip_calculator.dart';

class BodyIndexDetail extends StatefulWidget {

  final Function(UserBodyIndex index) appendIndex;

  const BodyIndexDetail({Key key, @required this.appendIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BodyIndexDetailState(appendIndex);
  }
}

enum _IndexInputScreen { INDEX, NUMBER }

class BodyIndexDetailState extends State<BodyIndexDetail> {
  final Function(UserBodyIndex index) appendIndex;

  BodyIndex _selectedBodyIndex;

  bool _usingSkinClips = false;

  _IndexInputScreen screen = _IndexInputScreen.INDEX;

  Map<BodyIndex, BodyIndexSpecification> bodyIndexMap = {};

  List<BodyIndexSpecification> specification = List();
  TextEditingController _detailInputController = TextEditingController();

  BodyIndexDetailState(this.appendIndex);

  @override
  void initState() {
    super.initState();
    bodyIndexMap = mapBodyIndexInfo();
    specification = bodyIndexMap.values.toList();
    _selectedBodyIndex = specification
        .elementAt(0)
        .index;
  }



  Widget buildDetailInput() {
    if (_selectedBodyIndex == null) {
      return TextField();
    }
    if (_selectedBodyIndex == BodyIndex.BODY_FAT) {
      return Column(
        children: buildBodyFat(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _detailInputController,
        textAlign: TextAlign.center,
        autofocus: true,
        decoration: InputDecoration(
            isDense: false,
            suffixText: bodyIndexMap[_selectedBodyIndex].unit,
            labelText: bodyIndexMap[_selectedBodyIndex].name,
            hintText: bodyIndexMap[_selectedBodyIndex].name),
      ),
    );
  }

  List<Widget> buildBodyFat() {
    List<Widget> basic = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _detailInputController,
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: InputDecoration(
                    enabled: !_usingSkinClips,
                    suffixText: bodyIndexMap[_selectedBodyIndex].unit,
                    labelText: bodyIndexMap[_selectedBodyIndex].name,
                    hintText: bodyIndexMap[_selectedBodyIndex].name),
              ),
            ),
            Expanded(
              flex: 2,
              child: SwitchListTile(
                dense: true,
                title: const Text('使用体脂夹计算'),
                value: _usingSkinClips,
                onChanged: (bool value) {
                  setState(() {
                    _usingSkinClips = value;
                  });
                },
              ),
            ),
          ],
        ),
      )
    ];
    if (_usingSkinClips) {
      basic.add(Divider());
      basic.add(SkinClipCalculator(bodyFatController: _detailInputController,));
    }
    return basic;
  }

  Widget cancelButton, nextButton, completedButton, indexPicker, detailInput;

  @override
  Widget build(BuildContext context) {
    cancelButton = Expanded(
      child: FlatButton(
        color: Colors.transparent,
        textColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).maybePop();
        },
        child: Text("取消"),
      ),
    );
    nextButton = Expanded(
      child: FlatButton(
        color: Colors.transparent,
        textColor: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          setState(() {
            screen = _IndexInputScreen.NUMBER;
          });
        },
        child: Text("下一步"),
      ),
    );
    completedButton = Expanded(
      child: FlatButton(
        color: Colors.transparent,
        textColor: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          UserBodyIndex index = UserBodyIndex(
              _selectedBodyIndex, double.parse(_detailInputController.text),
              bodyIndexMap[_selectedBodyIndex].unit, DateTime.now());
          this.appendIndex(index);
        },
        child: Text("添加"),
      ),
    );
    indexPicker = CupertinoPicker(
      backgroundColor: Colors.transparent,
      children: specification.map((BodyIndexSpecification bis) {
        return Text(
          bis.name,
          style: Typography.dense2018.subhead,
        );
      }).toList(),
      itemExtent: 32,
      onSelectedItemChanged: (int value) {
        setState(() {
          _selectedBodyIndex = specification
              .elementAt(value)
              .index;
        });
      },
    );
    return SizedBox(
      height: _selectedBodyIndex == BodyIndex.BODY_FAT && _usingSkinClips
          ? 400
          : 220,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: screen == _IndexInputScreen.INDEX
                    ? indexPicker
                    : buildDetailInput()),
            Row(
              children: <Widget>[
                cancelButton,
                screen == _IndexInputScreen.INDEX ? nextButton : completedButton
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/**
 */
