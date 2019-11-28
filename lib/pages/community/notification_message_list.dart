import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/general/chewie_network_item.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/service/notification_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

class NotificationMessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationMessageListState();
  }
}

class NotificationMessageListState extends State<NotificationMessageList> {
  NotificationService _notificationService;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<NotificationMessage> notificationMessages = List();

  bool inLoading = true;

  User _user;

  int currentPage = 0;

  int totalPage = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _user = Provider
        .of<CurrentUserStore>(context)
        .currentUser;
    _notificationService = NotificationService(_scaffoldKey);
    fetchMessage();
  }

  void fetchMessage() {
    _notificationService.getMyMessage(_user.id, currentPage).then((page) {
      inLoading = false;
      notificationMessages = page.data;
      currentPage = page.page;
      totalPage = page.totalPage;
      setState(() {});
    }).catchError((e) {
      inLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DefaultAppBar.build(context, title: "我的消息"),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text("上一页"),
              onPressed: () {
                if (currentPage > 0) {
                  currentPage = currentPage - 1;
                  fetchMessage();
                }
              },
            ),
            Text((currentPage + 1).toString() + "/" + totalPage.toString()),
            FlatButton(
              child: Text("下一页"),
              onPressed: () {
                if (currentPage < totalPage - 1) {
                  currentPage = currentPage + 1;
                  fetchMessage();
                }
              },
            )
          ],
        ),
      ),
      body: SafeArea(
          child: inLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView(
              children: <Widget>[
          ...notificationMessages.map((msg) => ListTile(
      leading: msg.hasRead
      ? null
          : Container(
          width: 40,
          height: 40,
          child: Center(
              child: CircleAvatar(
                radius: 5,
              ))),
      title: Text(msg.title),
      dense: true,
      subtitle: Text(msg.content),
      onTap: () {
        Map<String, dynamic> contentJson =
        json.decode(msg.attachmentDescription);
        _notificationService
            .markMessageAsRead(msg.id.toString())
            .then((_) {
          setState(() {
            msg.hasRead = true;
          });
        });
        if (contentJson['content_type'] ==
            'UserMovementMaterial') {
          NavigationUtil.pushUsingDefaultFadingTransition(
              context,
              UserMovementMaterialMessage(
                attachmentDescription: contentJson,
              ));
        }
      },
    ))]
    ,
    )
    )
    ,
    );
  }

  Widget emptyShow() {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.inbox,
            color: Colors.grey,
            size: 64,
          ),
          Text(
            "空空如野",
            style: Typography.dense2018.title.merge(
                TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          )
        ],
      ),
    );
  }
}

class UserMovementMaterialMessage extends StatefulWidget {
  final Map<String, dynamic> attachmentDescription;

  const UserMovementMaterialMessage({Key key, this.attachmentDescription})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserMovementMaterialMessageState();
  }
}

class UserMovementMaterialMessageState
    extends State<UserMovementMaterialMessage> {
  final GlobalKey<ScaffoldState> parentKey = GlobalKey();
  MovementService _movementService;

  PersistentBottomSheetController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _movementService = MovementService(parentKey);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: parentKey,
      appBar: DefaultAppBar.build(
        context,
      ),
      body: SafeArea(
        child: FutureBuilder<UserMovementMaterial>(
          initialData: null,
          builder: (context, data) {
            UserMovementMaterial material = data.data;
            if (material == null) {
              return Center(
                child: Container(
                    width: 40, height: 40, child: CircularProgressIndicator()),
              );
            }
            return Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    ChewieNetworkItem(
                      url: material.processedUrl,
                      aspectRatio: material.aspectRatio,
                      landscape: material.landscape,
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              child: InkWell(
                                child: Icon(
                                  Icons.share,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                ),
                                onTap: () {
                                   controller = parentKey.currentState
                                      .showBottomSheet((context) {
                                    return bottomSheet(material.processedUrl);
                                  });
                                },
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            );
          },
          future: _movementService.getUserMovementMaterial(
              widget.attachmentDescription["content_id"]),
        ),
      ),
    );
  }

  Widget bottomSheet(String url ) {
    return Container(
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text("分享给好友"),
            textColor:
            Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              shareVideo(url, WeChatScene.SESSION).then((_){
                controller?.close();
              });
            },
          ),
          FlatButton(
            child: Text("分享至朋友圈"),
            onPressed: () {
              shareVideo(url, WeChatScene.TIMELINE).then((_){
                controller?.close();
              });
            },
          )
        ],
      ),
    );
  }

  Future shareVideo(String url, WeChatScene scene ){
    return registerWxApi(
        appId:
        "wx0ba2504cc150b3f6",
        universalLink:
        "https://www.lifting.ren/")
        .then((val) {
      var video = WeChatShareVideoModel(
          scene: scene,
          transaction: "video",
          thumbnail: "assets://assets/logo.png",
          description: "我训练动作的AI分析",
          title: "GyMate-AI",
          videoUrl: url
      );
      return shareToWeChat(video)
          .catchError((error) {
        showDialog(
            context: context,
            builder: (context) =>
                Card(
                  child: Text(error
                      .toString()),
                ));
      });
    });
  }
}
