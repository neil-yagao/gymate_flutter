import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/pages/community/view_page.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';
import 'package:zefyr/zefyr.dart';

import 'ZefyrImageDelegate.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;
  TextEditingController _titleController = TextEditingController();
  AliCloudOSS _aliCloudOSS;
  User user;
  Post _currentPost = Post.empty();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  CommunityService communityService;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _aliCloudOSS = AliCloudOSS();
    _currentPost.relatedPics = List();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<CurrentUserStore>(context).currentUser;
    communityService = CommunityService(_key);
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      key: _key,
      resizeToAvoidBottomPadding: true,
      appBar: DefaultAppBar.build(
        context,
        title: "新的话题",
        actions: <Widget>[
          FlatButton(
            child: Text(
              "发布",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 17),
            ),
            onPressed: () {
              _currentPost.title = _titleController.text;
              _currentPost.content = json.encode(_controller.document.toJson());
              _currentPost.postAt = DateTime.now();
              _currentPost.postBy = user;
              communityService.postNewPost(_currentPost).then((p) {
                goViewPage(p);
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(isDense: true, hintText: "取一个友善的标题吧"),
            ),
          ),

          ZefyrScaffold(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: ZefyrField(
              height: MediaQuery.of(context).size.height * 0.3,
              physics: ClampingScrollPhysics(),
              controller: _controller,
              focusNode: _focusNode,
              toolbarDelegate: MyEditorToolBarDelegator(),
              imageDelegate: MyAppZefyrImageDelegate(
                  _aliCloudOSS, user, _currentPost, context),
            ),
          )),
          Divider(),
//              if(widget.post != null && widget.post.replies != null)
//                ...widget.post.replies.map((r){
//                return ListTile(
//                  title: Text(r.title),
//                );
//              })
        ],
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
//    if (widget.post != null) {
//      return NotusDocument.fromJson(jsonDecode(widget.post.content));
//    }
    return NotusDocument();
  }

  void goViewPage(Post p) {
    NavigationUtil.replaceUsingDefaultFadingTransition(
        context,
        ViewPage(
          post: p,
        ));
  }
}

class MyEditorToolBarDelegator implements ZefyrToolbarDelegate {
  static const kDefaultButtonIcons = {
    ZefyrToolbarAction.bold: Icons.format_bold,
    ZefyrToolbarAction.italic: Icons.format_italic,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
    ZefyrToolbarAction.openInBrowser: Icons.open_in_new,
    ZefyrToolbarAction.image: Icons.image,
    ZefyrToolbarAction.cameraImage: Icons.photo_camera,
    ZefyrToolbarAction.galleryImage: Icons.photo_library,
    ZefyrToolbarAction.close: Icons.close,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
  };

  static const kSpecialIconSizes = {
    ZefyrToolbarAction.unlink: 20.0,
    ZefyrToolbarAction.clipboardCopy: 20.0,
    ZefyrToolbarAction.openInBrowser: 20.0,
    ZefyrToolbarAction.close: 20.0,
    ZefyrToolbarAction.confirm: 20.0,
  };

  static const kDefaultButtonTexts = {
    ZefyrToolbarAction.headingLevel1: 'H1',
    ZefyrToolbarAction.headingLevel2: 'H2',
    ZefyrToolbarAction.headingLevel3: 'H3',
  };

  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {onPressed}) {
    if (kDefaultButtonIcons.containsKey(action)) {
      final icon = kDefaultButtonIcons[action];
      final size = kSpecialIconSizes[action];
      return ZefyrButton.icon(
        action: action,
        icon: icon,
        iconSize: size,
        onPressed: onPressed,
      );
    }
    return Container();
  }
}
