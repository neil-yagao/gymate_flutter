import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';
import 'package:zefyr/zefyr.dart';

import 'ZefyrImageDelegate.dart';
import 'comment_list.dart';
import 'community_main.dart';
import 'quick_comment.dart';
import 'user_info_tile.dart';

class ViewPage extends StatefulWidget {
  final Post post;

  final Widget returnTo;

  const ViewPage({Key key, this.post, this.returnTo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ViewPageState();
  }

  static ViewPageState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedViewPage)
            as InheritedViewPage)
        .data;
  }
}

class ViewPageState extends State<ViewPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CommunityService communityService;
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  List<Comment> postComments;

  NotusDocument document;

  User user;

  ScrollController mainScrollController;

  String title = "";

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    document = _loadDocument();
    postComments = widget.post?.replies ?? List();
    postComments.forEach((c) => c.belongTo = widget.post);
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    mainScrollController = ScrollController();
    mainScrollController.addListener(() {
      if (this.mainScrollController.offset > 45 && title.isEmpty) {
        setState(() {
          title = widget.post.title.length > 15
              ? widget.post.title.substring(0, 12) + "..."
              : widget.post.title;
        });
      } else if (this.mainScrollController.offset <= 45 && title.isNotEmpty) {
        setState(() {
          title = '';
        });
      }
    });
  }

  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    if (widget.post != null) {
      var document = NotusDocument.fromJson(jsonDecode(widget.post.content));
      return document;
    }
    return NotusDocument();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = Provider.of<CurrentUserStore>(context).currentUser;
    communityService = CommunityService(scaffoldKey);
  }

  double calculateHeight() {
    double height = 0.0;

    (jsonDecode(widget.post.content) as List).forEach((o) {
      Map<String, dynamic> json = o as Map<String, dynamic>;
      if (json['attributes'] == null) {
        height += 20 * json['insert'].toString().split("\n").length + 1;
      } else {
        Map<String, dynamic> atrributes = json['attributes'];
        if (atrributes['heading'] != null) {
          height +=
              (20 + (4 - int.parse(atrributes['heading'].toString())) * 10);
        } else if (atrributes['embed'] != null) {
          //image
          height = height + 220;
        }
      }
    });
    double maxHeight = MediaQuery.of(context).size.height * 0.5;
    if (height > maxHeight) {
      return maxHeight;
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: DefaultAppBar.build(
        context,
        leading: InkWell(
          child:
              Icon(Icons.chevron_left, color: Theme.of(context).primaryColor),
          onTap: () {
            NavigationUtil.replaceUsingDefaultFadingTransition(
                context, widget.returnTo ?? CommunityMain());
          },
        ),
        title: title,
      ),
      body: ListView(
        controller: mainScrollController,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.post.title,
              style: Typography.dense2018.title,
            ),
          ),
          Divider(height: 4, thickness: 2),
          SizedBox(
            height: 4,
          ),
          UserInfoTile(
            postBy: widget.post.postBy,
            postAt: widget.post.postAt,
          ),
          Divider(height: 4, thickness: 2),
          SizedBox(
            height: 4,
          ),
          ZefyrScaffold(
              child: Container(
            height: calculateHeight(),
            child: ZefyrEditor(
              mode: ZefyrMode.view,
              padding: EdgeInsets.all(16),
              imageDelegate:
                  MyAppZefyrImageDelegate(null, user, widget.post, context),
              controller: _controller,
              focusNode: _focusNode,
            ),
          )),
          Container(
            height: 40,
            color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Text('全部回复'),
                )
              ],
            ),
          ),
          InheritedViewPage(
            data: this,
            child: CommentList(
              comments: postComments,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                QuickComment.showQuickReply(context, (content) {
                  Comment comment = Comment.empty();
                  comment.belongTo = widget.post;
                  comment.content = content;
                  comment.postBy = user;
                  communityService.postNewReply(comment).then((comment) {
                    if (comment != null) {
                      setState(() {
                        postComments.add(comment);
                      });
                      Navigator.of(context).pop();
                    }
                  });
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "写点你的见解吧。。。"),
            ),
          )),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    postComments.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            onTap: () {
              mainScrollController.animateTo(calculateHeight() + 10,
                  duration: Duration(milliseconds: 100), curve: Curves.linear);
            },
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.thumb_up,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    widget.post.recommendedCount.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            onTap: () {
              communityService
                  .recommend(widget.post.id, "post", user)
                  .then((_) {
                setState(() {
                  widget.post.recommendedCount =
                      widget.post.recommendedCount + 1;
                });
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("推荐成功"),
                  duration: Duration(seconds: 2),
                ));
              });
            },
          ),
        ],
      )),
    );
  }
}

class InheritedViewPage extends InheritedWidget {
  final ViewPageState data;

  InheritedViewPage({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
