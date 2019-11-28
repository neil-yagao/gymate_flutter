import 'package:flutter/material.dart';
import 'package:workout_helper/model/community.dart';

import 'comment_widget.dart';

class CommentList extends StatefulWidget {
  final List<Comment> comments;

  const CommentList({Key key, this.comments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CommentListState();
  }
}

class CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    if (widget.comments == null || widget.comments.isEmpty) {
      return Container(
        height: 120,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.inbox,
                size: 48,
                color: Colors.grey[400],

              ),
              Text(
                "空空如野",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 20),
              )
            ],
          ),
        ),
      );
    }
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ...widget.comments.map((comment) => UserComment(comment: comment))
      ],
    );
  }
}
