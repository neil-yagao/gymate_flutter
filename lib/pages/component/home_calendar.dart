import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class HomeCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeCalendarState();
  }
}

class HomeCalendarState extends State<HomeCalendar> {
  bool _expanding = false;
  @override
  Widget build(BuildContext context) {
    CalendarCarousel _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        //this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekFormat: !_expanding,
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
      height: _expanding ? 420.0 : 180,
      locale: 'zh',
      showHeader: true,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      markedDateMoreShowTotal:
          false, // null for not showing hidden events indicator
    );
    return Card(
        child: Column(
      children: <Widget>[
        _calendarCarousel,
        Container(
            height: 40,
            child: RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              onPressed: () {
                setState(() {
                  _expanding = !_expanding;
                });
              },
              child: _expanding
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
            )),
      ],
    ));
  }
}
