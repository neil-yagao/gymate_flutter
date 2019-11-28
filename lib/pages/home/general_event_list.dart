import 'package:flutter/material.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/model/user_event.dart';
import 'package:workout_helper/pages/home/event/session_user_event.dart';
import 'package:workout_helper/pages/profile/user_training_groups.dart';
import 'package:workout_helper/pages/session/session.dart';
import 'package:workout_helper/service/basic_dio.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/movement_service.dart';
import 'package:workout_helper/service/nutrition_service.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:workout_helper/service/user_event_service.dart';
import 'package:workout_helper/util/navigation_util.dart';

import 'event/nutrition_record_event.dart';
import 'event/one_rep_max_event.dart';
import 'event/post_event.dart';
import 'event/recommend_event.dart';
import 'home_page.dart';

class GeneralEventList extends StatefulWidget {
  final List<int> userIds;
  int defaultLoadEventAmount = 10;
  int moreLoadingAmount = 10;
  final Widget defaultEmptyWidget;

  GeneralEventList(
      {Key key,
      this.userIds,
      this.defaultLoadEventAmount = 10,
      this.moreLoadingAmount = 10,
      this.defaultEmptyWidget})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GeneralEventListState();
  }
}

class GeneralEventListState extends State<GeneralEventList> {
  SessionService _sessionService;
  NutritionService _nutritionService;
  MovementService _movementService;
  CommunityService _communityService;
  UserEventService _userEventService;

  List<UserEvent> loadedList = List();
  int currentLoadingAmount;

  int nextPage = 0;
  int totalEvents = 0;

  List<int> loadedPage = List();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!this.mounted) {
      return;
    }
    _sessionService = SessionService(HomePage.of(context).scaffoldKey);
    _nutritionService = NutritionService(HomePage.of(context).scaffoldKey);
    _communityService = CommunityService(HomePage.of(context).scaffoldKey);
    _movementService = MovementService(HomePage.of(context).scaffoldKey);
    setState(() {
      this.currentLoadingAmount = widget.defaultLoadEventAmount;
    });
    _userEventService = UserEventService(HomePage.of(context).scaffoldKey);
    loadMoreEvents();
  }

  void loadMoreEvents() {
    //todo further determine loaded list based on timestamp
    if (loadedList == null) {
      loadedList = List();
    }
    if (loadedPage.contains(nextPage) && !(nextPage == 0 && loadedList.isEmpty)){
      return;
    }
    _userEventService
        .getUserReadableEvent(widget.userIds ?? [], nextPage)
        .then((events) {

      if (events.data == null) {
        return;
      }
      loadedList.addAll(events.data);
      Map<int, UserEvent> uniqueFilter = Map();
      loadedList.forEach((ue) {
        uniqueFilter.putIfAbsent(ue.id, () => ue);
      });
      loadedList = uniqueFilter.values.toList();
      if (events.totalPage > nextPage) {
        nextPage = events.page + 1;
      }
      totalEvents = events.size;
      if (!this.mounted) {
        return;
      }
      setState(() {});
    });
    loadedPage.add(nextPage);
  }

  @override
  Widget build(BuildContext context) {
    if (!this.mounted) {
      return emptyShow();
    }
    return isEmpty()
        ? widget.defaultEmptyWidget ?? emptyShow()
        : ListView.builder(
            itemBuilder: (context, index) {
              if (index >= loadedList.length - 5 &&
                  index >= DioInstance.DEFAULT_PAGE_SIZE) {
                loadMoreEvents();
              }
              if (index > totalEvents - 1) {
                return bottomLine();
              }
              try {
                return getEventWidget(loadedList.elementAt(index));
              } catch (e) {
                debugPrint(e.toString());
                return bottomLine(content: "正在加载");
              }
            },
            itemCount: totalEvents + 1,
            shrinkWrap: true,
          );
  }

  Widget bottomLine({String content = "已经到底线了"}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text(content),
          textColor: Theme.of(context).primaryColor,
          onPressed: null,
        )
      ],
    );
  }

  Widget getEventWidget(UserEvent ue) {
    switch (ue.type) {
      case UserEventType.Session:
        if (ue.relatedRecord == null)
          return FutureBuilder<Session>(
            future: _sessionService.getSessionById(ue.relatedRecordId),
            builder: (context, data) {
              ue.relatedRecord = data.data;
              return SessionUserEvent(
                userEvent: ue,
              );
            },
          );
        else {
          return SessionUserEvent(
            userEvent: ue,
          );
        }
        break;
      case UserEventType.NutritionRecord:
        if (ue.relatedRecord == null)
          return FutureBuilder<NutritionRecord>(
            future: _nutritionService.getNutritionRecord(ue.relatedRecordId),
            builder: (context, data) {
              ue.relatedRecord = data.data;
              return NutritionRecordEvent(
                userEvent: ue,
              );
            },
          );
        else {
          return NutritionRecordEvent(
            userEvent: ue,
          );
        }
        break;
      case UserEventType.OneRepMax:
        if (ue.relatedRecord == null)
          return FutureBuilder<MovementOneRepMax>(
            future: _movementService.getMovementOneRepMax(ue.relatedRecordId),
            builder: (context, data) {
              ue.relatedRecord = data.data;
              return OneRepMaxEvent(
                userEvent: ue,
              );
            },
          );
        else {
          return OneRepMaxEvent(
            userEvent: ue,
          );
        }
        break;
      case UserEventType.Post:
        if (ue.relatedRecord == null)
          return FutureBuilder<Post>(
            future: _communityService.getPost(ue.relatedRecordId),
            builder: (context, data) {
              ue.relatedRecord = data.data;
              return PostEvent(
                userEvent: ue,
              );
            },
          );
        else {
          return PostEvent(
            userEvent: ue,
          );
        }
        break;
      case UserEventType.Reply:
        // TODO: Handle this case.
        break;
      case UserEventType.Question:
        // TODO: Handle this case.
        break;
      case UserEventType.QuestionReply:
        // TODO: Handle this case.
        break;
      case UserEventType.QuestionApplyAccepted:
        // TODO: Handle this case.
        break;
      case UserEventType.Recommended:
        if (ue.relatedRecord == null)
          return FutureBuilder<Recommend>(
            future: _communityService.getRecommend(ue.relatedRecordId),
            builder: (context, data) {
              ue.relatedRecord = data.data;
              return RecommendEvent(
                userEvent: ue,
              );
            },
          );
        else {
          return RecommendEvent(
            userEvent: ue,
          );
        }
        break;
      case UserEventType.BeRecommended:
        // TODO: Handle this case.
        break;
      case UserEventType.Exercise:
        // TODO: Handle this case.
        break;
      case UserEventType.Movement:
        // TODO: Handle this case.
        break;
      case UserEventType.TrainingPlan:
        // TODO: Handle this case.
        break;
      case UserEventType.Movement_Material:
        // TODO: Handle this case.
        break;
    }
    return Container();
  }

  bool isEmpty() {
    return (loadedList == null || loadedList.isEmpty);
  }

  Widget emptyShow() {
    return InkWell(
      onTap: () {
        NavigationUtil.pushUsingDefaultFadingTransition(
            context, UserTrainingGroups());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.group,
            color: Colors.grey,
            size: 64,
          ),
          Text(
            "尚未加入小组？",
            style: Typography.dense2018.title.merge(
                TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
