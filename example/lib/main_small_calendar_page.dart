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
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Small Calendar Page Example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Small Calendar Page Example"),
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new Container(
                color: Colors.grey[200],
                child: new Center(
                  child: new Container(
                    width: 250.0,
                    height: 250.0,
                    color: Colors.white,
                    child: new SmallCalendar(
                      month: new DateTime.now(),
                      dataProvider: createSmallCalendarDataProvider(),
                      weekdayIndicationStyle: new WeekdayIndicationStyle(
                        backgroundColor: Colors.blue[200],
                      ),
                      dayStyle: new DayStyle(
                        tick3Color: Colors.yellow[800],
                      ),
                      onDaySelected: (DateTime date) {
                        print("$date");
                      },
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
                child: new Center(
              child: new Text("a"),
            ))
          ],
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
