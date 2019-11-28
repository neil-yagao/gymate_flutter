import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workout_helper/model/user_event.dart';

import 'basic_dio.dart';

class NotificationService {
  Dio dio;

  NotificationService(GlobalKey<ScaffoldState> _scaffoldKey) {
    dio = DioInstance.getInstance(_scaffoldKey);
  }

  Future<Page<NotificationMessage>> getMyMessage(
      int currentUserId, int currentPage) {
    return dio.get('/notifications/user/' + currentUserId.toString(),
        queryParameters: {
          'currentPage': currentPage,
          'pageSize': DioInstance.DEFAULT_PAGE_SIZE
        }).then((r) {
      var events = Page<NotificationMessage>.empty();
      List<NotificationMessage> userNotifications = List();
      if (r.data != null && r.data['content'] != null) {
        (r.data['content'] as List).forEach(
            (t) => {userNotifications.add(NotificationMessage.fromJson(t))});
        Map<String, dynamic> content = r.data as Map<String, dynamic>;
        events.size = content['totalElements'];
        events.totalPage = content['totalPages'];
        events.page = currentPage;
      }
      events.data = userNotifications;
      return events;
    });
  }

  Future markMessageAsRead(String msgIds) {
    return dio.put('/notifications/' + msgIds);
  }

  Future<int> getUnreadMessageCount(int currentUserId) {
    return dio.get('/notifications/count/' + currentUserId.toString(),
        queryParameters: {'hasRead': false}).then((r) {
      if (r.data == null) {
        return 0;
      }
      return r.data['count'] as int;
    });
  }


}
