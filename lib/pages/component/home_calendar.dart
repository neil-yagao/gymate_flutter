import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/plan_service.dart';

class HomeCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeCalendarState();
  }
}

class HomeCalendarState extends State<HomeCalendar> {
  Map<DateTime, List<UserPlannedExercise>> _markedDatesMap = Map();

  PlanService _planService = PlanService(null);
  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;

    _planService
        .getUserPlannedExercise(_currentUser.id)
        .then((List<UserPlannedExercise> plannedExercises) {
      setState(() {
        plannedExercises.forEach((UserPlannedExercise e) {
          _markedDatesMap[e.executeDate] = [e];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat defaultFormat = DateFormat('yyyy-MM-dd');
    CalendarCarousel _calendarCarousel = CalendarCarousel<UserPlannedExercise>(
      onDayPressed: (DateTime date, List<UserPlannedExercise> events) {
        //this.setState(() => _currentDate = date);
        events.forEach((event) => print(event));
      },
      weekDayMargin: EdgeInsets.all(0),
      dayPadding: 0,
      headerMargin: EdgeInsets.only(bottom: 8),
      headerTextStyle: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).primaryColor)
          .merge(Typography.dense2018.subhead),
      weekFormat: false,
      weekendTextStyle: TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      weekdayTextStyle: TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      prevDaysTextStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      nextDaysTextStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      thisMonthDayBorderColor: Colors.grey,
      todayButtonColor: Colors.transparent,
      todayTextStyle:
          TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
      staticSixWeekFormat: true,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      selectedDayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(fontSize: 14.0, color: Colors.teal),
      height: MediaQuery.of(context).size.height * 0.5,
      locale: 'zh',
      showHeader: true,
      markedDateShowIcon: true,
      markedDatesMap: EventList(events: _markedDatesMap),
      markedDateIconMaxShown: 2,
      markedDateIconBuilder: (UserPlannedExercise event) {
        // exercise id == -1 nothing
        if (event.exercise.id == '-1') {
          return Text('');
        } else if (DateTime.now().isBefore(event.executeDate)) {
          //large equal than today default
          return Icon(
            Icons.access_time,
            color: Colors.amber,
          );
        } else if (defaultFormat.format(DateTime.now()) ==
                defaultFormat.format(event.executeDate) &&
            !event.hasBeenExecuted) {
          return Icon(Icons.play_circle_outline, color: Colors.lightBlueAccent);
        } else if (defaultFormat
                    .format(DateTime.now())
                    .compareTo(defaultFormat.format(event.executeDate)) <= 0
                 && event.hasBeenExecuted) {
          return Icon(
            Icons.check,
            color: Colors.greenAccent,
          );
        } else if (DateTime.now().isAfter(event.executeDate) &&
            !event.hasBeenExecuted) {
          return Icon(Icons.close, color: Colors.redAccent);
        }
        // small than today completed checked
        // small than today not completed red cross
        return event.icon;
      },
      markedDateMoreShowTotal:
          false, // null for not showing hidden events indicator
    );
    return _calendarCarousel;
  }
}
