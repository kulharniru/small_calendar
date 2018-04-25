import 'dart:async';
import 'package:flutter/material.dart';

import 'package:small_calendar/small_calendar_page.dart';

void main() {
  runApp(
    new SmallCalendarPageExample(),
  );
}

class SmallCalendarPageExample extends StatefulWidget {
  @override
  _SmallCalendarPageExampleState createState() =>
      new _SmallCalendarPageExampleState();
}

class _SmallCalendarPageExampleState extends State<SmallCalendarPageExample> {
  SmallCalendarDataProvider smallCalendarDataProvider =
      createSmallCalendarDataProvider();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Small Calendar Page Example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Small Calendar Page Example"),
        ),
        body: new Container(
          color: Colors.grey[200],
          child: new Center(
            child: new Container(
              color: Colors.white,
              width: 300.0,
              height: 300.0,
              child: new SmallCalendar(
                month: new DateTime.now(),
                dayStyle: new DayStyle(tick3Color: Colors.orange),
                dataProvider: smallCalendarDataProvider,
                onDaySelected: (DateTime day) {
                  print("Selected: ${day.year}.${day.month}.${day.day}");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

SmallCalendarDataProvider createSmallCalendarDataProvider() {
  Future<bool> isTodayCallback(DateTime day) async {
    DateTime now = new DateTime.now();
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return true;
    }

    return false;
  }

  Future<bool> isSelectedCallback(DateTime day) async {
    if (day.day == 10) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick1Callback(DateTime day) async {
    if (day.day == 1 || day.day == 4 || day.day == 5) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick2Callback(DateTime day) async {
    if (day.day == 2 || day.day == 4 || day.day == 5) {
      return true;
    }

    return false;
  }

  Future<bool> hasTick3Callback(DateTime day) async {
    if (day.day == 3 || day.day == 5) {
      return true;
    }

    return false;
  }

  return new SmallCalendarDataProvider(
    isTodayCallback: isTodayCallback,
    isSelectedCallback: isSelectedCallback,
    hasTick1Callback: hasTick1Callback,
    hasTick2Callback: hasTick2Callback,
    hasTick3Callback: hasTick3Callback,
  );
}
