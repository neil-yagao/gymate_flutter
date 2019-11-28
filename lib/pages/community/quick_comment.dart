import 'package:flutter/material.dart';
import 'package:workout_helper/model/community.dart';

class QuickComment extends StatelessWidget {
  final Function(String) onPublishClick;

  QuickComment({Key key, this.onPublishClick}) : super(key: key);

  TextEditingController _quickCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: true,
          controller: _quickCommentController,
          maxLines: 5,
          decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              hintText: '写点你的见解吧...'),
        ),
      ),
      Divider(
        height: 2,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text("取消"),
            textColor: Colors.amberAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("发表"),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              onPublishClick(_quickCommentController.text);
            },
          )
        ],
      )
    ]);
  }


  static void showQuickReply(BuildContext context, onPublicClick) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Card(
                  child: AnimatedContainer(
                      height: 200,
                      margin: EdgeInsets.only(bottom: 100),
                      duration: const Duration(milliseconds: 300),
                      child: QuickComment(
                        onPublishClick: onPublicClick,
                      ))));
        });
  }

}
