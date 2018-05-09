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
                    firstWeekday: one ? DateTime.monday : DateTime.wednesday,
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
