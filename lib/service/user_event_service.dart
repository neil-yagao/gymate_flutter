import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/user_event.dart';

import 'basic_dio.dart';

class UserEventService {
  Dio dio;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  UserEventService(this._scaffoldKey) {
    dio = DioInstance.getInstance(_scaffoldKey);
  }

  Future<Pagable<UserEvent>> getUserReadableEvent(
      List<int> userId, int page) async {
    if(userId.isEmpty){
      return Pagable.empty();
    }
    return dio.get('/user_event', queryParameters: {
      'users': userId.join(","),
      'pageSize': DioInstance.DEFAULT_PAGE_SIZE,
      'currentPage': page
    }).then((r) {
      var events = Pagable<UserEvent>.empty();
      List<UserEvent> userEvents = List();
      if (r.data != null && r.data['content'] != null) {
        (r.data['content'] as List)
            .forEach((t) => {userEvents.add(UserEvent.fromJson(t))});
        Map<String, dynamic> content = r.data as Map<String, dynamic>;
        events.size = content['totalElements'];
        events.totalPage = content['totalPages'];
        events.page = page;
      }
      events.data = userEvents;
      return events;
    });
  }
}
