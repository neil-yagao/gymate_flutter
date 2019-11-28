import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/community/user_info_tile.dart';
import 'package:workout_helper/pages/community/view_page.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';

import 'quick_comment.dart';

class UserComment extends StatefulWidget {
  final Comment comment;

  UserComment({Key key, this.comment}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserCommentState();
  }
}

class UserCommentState extends State<UserComment> {
  CommunityService _communityService;

  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _communityService = CommunityService(ViewPage.of(context).scaffoldKey);
    _user = Provider.of<CurrentUserStore>(context).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CommunityService service =
        CommunityService(ViewPage.of(context).scaffoldKey);
    Container comment = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserInfoTile(
            postAt: widget.comment.postAt,
            postBy: widget.comment.postBy,
          ),
          widget.comment.replyTo == null
              ? Container()
              : Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 28, bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: Colors.grey[300],
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Text(widget.comment.replyTo.content.length > 20
                            ? widget.comment.replyTo.content.substring(0, 20) +
                                "..."
                            : widget.comment.replyTo.content),
                      ),
                    ),
                  ],
                ),
          Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 8, bottom: 10),
                child: Text(widget.comment.content),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      service
                          .recommend(
                              widget.comment.id,
                              "comment",
                              Provider.of<CurrentUserStore>(context)
                                  .currentUser)
                          .then(((_) {
                        ViewPage.of(context)
                            .scaffoldKey
                            .currentState
                            .showSnackBar(SnackBar(content: Text("推荐成功")));
                      }));
                    },
                    textColor: Colors.grey,
                    icon: Icon(
                      Icons.thumb_up,
                    ),
                    label: Text("推荐(" +
                        (widget.comment.recommendedCount ?? 0).toString() +
                        ")")),
                widget.comment.replies != null &&
                        widget.comment.replies.isNotEmpty
                    ? FlatButton.icon(
                        textColor: Colors.grey,
                        onPressed: () {},
                        color: Colors.grey,
                        icon: Icon(Icons.comment),
                        label: Text("见解(" +
                            (widget.comment.recommendedCount ?? 0).toString() +
                            ")"))
                    : Container(),
                FlatButton.icon(
                    textColor: Colors.grey,
                    onPressed: () {
                      QuickComment.showQuickReply(context, (content) {
                        Comment comment = Comment.empty();
                        comment.belongTo = widget.comment.belongTo;
                        comment.content = content;
                        comment.postBy = _user;
                        comment.replyTo = widget.comment;
                        _communityService.postNewReply(comment);
                      });
                    },
                    icon: Icon(Icons.reply),
                    label: Text("回复")),
              ],
            ),
          ),
          Divider(
            indent: 10,
            height: 3,
            thickness: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
    return comment;
  }
}
