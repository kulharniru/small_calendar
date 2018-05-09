import 'dart:async';

import 'package:flutter/material.dart';

import 'package:small_calendar/small_calendar.dart';

void main() {
  runApp(
    new SmallCalendarExample(),
  );
}

class SmallCalendarExample extends StatefulWidget {
  @override
  _SmallCalendarExampleState createState() => new _SmallCalendarExampleState();
}

class _SmallCalendarExampleState extends State<SmallCalendarExample> {
  String displayedMonthText;

  SmallCalendarPagerController _smallCalendarPagerController;
  SmallCalendarDataProvider _smallCalendarDataProvider;

  bool one = true;

  @override
  void initState() {
    super.initState();

    DateTime initialMonth = new DateTime.now();
    DateTime minimumMonth =
        new DateTime(initialMonth.year - 1, initialMonth.month);
    DateTime maximumMonth =
        new DateTime(initialMonth.year + 1, initialMonth.month);

    _smallCalendarPagerController = new SmallCalendarPagerController(
      initialMonth: initialMonth,
      minimumMonth: minimumMonth,
      maximumMonth: maximumMonth,
    );

    _smallCalendarDataProvider = createSmallCalendarDataProvider();

    _updateDisplayedMonthText();
  }

  void _updateDisplayedMonthText() {
    setState(() {
      DateTime displayedMonth = _smallCalendarPagerController.displayedMonth;

      displayedMonthText =
          "Displayed Month: ${displayedMonth.year}.${displayedMonth.month}";
    });
  }

  Future<bool> _isTodayCallback(DateTime date) async {
    return date.day == 1;
  }

  Future<bool> _isTodayCallback2(DateTime date) async {
    await new Future.delayed(new Duration(seconds: 3));

    return date.day == 2;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Small Calendar example",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Small Calendar example"),
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
                  child: new SmallCalendarData(
                    isTodayCallback: one ? _isTodayCallback : _isTodayCallback2,
                    child: new SmallCalendarPager(
                      controller: _smallCalendarPagerController,
                      pageBuilder: (BuildContext context, DateTime month) {
                        return new SmallCalendar(
                          month: month,
                          showWeekdayIndication: true,
                          weekdayIndicationStyle: new WeekdayIndicationStyle(),
                          dayStyle: new DayStyle(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )),
            new Expanded(
                child: new Container(
                    margin: new EdgeInsets.symmetric(vertical: 16.0),
                    child: new SingleChildScrollView(
                      child: new Column(
                        children: <Widget>[
                          new Text(displayedMonthText),
                          new RaisedButton(onPressed: () {
                            setState(() {
                              one = !one;
                            });
                          })
                        ],
                      ),
                    ))),
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
      await new Future.delayed(new Duration(seconds: 3));
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
