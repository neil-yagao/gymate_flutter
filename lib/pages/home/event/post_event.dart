import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/community/view_page.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'event_self_mixin.dart';

class PostEvent extends StatefulWidget {

  final UserEvent userEvent;

  const PostEvent({Key key, this.userEvent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PostEventState();
  }
}

class PostEventState extends State<PostEvent> with SelfEvent {

  @override
  Widget build(BuildContext context) {
    Post post = widget.userEvent.relatedRecord as Post;
    if (post == null) {
      return Container();
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(isSelf(context, widget.userEvent) ? "我" : widget.userEvent.user
              .name),
          Text("发了一个新帖："),
          InkWell(
            child: Text(post.title, style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColor,
                fontStyle: FontStyle.italic)
                .merge(Typography.dense2018.subhead),),
            onTap: () {
              NavigationUtil.pushUsingDefaultFadingTransition(
                  context, ViewPage(post: post));
            },
          )
        ],
      ),
      subtitle: Text(DateFormat('yyyy-MM-dd hh:mm').format(post.postAt.add(Duration(hours: 8)))),
      trailing: Text("+" + widget.userEvent.extraScore.round().toString(),
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontStyle: FontStyle.italic)
              .merge(Typography.dense2018.subhead)),
    );
  }
}
