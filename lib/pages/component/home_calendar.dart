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
  @override
  Widget build(BuildContext context) {
    CalendarCarousel _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        //this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekDayMargin:EdgeInsets.all(0),
      dayPadding: 0,
      headerMargin: EdgeInsets.only(bottom: 8),
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
      height:MediaQuery.of(context).size.height * 0.5 ,
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
    return _calendarCarousel;
  }
}
