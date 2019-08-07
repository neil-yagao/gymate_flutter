import 'package:flutter/material.dart';

enum SessionOption {
  EDITING,
  SAVE_TEMPLATE,
  SHARE_TEMPLATE,
}

Map<SessionOption, String> actionMenu = {
  SessionOption.EDITING: "编辑训练",
  SessionOption.SAVE_TEMPLATE: "保存模板",
  SessionOption.SHARE_TEMPLATE: "分享模板",
};

Map<SessionOption, Icon> actionIconMap = {
  SessionOption.EDITING: Icon(Icons.mode_edit),
  SessionOption.SAVE_TEMPLATE: Icon(Icons.save_alt),
  SessionOption.SHARE_TEMPLATE: Icon(Icons.share),
};

class SessionActionMenu extends StatelessWidget {
  final Function(SessionOption option) onSelected;

  const SessionActionMenu({Key key, @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PopupMenuButton<SessionOption>(
        offset: Offset(0, 20),
        icon: Icon(Icons.menu),
        onSelected: (SessionOption option) {
          this.onSelected(option);
        },
        itemBuilder: (BuildContext context) =>
            SessionOption.values.map((SessionOption option) {
              return PopupMenuItem<SessionOption>(
                  value: option,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: actionIconMap[option],
                      ),
                      Expanded(
                        child: Text(actionMenu[option]),
                      )
                    ],
                  ));
            }).toList());
  }
}
