import 'package:flutter/material.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/community/view_page.dart';
import 'package:workout_helper/pages/movement/movement_detail.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import '../home_page.dart';
import 'event_self_mixin.dart';

class RecommendEvent extends StatefulWidget {
  final UserEvent userEvent;

  const RecommendEvent({Key key, this.userEvent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecommendEventState();
  }
}

class RecommendEventState extends State<RecommendEvent> with SelfEvent {
  CommunityService _communityService;
  MovementService _movementService;

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    _communityService = CommunityService(HomePage.of(context).scaffoldKey);
    _movementService = MovementService(HomePage.of(context).scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    Recommend recommend = widget.userEvent.relatedRecord;

    if(recommend == null){
      return Container();
    }
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(isSelf(context, widget.userEvent)
              ? "我"
              : widget.userEvent.user.name),
          Text("推荐了"),
          Text(recommend.targetOwner.name +
              "的" +
              userEventToChinese(recommend.target)),
          extraInfo(recommend)
        ],
      ),
    );
  }

  Future<Post> getRecommendPost(int postId) {
    return _communityService.getPost(postId);
  }

  Widget extraInfo(Recommend recommend) {
    if (recommend.target == UserEventType.Post) {
      return FutureBuilder<Post>(
        initialData: Post.empty(),
        future: getRecommendPost(recommend.recommendTargetId),
        builder: (context, data) {
          Post post = data.data;
          if(post.title == null){
            return Container();
          }
          return InkWell(
            child: Text(": " + post.title,style: TextStyle(
              color: Theme.of(context).primaryColor
            ),),
            onTap: () {
              NavigationUtil.pushUsingDefaultFadingTransition(context, ViewPage(
                post: post,
                returnTo: HomePage(),
              ));
            },
          );
        },
      );
    }else if (recommend.target == UserEventType.Movement_Material){
      return FutureBuilder<MovementMaterial>(
        future: _movementService.getMovementMaterial(recommend.recommendTargetId),
        builder: (context,data){
          MovementMaterial material = data.data;
          if(material == null){
            return Container();
          }
          return InkWell(
            child: Text(" " + material.movement.name + "素材" ,style: TextStyle(
                color: Theme.of(context).primaryColor
            ),),
            onTap: () {
              NavigationUtil.pushUsingDefaultFadingTransition(context, MovementDetail(
                movement: material.movement,
                designateMaterial: material,
              ));
            },
          );
        },
      );
    }
    return Container();
  }
}
